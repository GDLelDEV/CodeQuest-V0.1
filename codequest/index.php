<?php
declare(strict_types=1);
require_once __DIR__ . '/includes/auth.php';

$logado = usuario_atual() !== null;

// Cursos reais do banco (se o banco estiver indisponível, a seção simplesmente some).
$cursos = [];
$num = ['cursos' => 0, 'aulas' => 0, 'desafios' => 0];
try {
    $num = conectar()->query(
        'SELECT (SELECT COUNT(*) FROM cursos WHERE ativo = 1) AS cursos,
                (SELECT COUNT(*) FROM aulas) AS aulas,
                (SELECT COUNT(*) FROM desafios WHERE ativo = 1) AS desafios'
    )->fetch() ?: $num;
    $cursos = conectar()->query(
        'SELECT c.titulo, c.descricao, c.icone, c.dificuldade,
                (SELECT COUNT(*) FROM modulos m WHERE m.curso_id = c.id) AS qtd_modulos
           FROM cursos c WHERE c.ativo = 1 ORDER BY c.id'
    )->fetchAll();
} catch (Throwable $ex) {
    error_log('[CodeQuest] Landing: ' . $ex->getMessage());
}

$titulo = 'Aprenda programação jogando';
$body_class = 'landing';
require __DIR__ . '/includes/head.php';
?>
<header class="nav">
  <div class="container nav-in">
    <a class="logo" href="#topo"><span class="logo-ico">&lt;/&gt;</span> Code<b>Quest</b></a>
    <nav class="nav-links" aria-label="Seções">
      <a href="#como-funciona">Como funciona</a>
      <a href="#cursos">Cursos</a>
      <a href="#gamificacao">Gamificação</a>
      <a href="#beneficios">Benefícios</a>
    </nav>
    <div class="nav-acoes">
<?php if ($logado): ?>
      <a class="btn btn-primario" href="<?= e(url('dashboard.php')) ?>">Ir para o dashboard</a>
<?php else: ?>
      <a class="btn btn-sec" href="<?= e(url('login.php')) ?>">Entrar</a>
      <a class="btn btn-primario nav-cta" href="<?= e(url('cadastro.php')) ?>">Começar agora</a>
<?php endif; ?>
    </div>
  </div>
</header>

<main id="topo">
  <section class="hero container">
    <div class="hero-texto">
      <span class="selo">🎮 Programação em forma de jogo</span>
      <h1>Transforme seu aprendizado em uma <span class="grad">aventura</span>.</h1>
      <p class="hero-sub">Aprenda programação, complete desafios, conquiste XP e evolua até se tornar um verdadeiro desenvolvedor.</p>
      <div class="hero-botoes">
        <a class="btn btn-primario btn-lg" href="<?= e(url($logado ? 'dashboard.php' : 'cadastro.php')) ?>">Começar minha jornada</a>
        <a class="btn btn-sec btn-lg" href="#como-funciona">Ver como funciona</a>
      </div>
      <ul class="hero-numeros">
        <li><strong><?= (int) $num['cursos'] ?></strong> trilhas</li>
        <li><strong><?= (int) $num['aulas'] ?></strong> aulas</li>
        <li><strong><?= (int) $num['desafios'] ?></strong> desafios</li>
      </ul>
    </div>

    <!-- Ilustração do dashboard (exemplo visual, não são dados reais) -->
    <div class="mock" aria-hidden="true">
      <div class="mock-topo"><span></span><span></span><span></span><em>exemplo</em></div>
      <div class="mock-corpo">
        <div class="mock-user"><span class="avatar">AL</span><div><strong>Ana Lima</strong><small class="texto2">Nível 3</small></div><span class="chip chip-xp">⭐ 320 XP</span></div>
        <div class="barra"><div class="barra-fill" style="width:62%"></div></div>
        <div class="mock-grid">
          <div class="mock-card"><b>12</b><small>aulas</small></div>
          <div class="mock-card"><b>27</b><small>desafios</small></div>
          <div class="mock-card"><b>4</b><small>conquistas</small></div>
        </div>
        <div class="mock-miss"><span>✅ Concluir uma aula</span><span class="amarelo-txt">+15 XP</span></div>
        <div class="mock-miss"><span>🎯 Resolver dois desafios</span><span class="amarelo-txt">+20 XP</span></div>
      </div>
    </div>
  </section>

  <section class="secao container" id="como-funciona">
    <h2 class="secao-titulo revelar">Como funciona</h2>
    <p class="secao-sub texto2 revelar">Três passos para começar a evoluir.</p>
    <div class="grid-3">
      <article class="card card-hover revelar"><span class="passo-num">1</span><h3>Crie sua conta</h3><p class="texto2">Cadastro gratuito, rápido e seguro. Sem cartão, sem complicação.</p></article>
      <article class="card card-hover revelar"><span class="passo-num">2</span><h3>Estude e pratique</h3><p class="texto2">Aulas curtas com exemplos de código e desafios que corrigem sua resposta na hora.</p></article>
      <article class="card card-hover revelar"><span class="passo-num">3</span><h3>Evolua e conquiste</h3><p class="texto2">Ganhe XP, suba de nível, desbloqueie medalhas e dispute o ranking.</p></article>
    </div>
  </section>

