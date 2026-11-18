<?php
declare(strict_types=1);
require_once __DIR__ . '/includes/auth.php';
exigir_visitante();

$erros  = erros_obter();
$antigo = antigo_obter();
$titulo = 'Entrar';
$css = ['auth.css'];
$body_class = 'pagina-auth';
require __DIR__ . '/includes/head.php';
?>
<main class="auth">
  <aside class="auth-lado">
    <a class="logo" href="<?= e(url('index.php')) ?>"><span class="logo-ico">&lt;/&gt;</span> Code<b>Quest</b></a>
    <h2>Continue de onde <span class="grad">parou</span>.</h2>
    <p>Seu XP, seu nível e suas conquistas estão te esperando.</p>
  </aside>
  <section class="auth-form">
    <div class="auth-caixa">
      <h1>Entrar</h1>
      <p class="texto2">Acesse com seu e-mail ou nome de usuário.</p>
      <?= flash_html() ?>
      <?php if (isset($erros['geral'])): ?>
        <div class="alerta alerta-erro" role="alert"><span><?= e($erros['geral']) ?></span></div>
      <?php endif; ?>
      <form method="post" action="<?= e(url('actions/login.php')) ?>" novalidate>
        <?= csrf_campo() ?>
        <div class="campo">
          <label for="login">E-mail ou usuário</label>
          <input type="text" id="login" name="login" value="<?= e($antigo['login'] ?? '') ?>" autocomplete="username" required autofocus>
        </div>
        <div class="campo">
          <label for="senha">Senha</label>
          <div class="campo-senha">
            <input type="password" id="senha" name="senha" autocomplete="current-password" required>
            <button type="button" class="ver-senha" data-toggle-senha="senha" aria-label="Mostrar senha">👁</button>
          </div>
        </div>
        <button type="submit" class="btn btn-primario btn-bloco btn-lg">Entrar</button>
      </form>
      <p class="auth-troca">Ainda não tem conta? <a href="<?= e(url('cadastro.php')) ?>">Cadastre-se</a></p>
    </div>
  </section>
</main>
<script src="<?= e(url('assets/js/main.js')) ?>"></script>
</body>
</html>
