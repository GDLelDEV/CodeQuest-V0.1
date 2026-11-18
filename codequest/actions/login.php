<?php
declare(strict_types=1);
require_once __DIR__ . '/../includes/auth.php';

exigir_post_csrf('login.php');

$login = trim((string) ($_POST['login'] ?? ''));
$senha = (string) ($_POST['senha'] ?? '');

if ($login === '' || $senha === '') {
    voltar_com_erros('login.php', ['geral' => 'Preencha e-mail/usuário e senha.'], ['login' => $login]);
}

// Dois parâmetros distintos: o PDO sem emulação não aceita o mesmo nome repetido.
$st = conectar()->prepare('SELECT id, senha FROM usuarios WHERE email = :a OR username = :b LIMIT 1');
$st->execute([':a' => mb_strtolower($login), ':b' => $login]);
$u = $st->fetch();

if ($u) {
    $ok = password_verify($senha, $u['senha']);
} else {
    password_hash($senha, PASSWORD_DEFAULT);   // gasta o mesmo tempo: não revela se o usuário existe
    $ok = false;
}

if (!$ok) {
    // Mensagem única para os dois casos (usuário inexistente ou senha errada).
    voltar_com_erros('login.php', ['geral' => 'Usuário ou senha incorretos.'], ['login' => $login]);
}

// Atualiza o hash se o algoritmo padrão do PHP evoluiu.
if (password_needs_rehash($u['senha'], PASSWORD_DEFAULT)) {
    conectar()->prepare('UPDATE usuarios SET senha = :s WHERE id = :id')
        ->execute([':s' => password_hash($senha, PASSWORD_DEFAULT), ':id' => $u['id']]);
}

efetuar_login((int) $u['id']);
redirecionar(url('dashboard.php'));
