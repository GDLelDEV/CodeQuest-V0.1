<?php
declare(strict_types=1);
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/progresso.php';

$usuario = exigir_login();
$pdo = conectar();
$curso = carregar_curso($pdo, (int) ($_GET['id'] ?? 0));
if (!$curso) {
    flash('erro', 'Curso não encontrado.');
    redirecionar(url('cursos.php'));
}

$aulas = aulas_do_curso($pdo, (int) $curso['id'], (int) $usuario['id']);
$modulos = agrupar_modulos($aulas);
$total = count($aulas);
$feitas = count(array_filter($aulas, static fn($a) => $a['concluida']));
$pct = $total > 0 ? (int) floor($feitas / $total * 100) : 0;

// próxima aula a estudar = primeira liberada e não concluída
$proxima = null;
foreach ($aulas as $a) {
    if ($a['liberada'] && !$a['concluida']) { $proxima = $a; break; }
}

$estados_modulo = [
    'concluido' => ['Concluído', 'verde'], 'andamento' => ['Em andamento', 'roxo'],
    'disponivel' => ['Disponível', 'azul'], 'bloqueado' => ['Bloqueado', 'cinza'],
];

$titulo = $curso['titulo'];
$pagina_ativa = 'cursos';
$css = ['courses.css'];
require __DIR__ . '/includes/header.php';
?>
<a class="voltar" href="<?= e(url('cursos.php')) ?>">← Todos os cursos</a>

<section class="card curso-topo">
  <span class="curso-box-ico grande"><?= e($curso['icone'] ?? '📘') ?></span>
  <div class="curso-topo-info">
    <div class="curso-topo-chips"><span class="chip"><?= e($curso['dificuldade'] ?? '') ?></span><span class="chip"><?= count($modulos) ?> módulos</span><span class="chip"><?= $total ?> aulas</span></div>
    <h2><?= e($curso['titulo']) ?></h2>
    <p class="texto2"><?= e($curso['descricao'] ?? '') ?></p>
    <div class="evolucao-topo"><strong>Seu progresso</strong><span class="texto2"><?= $feitas ?>/<?= $total ?> aulas · <?= $pct ?>%</span></div>
    <div class="barra"><div class="barra-fill verde" style="width:<?= $pct ?>%" data-valor="<?= $pct ?>"></div></div>
  </div>
  <?php if ($proxima): ?>
    <a class="btn btn-primario btn-lg" href="<?= e(url('aula.php?id=' . (int) $proxima['id'])) ?>"><?= $feitas > 0 ? 'Continuar' : 'Começar' ?> ▶</a>
  <?php else: ?>
    <span class="chip chip-xp">🏁 Curso concluído</span>
  <?php endif; ?>
</section>

<section class="modulos">
<?php foreach ($modulos as $i => $m): [$rot, $cor] = $estados_modulo[$m['estado']]; ?>
  <article class="card modulo modulo-<?= e($m['estado']) ?>">
    <header class="modulo-topo">
      <span class="modulo-num"><?= $i + 1 ?></span>
      <div class="modulo-tit">
        <h3><?= e($m['titulo']) ?></h3>
        <p class="texto2"><?= e($m['descricao'] ?? '') ?></p>
      </div>
      <span class="estado estado-<?= $cor ?>"><?= $rot ?></span>
    </header>
    <div class="barra barra-fina"><div class="barra-fill verde" style="width:<?= $m['percentual'] ?>%" data-valor="<?= $m['percentual'] ?>"></div></div>
    <ul class="aulas-lista">
<?php foreach ($m['aulas'] as $a): $est = estado_aula($a); ?>
      <li class="aula-item aula-<?= $est ?>">
<?php if ($est === 'bloqueada'): ?>
        <span class="aula-ico">🔒</span><span class="aula-nome"><?= e($a['titulo']) ?></span>
        <span class="estado estado-cinza">Bloqueada</span>
<?php else: ?>
        <a class="aula-link" href="<?= e(url('aula.php?id=' . (int) $a['id'])) ?>">
          <span class="aula-ico"><?= $est === 'concluida' ? '✅' : '▶️' ?></span>
          <span class="aula-nome"><?= e($a['titulo']) ?></span>
          <span class="chip chip-xp">+<?= (int) $a['xp_recompensa'] ?> XP</span>
          <span class="estado <?= $est === 'concluida' ? 'estado-verde' : 'estado-azul' ?>"><?= $est === 'concluida' ? 'Concluída' : 'Disponível' ?></span>
        </a>
<?php endif; ?>
      </li>
<?php endforeach; ?>
    </ul>
  </article>
<?php endforeach; ?>
<?php if (!$modulos): ?>
  <div class="card vazio"><span class="vazio-ico">🛠️</span><p class="texto2">Este curso ainda não tem aulas.</p></div>
<?php endif; ?>
</section>
<?php $js = ['dashboard.js']; require __DIR__ . '/includes/footer.php'; ?>
