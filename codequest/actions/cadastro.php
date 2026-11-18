<?php
declare(strict_types=1);
require_once __DIR__ . '/../includes/auth.php';

exigir_post_csrf('cadastro.php');

$nome      = trim((string) ($_POST['nome'] ?? ''));
$username  = trim((string) ($_POST['username'] ?? ''));
$email     = mb_strtolower(trim((string) ($_POST['email'] ?? '')));
$senha     = (string) ($_POST['senha'] ?? '');
$confirmar = (string) ($_POST['confirmar_senha'] ?? '');
$antigo    = compact('nome', 'username', 'email');   // a senha NUNCA volta ao formulário

$erros = [];

$tam = mb_strlen($nome);
if ($tam < 3 || $tam > 120) {
    $erros['nome'] = 'Informe seu nome completo (3 a 120 caracteres).';
}
if (!preg_match('/^[A-Za-z0-9_]{3,30}$/', $username)) {
    $erros['username'] = 'Use de 3 a 30 caracteres: letras, números e _ (sem espaços).';
}
if (!filter_var($email, FILTER_VALIDATE_EMAIL) || mb_strlen($email) > 150) {
    $erros['email'] = 'Informe um e-mail válido.';
}
if (strlen($senha) < 8) {
    $erros['senha'] = 'A senha precisa ter pelo menos 8 caracteres.';
} elseif (strlen($senha) > 72) {
    $erros['senha'] = 'A senha pode ter no máximo 72 caracteres.';
}
if ($senha !== $confirmar) {
    $erros['confirmar_senha'] = 'As senhas não conferem.';
}

$pdo = conectar();

if (!isset($erros['username'])) {
    $st = $pdo->prepare('SELECT 1 FROM usuarios WHERE username = :u');
    $st->execute([':u' => $username]);
    if ($st->fetchColumn()) {
        $erros['username'] = 'Este nome de usuário já está em uso.';
    }
}
if (!isset($erros['email'])) {
    $st = $pdo->prepare('SELECT 1 FROM usuarios WHERE email = :e');
    $st->execute([':e' => $email]);
    if ($st->fetchColumn()) {
        $erros['email'] = 'Este e-mail já está cadastrado.';
    }
}

if ($erros) {
    voltar_com_erros('cadastro.php', $erros, $antigo);
}

try {
    // O tipo é SEMPRE 'student': nunca vem do formulário.
    $st = $pdo->prepare(
        "INSERT INTO usuarios (nome, username, email, senha, tipo_usuario)
         VALUES (:n, :u, :e, :s, 'student')"
    );
    $st->execute([
        ':n' => $nome,
        ':u' => $username,
        ':e' => $email,
        ':s' => password_hash($senha, PASSWORD_DEFAULT),
    ]);
    $id = (int) $pdo->lastInsertId();
} catch (PDOException $ex) {
    // 1062 = chave duplicada (duas pessoas cadastrando o mesmo dado ao mesmo tempo)
    if ((int) ($ex->errorInfo[1] ?? 0) === 1062) {
        voltar_com_erros('cadastro.php', ['geral' => 'Usuário ou e-mail já cadastrado.'], $antigo);
    }
    error_log('[CodeQuest] Erro no cadastro: ' . $ex->getMessage());
    voltar_com_erros('cadastro.php', ['geral' => 'Não foi possível criar a conta agora. Tente novamente.'], $antigo);
}

efetuar_login($id);
flash('sucesso', 'Conta criada com sucesso! Bem-vindo(a) ao CodeQuest.');
redirecionar(url('dashboard.php'));
