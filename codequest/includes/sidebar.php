<?php
/** Barra lateral. Espera $usuario e $pagina_ativa. */
$itens = [
    // chave, rótulo, ícone, arquivo, página já construída?
    ['dashboard',     'Dashboard',     '🏠', 'dashboard.php', true],
    ['cursos',        'Cursos',        '📚', 'cursos.php',    true],
    ['desafios',      'Desafios',      '🎯', 'desafios.php',  false],
    ['missoes',       'Missões',       '✅', 'missoes.php',   false],
    ['conquistas',    'Conquistas',    '🏆', 'conquistas.php', false],
    ['ranking',       'Ranking',       '📊', 'ranking.php',   false],
    ['perfil',        'Meu perfil',    '👤', 'perfil.php',    false],
    ['configuracoes', 'Configurações', '⚙️', 'configuracoes.php', false],
];
if (($usuario['tipo_usuario'] ?? '') === 'admin') {
    $itens[] = ['admin', 'Administração', '🛠️', 'admin/index.php', false];
}
?>
<aside class="sidebar" id="sidebar" aria-label="Menu principal">
  <a class="logo" href="<?= e(url('dashboard.php')) ?>"><span class="logo-ico">&lt;/&gt;</span> Code<b>Quest</b></a>
  <nav class="menu">
<?php foreach ($itens as [$chave, $rotulo, $icone, $arquivo, $pronto]):
    $href = $pronto ? url($arquivo) : url('em-breve.php?p=' . $chave); ?>
    <a href="<?= e($href) ?>" class="menu-item<?= ($pagina_ativa ?? '') === $chave ? ' ativo' : '' ?>"<?= ($pagina_ativa ?? '') === $chave ? ' aria-current="page"' : '' ?>>
      <span class="menu-ico" aria-hidden="true"><?= $icone ?></span><?= e($rotulo) ?>
    </a>
<?php endforeach; ?>
  </nav>
  <form method="post" action="<?= e(url('logout.php')) ?>" class="sair-form">
    <?= csrf_campo() ?>
    <button type="submit" class="menu-item sair"><span class="menu-ico" aria-hidden="true">🚪</span>Sair</button>
  </form>
</aside>