<?php if ($cursos): ?>
  <section class="secao container" id="cursos">
    <h2 class="secao-titulo revelar">Trilhas de aprendizagem</h2>
    <p class="secao-sub texto2 revelar">Do HTML ao banco de dados, em ordem de dificuldade.</p>
    <div class="grid-cursos">
<?php foreach ($cursos as $c): ?>
      <article class="card card-hover curso-card revelar">
        <span class="curso-emoji"><?= e($c['icone'] ?? '📘') ?></span>
        <h3><?= e($c['titulo']) ?></h3>
        <p class="texto2"><?= e($c['descricao'] ?? '') ?></p>
        <div class="curso-meta"><span class="chip"><?= e($c['dificuldade'] ?? '') ?></span><span class="texto2"><?= (int) $c['qtd_modulos'] ?> módulos</span></div>
      </article>
<?php endforeach; ?>
    </div>
  </section>
<?php endif; ?>

  <section class="secao container" id="gamificacao">
    <h2 class="secao-titulo revelar">Aprender virou um jogo</h2>
    <p class="secao-sub texto2 revelar">Cada passo conta. Cada acerto vale pontos.</p>
    <div class="grid-4">
      <article class="card card-hover revelar"><span class="feat-ico amarelo">⭐</span><h3>XP e níveis</h3><p class="texto2">Aulas e desafios rendem XP. Acumule pontos e suba de nível automaticamente.</p></article>
      <article class="card card-hover revelar"><span class="feat-ico roxo">🏆</span><h3>Conquistas</h3><p class="texto2">Medalhas desbloqueadas conforme você progride nas trilhas.</p></article>
      <article class="card card-hover revelar"><span class="feat-ico verde">✅</span><h3>Missões diárias</h3><p class="texto2">Metas curtas todos os dias para criar o hábito de estudar.</p></article>
      <article class="card card-hover revelar"><span class="feat-ico azul">📊</span><h3>Ranking</h3><p class="texto2">Compare seu XP com os outros estudantes de forma saudável.</p></article>
    </div>
  </section>

  <section class="secao container" id="beneficios">
    <h2 class="secao-titulo revelar">Por que o CodeQuest?</h2>
    <div class="grid-3">
      <article class="card revelar"><h3>🎯 Correção automática</h3><p class="texto2">Responda e veja na hora se acertou, com explicação de cada resposta.</p></article>
      <article class="card revelar"><h3>📱 Em qualquer tela</h3><p class="texto2">Estude no computador, no tablet ou no celular.</p></article>
      <article class="card revelar"><h3>💾 Progresso salvo</h3><p class="texto2">Seu avanço fica guardado na sua conta, onde quer que você entre.</p></article>
    </div>
  </section>

  <section class="cta container revelar">
    <h2>Pronto para começar sua jornada?</h2>
    <p>Crie sua conta e complete sua primeira missão hoje.</p>
    <a class="btn btn-primario btn-lg" href="<?= e(url($logado ? 'dashboard.php' : 'cadastro.php')) ?>"><?= $logado ? 'Ir para o dashboard' : 'Criar conta grátis' ?></a>
  </section>
</main>

<footer class="rodape">
  <div class="container rodape-in">
    <a class="logo" href="#topo"><span class="logo-ico">&lt;/&gt;</span> Code<b>Quest</b></a>
    <small class="texto2">© <?= date('Y') ?> CodeQuest — projeto escolar de hackathon.</small>
  </div>
</footer>
<script src="<?= e(url('assets/js/main.js')) ?>"></script>
</body>
</html>
