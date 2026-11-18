<?php
declare(strict_types=1);

/** Consultas e regras de cursos, módulos, aulas e desbloqueio progressivo. */

/** Cursos ativos com nº de módulos, de aulas e quantas o usuário concluiu. */
function cursos_lista(PDO $pdo, int $uid): array
{
    $st = $pdo->prepare(
        'SELECT c.id, c.titulo, c.descricao, c.icone, c.linguagem, c.dificuldade,
                COUNT(DISTINCT m.id) AS qtd_modulos,
                COUNT(a.id) AS total_aulas,
                COALESCE(SUM(CASE WHEN p.concluida = 1 THEN 1 ELSE 0 END), 0) AS concluidas
           FROM cursos c
           LEFT JOIN modulos m ON m.curso_id = c.id
           LEFT JOIN aulas a ON a.modulo_id = m.id
           LEFT JOIN progresso_aulas p ON p.aula_id = a.id AND p.usuario_id = :u
          WHERE c.ativo = 1
          GROUP BY c.id, c.titulo, c.descricao, c.icone, c.linguagem, c.dificuldade
          ORDER BY c.id'
    );
    $st->execute([':u' => $uid]);
    return $st->fetchAll();
}

function carregar_curso(PDO $pdo, int $cursoId): ?array
{
    $st = $pdo->prepare('SELECT id, titulo, descricao, icone, linguagem, dificuldade FROM cursos WHERE id = :id AND ativo = 1');
    $st->execute([':id' => $cursoId]);
    return $st->fetch() ?: null;
}

/**
 * Todas as aulas do curso, na ordem (módulo > aula), com:
 *  - concluida: o usuário já concluiu?
 *  - liberada:  a aula anterior (do curso inteiro) está concluída? (a primeira sempre está)
 */
function aulas_do_curso(PDO $pdo, int $cursoId, int $uid): array
{
    $st = $pdo->prepare(
        'SELECT a.id, a.titulo, a.xp_recompensa,
                m.id AS modulo_id, m.titulo AS modulo_titulo, m.descricao AS modulo_descricao, m.ordem AS modulo_ordem,
                (p.id IS NOT NULL) AS concluida
           FROM aulas a
           JOIN modulos m ON m.id = a.modulo_id
           LEFT JOIN progresso_aulas p ON p.aula_id = a.id AND p.usuario_id = :u AND p.concluida = 1
          WHERE m.curso_id = :c
          ORDER BY m.ordem, a.ordem'
    );
    $st->execute([':u' => $uid, ':c' => $cursoId]);
    $aulas = $st->fetchAll();

    $anterior_concluida = true;
    foreach ($aulas as &$a) {
        $a['concluida'] = (bool) $a['concluida'];
        $a['liberada']  = $anterior_concluida;
        $anterior_concluida = $a['concluida'];
    }
    unset($a);
    return $aulas;
}

/** Agrupa as aulas por módulo e calcula o estado de cada módulo. */
function agrupar_modulos(array $aulas): array
{
    $modulos = [];
    foreach ($aulas as $a) {
        $id = (int) $a['modulo_id'];
        if (!isset($modulos[$id])) {
            $modulos[$id] = ['id' => $id, 'titulo' => $a['modulo_titulo'], 'descricao' => $a['modulo_descricao'], 'aulas' => []];
        }
        $modulos[$id]['aulas'][] = $a;
    }
    foreach ($modulos as &$m) {
        $total = count($m['aulas']);
        $feitas = count(array_filter($m['aulas'], static fn($x) => $x['concluida']));
        $m['total'] = $total;
        $m['concluidas'] = $feitas;
        $m['percentual'] = $total > 0 ? (int) floor($feitas / $total * 100) : 0;
        if ($feitas === $total && $total > 0) {
            $m['estado'] = 'concluido';
        } elseif ($feitas > 0) {
            $m['estado'] = 'andamento';
        } elseif ($m['aulas'][0]['liberada'] ?? false) {
            $m['estado'] = 'disponivel';
        } else {
            $m['estado'] = 'bloqueado';
        }
    }
    unset($m);
    return array_values($modulos);
}

/** Estado de uma aula: concluida | disponivel | bloqueada. */
function estado_aula(array $aula): string
{
    if ($aula['concluida']) {
        return 'concluida';
    }
    return $aula['liberada'] ? 'disponivel' : 'bloqueada';
}

/** Texto simples (com linhas em branco) -> parágrafos HTML escapados. */
function texto_para_html(?string $texto): string
{
    $html = '';
    foreach (preg_split('/\n{2,}/', trim((string) $texto)) ?: [] as $par) {
        if (trim($par) !== '') {
            $html .= '<p>' . nl2br(e(trim($par))) . '</p>';
        }
    }
    return $html;
}
