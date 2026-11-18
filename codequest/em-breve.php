<?php
declare(strict_types=1);
// Página provisória das áreas que serão construídas nas próximas etapas.
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/functions.php';
$usuario = exigir_login();

$paginas = [
    'desafios'      => ['Desafios', 'ETAPA 5'],
    'missoes'       => ['Missões', 'ETAPA 6'],
    'conquistas'    => ['Conquistas', 'ETAPA 6'],
    'ranking'       => ['Ranking', 'ETAPA 6'],
    'perfil'        => ['Meu perfil', 'uma das próximas etapas'],
    'configuracoes' => ['Configurações', 'uma das próximas etapas'],
    'admin'         => ['Administração', 'ETAPA 7'],
];
$chave = (string) ($_GET['p'] ?? '');
if (!isset($paginas[$chave])) {
    redirecionar(url('dashboard.php'));
}
[$titulo, $etapa] = $paginas[$chave];
$pagina_ativa = $chave;

require __DIR__ . '/includes/header.php';
?>
    <section class="card vazio">
      <div class="vazio-ico">🚧</div>
      <h2><?= e($titulo) ?> em construção</h2>
      <p class="texto2">Esta página será entregue na <?= e($etapa) ?> do projeto.</p>
      <a class="btn btn-primario" href="<?= e(url('dashboard.php')) ?>">Voltar ao dashboard</a>
    </section>
<?php require __DIR__ . '/includes/footer.php'; ?>
