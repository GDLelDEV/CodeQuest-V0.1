<?php
declare(strict_types=1);

/**
 * Consultas reutilizáveis (todas com prepared statements).
 * Somente leitura: o XP é alterado exclusivamente pelo backend nas ETAPAS 4 a 6.
 */

function total_aulas_concluidas(PDO $pdo, int $uid): int
{
    $st = $pdo->prepare('SELECT COUNT(*) FROM progresso_aulas WHERE usuario_id = :u AND concluida = 1');
    $st->execute([':u' => $uid]);
    return (int) $st->fetchColumn();
}

function total_desafios_resolvidos(PDO $pdo, int $uid): int
{
    $st = $pdo->prepare('SELECT COUNT(DISTINCT desafio_id) FROM tentativas WHERE usuario_id = :u AND acertou = 1');
    $st->execute([':u' => $uid]);
    return (int) $st->fetchColumn();
}

/** Cursos ativos com total de aulas e quantas o usuário já concluiu. */
function cursos_com_progresso(PDO $pdo, int $uid): array
{
    $st = $pdo->prepare(
        'SELECT c.id, c.titulo, c.icone, c.linguagem, c.dificuldade,
                COUNT(a.id) AS total_aulas,
                COALESCE(SUM(CASE WHEN p.concluida = 1 THEN 1 ELSE 0 END), 0) AS concluidas
           FROM cursos c
           LEFT JOIN modulos m ON m.curso_id = c.id
           LEFT JOIN aulas a ON a.modulo_id = m.id
           LEFT JOIN progresso_aulas p ON p.aula_id = a.id AND p.usuario_id = :u
          WHERE c.ativo = 1
          GROUP BY c.id, c.titulo, c.icone, c.linguagem, c.dificuldade
          ORDER BY c.id'
    );
    $st->execute([':u' => $uid]);
    return $st->fetchAll();
}

/** Primeira aula ainda não concluída, seguindo a ordem curso > módulo > aula. */
function proxima_aula(PDO $pdo, int $uid): ?array
{
    $st = $pdo->prepare(
        'SELECT a.id, a.titulo, m.titulo AS modulo, c.titulo AS curso
           FROM aulas a
           JOIN modulos m ON m.id = a.modulo_id
           JOIN cursos c ON c.id = m.curso_id
           LEFT JOIN progresso_aulas p ON p.aula_id = a.id AND p.usuario_id = :u AND p.concluida = 1
          WHERE c.ativo = 1 AND p.id IS NULL
          ORDER BY c.id, m.ordem, a.ordem
          LIMIT 1'
    );
    $st->execute([':u' => $uid]);
    return $st->fetch() ?: null;
}

function missoes_do_dia(PDO $pdo, int $uid): array
{
    $st = $pdo->prepare(
        'SELECT ms.id, ms.titulo, ms.descricao, ms.meta, ms.xp_recompensa,
                COALESCE(um.progresso, 0) AS progresso,
                COALESCE(um.concluida, 0) AS concluida
           FROM missoes ms
           LEFT JOIN usuario_missoes um
                  ON um.missao_id = ms.id AND um.usuario_id = :u AND um.data_referencia = :hoje
          WHERE ms.ativa = 1
          ORDER BY ms.id'
    );
    $st->execute([':u' => $uid, ':hoje' => date('Y-m-d')]);
    return $st->fetchAll();
}

function conquistas_recentes(PDO $pdo, int $uid, int $limite = 4): array
{
    $st = $pdo->prepare(
        'SELECT c.titulo, c.icone, c.descricao, uc.data_desbloqueio
           FROM usuario_conquistas uc
           JOIN conquistas c ON c.id = uc.conquista_id
          WHERE uc.usuario_id = :u
          ORDER BY uc.data_desbloqueio DESC, uc.id DESC
          LIMIT ' . max(1, $limite)
    );
    $st->execute([':u' => $uid]);
    return $st->fetchAll();
}

/** Ranking de estudantes por XP (empate: quem se cadastrou primeiro). */
function ranking_top(PDO $pdo, int $limite = 3): array
{
    $st = $pdo->query(
        "SELECT id, nome, username, xp_total, nivel
           FROM usuarios WHERE tipo_usuario = 'student'
          ORDER BY xp_total DESC, id ASC
          LIMIT " . max(1, $limite)
    );
    return $st->fetchAll();
}

/** Posição do estudante no ranking (null para administradores). */
function posicao_ranking(PDO $pdo, array $usuario): ?int
{
    if ($usuario['tipo_usuario'] !== 'student') {
        return null;
    }
    $st = $pdo->prepare(
        "SELECT COUNT(*) + 1 FROM usuarios
          WHERE tipo_usuario = 'student'
            AND (xp_total > :xp OR (xp_total = :xp2 AND id < :id))"
    );
    $st->execute([':xp' => $usuario['xp_total'], ':xp2' => $usuario['xp_total'], ':id' => $usuario['id']]);
    return (int) $st->fetchColumn();
}
