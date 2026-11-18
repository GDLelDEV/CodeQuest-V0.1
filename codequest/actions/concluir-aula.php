<?php
declare(strict_types=1);
require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../includes/xp.php';
require_once __DIR__ . '/../includes/progresso.php';

exigir_post_csrf('cursos.php');
$usuario = exigir_login();
$uid = (int) $usuario['id'];
$aulaId = (int) ($_POST['aula_id'] ?? 0);   // o ÚNICO dado vindo do navegador; XP vem do banco

$pdo = conectar();
$voltar = 'cursos.php';

try {
    $pdo->beginTransaction();

    // Trava a linha do usuário: duas requisições simultâneas ficam em fila (sem XP duplicado).
    $pdo->prepare('SELECT id FROM usuarios WHERE id = :id FOR UPDATE')->execute([':id' => $uid]);

    $st = $pdo->prepare(
        'SELECT a.id, a.titulo, a.xp_recompensa, m.id AS modulo_id, m.titulo AS modulo_titulo,
                m.curso_id, c.titulo AS curso_titulo
           FROM aulas a
           JOIN modulos m ON m.id = a.modulo_id
           JOIN cursos c ON c.id = m.curso_id
          WHERE a.id = :id AND c.ativo = 1'
    );
    $st->execute([':id' => $aulaId]);
    $aula = $st->fetch();

    if (!$aula) {
        $pdo->rollBack();
        flash('erro', 'Aula não encontrada.');
        redirecionar(url($voltar));
    }

    $voltar = 'aula.php?id=' . $aulaId;
    $lista = aulas_do_curso($pdo, (int) $aula['curso_id'], $uid);
    $atual = null;
    foreach ($lista as $item) {
        if ((int) $item['id'] === $aulaId) {
            $atual = $item;
            break;
        }
    }

    if ($atual === null || !$atual['liberada']) {
        $pdo->rollBack();
        flash('erro', 'Conclua a aula anterior para liberar esta.');
        redirecionar(url('curso.php?id=' . (int) $aula['curso_id']));
    }
    if ($atual['concluida']) {
        $pdo->rollBack();
        flash('erro', 'Você já concluiu esta aula. O XP é concedido apenas uma vez.');
        redirecionar(url($voltar));
    }

    // 1) Registra a conclusão (UNIQUE usuario+aula é a segunda barreira contra duplicidade)
    $pdo->prepare(
        'INSERT INTO progresso_aulas (usuario_id, aula_id, concluida, data_conclusao) VALUES (:u, :a, 1, NOW())'
    )->execute([':u' => $uid, ':a' => $aulaId]);

    // 2) XP da aula
    $total_xp = (int) $aula['xp_recompensa'];
    $r = conceder_xp($pdo, $uid, $total_xp, 'aula_concluida', 'Aula concluída: ' . $aula['titulo']);
    registrar_estudo($pdo, $uid);
    $nivel_final = $r['nivel_depois'];
    $partes = ['Aula concluída! +' . $total_xp . ' XP'];

    // 3) Bônus de módulo e de curso (uma única vez cada)
    $lista = aulas_do_curso($pdo, (int) $aula['curso_id'], $uid);
    $modulo_ok = true;
    $curso_ok = true;
    foreach ($lista as $item) {
        if (!$item['concluida']) {
            $curso_ok = false;
            if ((int) $item['modulo_id'] === (int) $aula['modulo_id']) {
                $modulo_ok = false;
            }
        }
    }
    if ($modulo_ok && !atividade_ja_registrada($pdo, $uid, 'modulo:' . $aula['modulo_id'])) {
        $r = conceder_xp($pdo, $uid, 50, 'modulo:' . $aula['modulo_id'], 'Módulo concluído: ' . $aula['modulo_titulo']);
        $total_xp += 50;
        $nivel_final = $r['nivel_depois'];
        $partes[] = 'Módulo concluído! +50 XP';
    }
    if ($curso_ok && !atividade_ja_registrada($pdo, $uid, 'curso:' . $aula['curso_id'])) {
        $r = conceder_xp($pdo, $uid, 100, 'curso:' . $aula['curso_id'], 'Curso concluído: ' . $aula['curso_titulo']);
        $total_xp += 100;
        $nivel_final = $r['nivel_depois'];
        $partes[] = 'Curso concluído! +100 XP 🏁';
    }

    $pdo->commit();

    if ($nivel_final > calcular_nivel((int) $usuario['xp_total'])) {
        $partes[] = 'Você subiu para o nível ' . $nivel_final . '! 🚀';
    }
    flash('sucesso', implode(' · ', $partes));
} catch (Throwable $ex) {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    error_log('[CodeQuest] Erro ao concluir aula: ' . get_class($ex) . ' - ' . $ex->getMessage()
        . ' (' . basename($ex->getFile()) . ':' . $ex->getLine() . ')');
    if (config('APP_DEBUG', false)) {
        // Somente no seu computador (APP_DEBUG = true): mostra o motivo real do erro.
        flash('erro', 'ERRO TÉCNICO: ' . get_class($ex) . ' - ' . $ex->getMessage()
            . ' [' . basename($ex->getFile()) . ':' . $ex->getLine() . ']');
    } else {
        flash('erro', 'Não foi possível concluir a aula agora. Tente novamente.');
    }
}

redirecionar(url($voltar));