<?php
declare(strict_types=1);
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/queries.php';

$usuario = exigir_login();
$pdo = conectar();
$uid = (int) $usuario['id'];

// Todos os dados vêm do banco (nada de números fictícios).
$xp        = (int) $usuario['xp_total'];
$prog      = progresso_nivel($xp);
$aulas     = total_aulas_concluidas($pdo, $uid);
$desafios  = total_desafios_resolvidos($pdo, $uid);
$cursos    = cursos_com_progresso($pdo, $uid);
$proxima   = proxima_aula($pdo, $uid);
$missoes   = missoes_do_dia($pdo, $uid);
$conquistas = conquistas_recentes($pdo, $uid);
$top3      = ranking_top($pdo, 3);
$posicao   = posicao_ranking($pdo, $usuario);

$titulo = 'Dashboard';
$pagina_ativa = 'dashboard';
$js = ['dashboard.js'];
require __DIR__ . '/includes/header.php';
?>
<section class="grade">

  <!-- Boas-vindas + barra de evolução -->
  <article class="card col-12 boas-vindas">
    <span class="avatar avatar-g"><?= e(iniciais($usuario['nome'])) ?></span>
    <div class="bv-texto">
      <h2>Olá, <?= e(primeiro_nome($usuario['nome'])) ?>! 👋</h2>
      <p class="texto2">
        <?= $aulas === 0 && $desafios === 0
            ? 'Sua jornada está só começando. Complete sua primeira aula para ganhar XP!'
            : 'Continue assim! Cada aula e desafio te aproxima do próximo nível.' ?>
      </p>
      <div class="evolucao">
        <div class="evolucao-topo">
          <strong>Nível <?= $prog['nivel'] ?></strong>
          <span class="texto2"><?= $prog['xp_no_nivel'] ?> / <?= $prog['xp_necessario'] ?> XP · <?= $prog['percentual'] ?>%</span>
        </div>
        <div class="barra" role="progressbar" aria-valuenow="<?= $prog['percentual'] ?>" aria-valuemin="0" aria-valuemax="100">
          <div class="barra-fill" style="width:<?= $prog['percentual'] ?>%" data-valor="<?= $prog['percentual'] ?>"></div>
        </div>
        <small class="texto2">Faltam <?= $prog['xp_proximo'] - $xp ?> XP para o nível <?= $prog['nivel'] + 1 ?></small>
      </div>
    </div>
  </article>

  <!-- Resumo de desempenho -->
  <article class="card stat col-3"><span class="stat-ico amarelo">⭐</span><strong data-contar="<?= $xp ?>"><?= $xp ?></strong><span class="texto2">XP total</span></article>
  <article class="card stat col-3"><span class="stat-ico roxo">🚀</span><strong data-contar="<?= $prog['nivel'] ?>"><?= $prog['nivel'] ?></strong><span class="texto2">Nível atual</span></article>
  <article class="card stat col-3"><span class="stat-ico azul">📖</span><strong data-contar="<?= $aulas ?>"><?= $aulas ?></strong><span class="texto2">Aulas concluídas</span></article>
  <article class="card stat col-3"><span class="stat-ico verde">🎯</span><strong data-contar="<?= $desafios ?>"><?= $desafios ?></strong><span class="texto2">Desafios resolvidos</span></article>

  <!-- Continuar aprendendo -->
  <article class="card col-6">
    <h3 class="card-titulo">Continuar aprendendo</h3>
    <?php if ($proxima): ?>
      <p class="texto2"><?= e($proxima['curso']) ?> · <?= e($proxima['modulo']) ?></p>
      <p class="destaque-aula"><?= e($proxima['titulo']) ?></p>
      <a class="btn btn-primario" href="<?= e(url('aula.php?id=' . (int) $proxima['id'])) ?>">Continuar ▶</a>
    <?php else: ?>
      <div class="vazio vazio-p"><span class="vazio-ico">🎉</span><p class="texto2">Você concluiu todas as aulas disponíveis!</p></div>
    <?php endif; ?>
  </article>

  <!-- Ranking resumido -->
  <article class="card col-6">
    <h3 class="card-titulo">Ranking</h3>
    <p class="texto2"><?= $posicao !== null ? 'Você está em <strong class="destaque">' . $posicao . 'º lugar</strong>' : 'Administradores não participam do ranking.' ?></p>
    <?php if ($top3): ?>
      <ol class="rank-lista">
        <?php foreach ($top3 as $i => $r): ?>
          <li class="rank-item<?= (int) $r['id'] === $uid ? ' eu' : '' ?>">
            <span class="rank-pos"><?= ['🥇', '🥈', '🥉'][$i] ?? ($i + 1) ?></span>
            <span class="avatar avatar-p"><?= e(iniciais($r['nome'])) ?></span>
            <span class="rank-nome"><?= e($r['nome']) ?><small class="texto2"> Nível <?= calcular_nivel((int) $r['xp_total']) ?></small></span>
            <strong class="amarelo-txt"><?= number_format((int) $r['xp_total'], 0, ',', '.') ?> XP</strong>
          </li>
        <?php endforeach; ?>
      </ol>
    <?php else: ?>
      <div class="vazio vazio-p"><p class="texto2">Ainda não há estudantes no ranking.</p></div>
    <?php endif; ?>
  </article>

  <!-- Seus cursos -->
  <article class="card col-8">
    <h3 class="card-titulo">Seus cursos</h3>
    <?php if ($cursos): ?>
      <div class="cursos-prog">
        <?php foreach ($cursos as $c):
            $total = (int) $c['total_aulas'];
            $pct = $total > 0 ? (int) floor(((int) $c['concluidas'] / $total) * 100) : 0; ?>
          <a class="curso-prog" href="<?= e(url('curso.php?id=' . (int) $c['id'])) ?>">
            <span class="curso-ico"><?= e($c['icone'] ?? '📘') ?></span>
            <div class="curso-info">
              <div class="curso-linha"><strong><?= e($c['titulo']) ?></strong><span class="texto2"><?= (int) $c['concluidas'] ?>/<?= $total ?> aulas · <?= $pct ?>%</span></div>
              <div class="barra barra-fina"><div class="barra-fill verde" style="width:<?= $pct ?>%" data-valor="<?= $pct ?>"></div></div>
            </div>
          </a>
        <?php endforeach; ?>
      </div>
    <?php else: ?>
      <div class="vazio vazio-p"><p class="texto2">Nenhum curso disponível no momento.</p></div>
    <?php endif; ?>
  </article>

  <!-- Conquistas recentes -->
  <article class="card col-4">
    <h3 class="card-titulo">Conquistas recentes</h3>
    <?php if ($conquistas): ?>
      <ul class="conq-lista">
        <?php foreach ($conquistas as $q): ?>
          <li class="conq-item"><span class="conq-ico"><?= e($q['icone'] ?? '🏅') ?></span><div><strong><?= e($q['titulo']) ?></strong><small class="texto2"><?= e($q['descricao'] ?? '') ?></small></div></li>
        <?php endforeach; ?>
      </ul>
    <?php else: ?>
      <div class="vazio vazio-p"><span class="vazio-ico">🏆</span><p class="texto2">Nenhuma conquista ainda. Conclua sua primeira aula!</p></div>
    <?php endif; ?>
  </article>

  <!-- Missões diárias -->
  <article class="card col-12">
    <h3 class="card-titulo">Missões diárias</h3>
    <?php if ($missoes): ?>
      <div class="missoes">
        <?php foreach ($missoes as $m):
            $meta = max(1, (int) $m['meta']);
            $pg = min((int) $m['progresso'], $meta);
            $pct = (int) floor($pg / $meta * 100); ?>
          <div class="missao<?= $m['concluida'] ? ' feita' : '' ?>">
            <div class="missao-topo"><strong><?= e($m['titulo']) ?></strong><span class="chip chip-xp">+<?= (int) $m['xp_recompensa'] ?> XP</span></div>
            <p class="texto2"><?= e($m['descricao'] ?? '') ?></p>
            <div class="barra barra-fina"><div class="barra-fill amarelo" style="width:<?= $pct ?>%" data-valor="<?= $pct ?>"></div></div>
            <small class="texto2"><?= $pg ?>/<?= $meta ?><?= $m['concluida'] ? ' · Concluída ✔' : '' ?></small>
          </div>
        <?php endforeach; ?>
      </div>
    <?php else: ?>
      <div class="vazio vazio-p"><p class="texto2">Nenhuma missão ativa hoje.</p></div>
    <?php endif; ?>
  </article>

</section>
<?php require __DIR__ . '/includes/footer.php'; ?>
