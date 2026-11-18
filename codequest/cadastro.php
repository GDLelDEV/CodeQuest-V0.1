<?php
declare(strict_types=1);
require_once __DIR__ . '/includes/auth.php';
exigir_visitante();

$erros  = erros_obter();
$antigo = antigo_obter();
$titulo = 'Criar conta';
$css = ['auth.css'];
$body_class = 'pagina-auth';

/** Mensagem de erro logo abaixo do campo. */
function erro_campo(array $erros, string $campo): string
{
    return isset($erros[$campo]) ? '<small class="erro-campo">' . e($erros[$campo]) . '</small>' : '';
}
require __DIR__ . '/includes/head.php';
?>
<main class="auth">
  <aside class="auth-lado">
    <a class="logo" href="<?= e(url('index.php')) ?>"><span class="logo-ico">&lt;/&gt;</span> Code<b>Quest</b></a>
    <h2>Sua jornada <span class="grad">começa aqui</span>.</h2>
    <p>Crie sua conta gratuita e ganhe seus primeiros pontos de experiência.</p>
    <ul class="auth-lista">
      <li>⭐ Ganhe XP a cada aula e desafio</li>
      <li>🏆 Desbloqueie conquistas</li>
      <li>📊 Suba no ranking</li>
    </ul>
  </aside>
  <section class="auth-form">
    <div class="auth-caixa">
      <h1>Criar conta</h1>
      <p class="texto2">Leva menos de um minuto.</p>
      <?php if (isset($erros['geral'])): ?>
        <div class="alerta alerta-erro" role="alert"><span><?= e($erros['geral']) ?></span></div>
      <?php endif; ?>
      <?= flash_html() ?>
      <form method="post" action="<?= e(url('actions/cadastro.php')) ?>" novalidate>
        <?= csrf_campo() ?>
        <div class="campo<?= isset($erros['nome']) ? ' invalido' : '' ?>">
          <label for="nome">Nome completo</label>
          <input type="text" id="nome" name="nome" value="<?= e($antigo['nome'] ?? '') ?>" maxlength="120" autocomplete="name" required>
          <?= erro_campo($erros, 'nome') ?>
        </div>
        <div class="campo<?= isset($erros['username']) ? ' invalido' : '' ?>">
          <label for="username">Nome de usuário</label>
          <input type="text" id="username" name="username" value="<?= e($antigo['username'] ?? '') ?>" maxlength="30" autocomplete="username" required>
          <?= erro_campo($erros, 'username') ?>
        </div>
        <div class="campo<?= isset($erros['email']) ? ' invalido' : '' ?>">
          <label for="email">E-mail</label>
          <input type="email" id="email" name="email" value="<?= e($antigo['email'] ?? '') ?>" maxlength="150" autocomplete="email" required>
          <?= erro_campo($erros, 'email') ?>
        </div>
        <div class="campo<?= isset($erros['senha']) ? ' invalido' : '' ?>">
          <label for="senha">Senha</label>
          <div class="campo-senha">
            <input type="password" id="senha" name="senha" minlength="8" maxlength="72" autocomplete="new-password" required>
            <button type="button" class="ver-senha" data-toggle-senha="senha" aria-label="Mostrar senha">👁</button>
          </div>
          <small class="dica">Mínimo de 8 caracteres.</small>
          <?= erro_campo($erros, 'senha') ?>
        </div>
        <div class="campo<?= isset($erros['confirmar_senha']) ? ' invalido' : '' ?>">
          <label for="confirmar_senha">Confirmar senha</label>
          <input type="password" id="confirmar_senha" name="confirmar_senha" autocomplete="new-password" required>
          <small class="erro-campo" id="avisoSenha" hidden>As senhas não conferem.</small>
          <?= erro_campo($erros, 'confirmar_senha') ?>
        </div>
        <button type="submit" class="btn btn-primario btn-bloco btn-lg">Criar minha conta</button>
      </form>
      <p class="auth-troca">Já tem conta? <a href="<?= e(url('login.php')) ?>">Entrar</a></p>
    </div>
  </section>
</main>
<script src="<?= e(url('assets/js/main.js')) ?>"></script>
</body>
</html>
