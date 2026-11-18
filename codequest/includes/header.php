<?php
/**
 * Layout das páginas privadas (abre sidebar, topo e <main>).
 * Defina antes de incluir: $titulo e $pagina_ativa. Feche com includes/footer.php.
 */
require_once __DIR__ . '/auth.php';
$usuario = $usuario ?? exigir_login();

$css = array_merge(['dashboard.css'], $css ?? []);
$body_class = 'app';
require __DIR__ . '/head.php';
?>
<div class="overlay" id="overlay"></div>
<?php require __DIR__ . '/sidebar.php'; ?>
<div class="conteudo">
  <header class="topo">
    <button type="button" class="menu-btn" id="menuBtn" aria-label="Abrir menu" aria-controls="sidebar" aria-expanded="false">☰</button>
    <h1 class="topo-titulo"><?= e($titulo) ?></h1>
    <div class="topo-info">
      <span class="chip chip-xp" title="XP total">⭐ <?= number_format((int) $usuario['xp_total'], 0, ',', '.') ?> XP</span>
      <span class="chip chip-nivel" title="Nível atual">Nível <?= (int) calcular_nivel((int) $usuario['xp_total']) ?></span>
      <span class="avatar" title="<?= e($usuario['nome']) ?>"><?= e(iniciais($usuario['nome'])) ?></span>
    </div>
  </header>
  <main class="principal">
    <?= flash_html() ?>
