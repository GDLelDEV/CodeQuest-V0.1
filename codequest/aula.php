<?php
declare(strict_types=1);
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/progresso.php';

$usuario = exigir_login();
$pdo = conectar();
$aulaId = (int) ($_GET['id'] ?? 0);

$st = $pdo->prepare(
    'SELECT a.id, a.titulo, a.conteudo, a.codigo_exemplo, a.explicacao, a.xp_recompensa,
            m.titulo AS modulo_titulo, m.curso_id, c.titulo AS curso_titulo
       FROM aulas a
       JOIN modulos m ON m.id = a.modulo_id
       JOIN cursos c ON c.id = m.curso_id
      WHERE a.id = :id AND c.ativo = 1'
);
$st->execute([':id' => $aulaId]);
$aula = $st->fetch();
if (!$aula) {
    flash('erro', 'Aula não encontrada.');
    redirecionar(url('cursos.php'));
}

$lista = aulas_do_curso($pdo, (int) $aula['curso_id'], (int) $usuario['id']);
$pos = null;
foreach ($lista as $i => $item) {
    if ((int) $item['id'] === $aulaId) { $pos = $i; break; }
}
// Desbloqueio progressivo verificado NO SERVIDOR: aula bloqueada não abre.
if ($pos === null || !$lista[$pos]['liberada']) {
    flash('erro', 'Esta aula está bloqueada. Conclua a aula anterior primeiro.');
    redirecionar(url('curso.php?id=' . (int) $aula['curso_id']));
}
$concluida = $lista[$pos]['concluida'];
$anterior = $lista[$pos - 1] ?? null;
$proxima  = $lista[$pos + 1] ?? null;

$titulo = $aula['curso_titulo'];
$pagina_ativa = 'cursos';
$css = ['courses.css'];
$js = ['aula.js'];
require __DIR__ . '/includes/header.php';
?>
<nav class="trilha" aria-label="Você está em">
  <a href="<?= e(url('cursos.php')) ?>">Cursos</a> › <a href="<?= e(url('curso.php?id=' . (int) $aula['curso_id'])) ?>"><?= e($aula['curso_titulo']) ?></a> › <span><?= e($aula['modulo_titulo']) ?></span>
</nav>

<article class="aula">
  <header class="aula-cab">
    <span class="chip">Aula <?= $pos + 1 ?> de <?= count($lista) ?></span>
    <span class="chip chip-xp">+<?= (int) $aula['xp_recompensa'] ?> XP</span>
    <?php if ($concluida): ?><span class="estado estado-verde">Concluída ✔</span><?php endif; ?>
    <h2><?= e($aula['titulo']) ?></h2>
  </header>

  <section class="card aula-bloco">
    <h3>📖 Conteúdo</h3>
    <div class="texto-aula"><?= texto_para_html($aula['conteudo']) ?></div>
  </section>

  <?php if (trim((string) $aula['codigo_exemplo']) !== ''): ?>
  <section class="aula-bloco">
    <h3>💻 Exemplo de código</h3>
    <div class="codigo">
      <div class="codigo-topo"><span>Exemplo</span><button type="button" class="codigo-copiar" data-copiar="codigo">Copiar</button></div>
      <pre><code id="codigo"><?= e($aula['codigo_exemplo']) ?></code></pre>
    </div>
  </section>
  <?php endif; ?>

  <?php if (trim((string) $aula['explicacao']) !== ''): ?>
  <section class="card aula-resumo">
    <h3>💡 Resumo</h3>
    <div class="texto-aula"><?= texto_para_html($aula['explicacao']) ?></div>
  </section>
  <?php endif; ?>

  <footer class="aula-nav">
    <?php if ($anterior): ?>
      <a class="btn btn-sec" href="<?= e(url('aula.php?id=' . (int) $anterior['id'])) ?>">← Aula anterior</a>
    <?php else: ?>
      <a class="btn btn-sec" href="<?= e(url('curso.php?id=' . (int) $aula['curso_id'])) ?>">← Voltar ao curso</a>
    <?php endif; ?>

    <?php if ($concluida): ?>
      <span class="concluida-selo">✅ Aula concluída</span>
    <?php else: ?>
      <form method="post" action="<?= e(url('actions/concluir-aula.php')) ?>" class="form-concluir">
        <?= csrf_campo() ?>
        <input type="hidden" name="aula_id" value="<?= (int) $aula['id'] ?>">
        <button type="submit" class="btn btn-primario btn-lg">Marcar como concluída (+<?= (int) $aula['xp_recompensa'] ?> XP)</button>
      </form>
    <?php endif; ?>

    <?php if ($proxima && $concluida): ?>
      <a class="btn btn-primario" href="<?= e(url('aula.php?id=' . (int) $proxima['id'])) ?>">Próxima aula →</a>
    <?php elseif ($proxima): ?>
      <button type="button" class="btn btn-sec" disabled title="Conclua esta aula para liberar a próxima">Próxima aula 🔒</button>
    <?php else: ?>
      <a class="btn btn-sec" href="<?= e(url('curso.php?id=' . (int) $aula['curso_id'])) ?>">Ver o curso</a>
    <?php endif; ?>
  </footer>
</article>
<?php require __DIR__ . '/includes/footer.php'; ?>
