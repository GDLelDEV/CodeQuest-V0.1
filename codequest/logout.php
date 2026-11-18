<?php
declare(strict_types=1);
require_once __DIR__ . '/includes/auth.php';

// Logout só por POST com token CSRF: um link externo não consegue deslogar o usuário.
if (($_SERVER['REQUEST_METHOD'] ?? '') === 'POST' && csrf_validar()) {
    encerrar_sessao();
    iniciar_sessao();                       // sessão nova e limpa para a mensagem
    flash('sucesso', 'Você saiu da sua conta.');
    redirecionar(url('login.php'));
}
redirecionar(url('index.php'));
