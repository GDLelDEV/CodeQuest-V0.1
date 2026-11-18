<?php
declare(strict_types=1);

/**
 * Autenticação, sessão, permissões e proteção CSRF.
 * Inclua este arquivo em toda página que precise de sessão.
 *
 * Regra de ouro: o navegador guarda apenas o ID do usuário na sessão.
 * Perfil e permissões são SEMPRE relidos do banco a cada requisição.
 */

require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/functions.php';

date_default_timezone_set('America/Sao_Paulo');

function iniciar_sessao(): void
{
    if (session_status() === PHP_SESSION_ACTIVE) {
        return;
    }

    $https = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off')
        || (($_SERVER['HTTP_X_FORWARDED_PROTO'] ?? '') === 'https');

    ini_set('session.use_strict_mode', '1');   // recusa IDs de sessão desconhecidos
    ini_set('session.use_only_cookies', '1');  // nunca aceita ID na URL
    session_name('codequest_sid');
    session_set_cookie_params([
        'lifetime' => 0,
        'path'     => '/',
        'secure'   => $https,   // true automaticamente em HTTPS
        'httponly' => true,     // JavaScript não lê o cookie
        'samesite' => 'Lax',
    ]);
    session_start();
}

iniciar_sessao();

// ---------------------------------------------------------------------
// Usuário logado
// ---------------------------------------------------------------------

/** Retorna os dados do usuário logado (do banco) ou null. */
function usuario_atual(): ?array
{
    static $cache = false;
    if ($cache !== false) {
        return $cache;
    }

    $id = $_SESSION['usuario_id'] ?? null;
    if (!$id) {
        return $cache = null;
    }

    $st = conectar()->prepare(
        'SELECT id, nome, username, email, avatar, xp_total, nivel, tipo_usuario,
                sequencia_dias, data_cadastro
           FROM usuarios WHERE id = :id'
    );
    $st->execute([':id' => (int) $id]);
    $usuario = $st->fetch();

    if (!$usuario) {            // usuário apagado: derruba a sessão
        encerrar_sessao();
        return $cache = null;
    }
    return $cache = $usuario;
}

/** Página privada: sem login, volta para o login. */
function exigir_login(): array
{
    $u = usuario_atual();
    if ($u === null) {
        iniciar_sessao();
        flash('erro', 'Faça login para acessar esta página.');
        redirecionar(url('login.php'));
    }
    return $u;
}

/** Páginas de login/cadastro: quem já está logado vai direto ao dashboard. */
function exigir_visitante(): void
{
    if (usuario_atual() !== null) {
        redirecionar(url('dashboard.php'));
    }
}

/** Área administrativa: verifica a permissão no BANCO (não confia no navegador). */
function exigir_admin(): array
{
    $u = exigir_login();
    if ($u['tipo_usuario'] !== 'admin') {
        http_response_code(403);
        exit('Acesso negado. Esta área é exclusiva para administradores.');
    }
    return $u;
}

/** Cria a sessão do usuário (chamar somente após validar credenciais). */
function efetuar_login(int $usuario_id): void
{
    session_regenerate_id(true);          // evita fixação de sessão
    $_SESSION['usuario_id'] = $usuario_id;
    unset($_SESSION['csrf']);             // novo token para a nova sessão
}

function encerrar_sessao(): void
{
    $_SESSION = [];
    if (ini_get('session.use_cookies')) {
        $p = session_get_cookie_params();
        setcookie(session_name(), '', [
            'expires'  => time() - 42000,
            'path'     => $p['path'],
            'secure'   => $p['secure'],
            'httponly' => $p['httponly'],
            'samesite' => 'Lax',
        ]);
    }
    if (session_status() === PHP_SESSION_ACTIVE) {
        session_destroy();
    }
}

// ---------------------------------------------------------------------
// CSRF
// ---------------------------------------------------------------------
function csrf_token(): string
{
    if (empty($_SESSION['csrf'])) {
        $_SESSION['csrf'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf'];
}

/** Campo hidden para colocar dentro de todo <form method="post">. */
function csrf_campo(): string
{
    return '<input type="hidden" name="csrf_token" value="' . e(csrf_token()) . '">';
}

function csrf_validar(): bool
{
    $enviado = (string) ($_POST['csrf_token'] ?? '');
    $sessao  = (string) ($_SESSION['csrf'] ?? '');
    return $sessao !== '' && hash_equals($sessao, $enviado);
}

/** Início padrão das actions: só aceita POST com token CSRF válido. */
function exigir_post_csrf(string $voltar): void
{
    if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {
        redirecionar(url($voltar));
    }
    if (!csrf_validar()) {
        flash('erro', 'Sua sessão expirou. Tente novamente.');
        redirecionar(url($voltar));
    }
}
