<?php
declare(strict_types=1);
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/progresso.php';

$usuario = exigir_login();
$cursos = cursos_lista(conectar(), (int) $usuario['id']);

$titulo = 'Cursos';
$pagina_ativa = 'cursos';
$css = ['courses.css'];
require __DIR__ . '/includes/header.php';
?>
<section class="cursos-grid">
<?php foreach ($cursos as $c):
    $total = (int) $c['total_aulas'];
    $feitas = (int) $c['concluidas'];
    $pct = $total > 0 ? (int) floor($feitas / $total * 100) : 0;
    $rotulo = $pct === 100 ? 'Revisar' : ($feitas > 0 ? 'Continuar' : 'Começar'); ?>
  <article class="card card-hover curso-box">
    <div class="curso-box-topo">
      <span class="curso-box-ico"><?= e($c['icone'] ?? '📘') ?></span>
      <span class="chip"><?= e($c['dificuldade'] ?? '') ?></span>
    </div>
    <h2><?= e($c['titulo']) ?></h2>
    <p class="texto2"><?= e($c['descricao'] ?? '') ?></p>
    <div class="curso-box-info texto2"><span><?= (int) $c['qtd_modulos'] ?> módulos</span><span><?= $total ?> aulas</span></div>
    <div class="barra barra-fina"><div class="barra-fill verde" style="width:<?= $pct ?>%" data-valor="<?= $pct ?>"></div></div>
    <small class="texto2"><?= $pct ?>% concluído<?= $pct === 100 ? ' ✔' : '' ?></small>
    <a class="btn <?= $pct === 100 ? 'btn-sec' : 'btn-primario' ?> btn-bloco" href="<?= e(url('curso.php?id=' . (int) $c['id'])) ?>"><?= $rotulo ?></a>
  </article>
<?php endforeach; ?>
<?php if (!$cursos): ?>
  <div class="card vazio col-vazio"><span class="vazio-ico">📚</span><p class="texto2">Nenhum curso disponível no momento.</p></div>
<?php endif; ?>
</section>
<?php $js = ['dashboard.js']; require __DIR__ . '/includes/footer.php'; ?>
