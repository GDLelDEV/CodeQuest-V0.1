<?php
declare(strict_types=1);

/**
 * Conexão central com o MySQL via PDO.
 * Use em qualquer arquivo:
 *
 *   require_once __DIR__ . '/config/database.php';
 *   $pdo = conectar();
 *
 * A mesma conexão é reaproveitada durante toda a requisição.
 */

/** Lê uma configuração de config/env.php. */
function config(string $chave, mixed $padrao = null): mixed
{
    static $env = null;

    if ($env === null) {
        $arquivo = __DIR__ . '/env.php';
        if (!is_file($arquivo)) {
            error_log('[CodeQuest] config/env.php não encontrado. Copie config/env.example.php para config/env.php.');
            http_response_code(500);
            exit('Configuração do sistema ausente. Consulte o README.');
        }
        $env = require $arquivo;
    }

    return $env[$chave] ?? $padrao;
}

/** Retorna a conexão PDO (cria na primeira chamada). */
function conectar(): PDO
{
    static $pdo = null;

    if ($pdo instanceof PDO) {
        return $pdo;
    }

    $dsn = sprintf(
        'mysql:host=%s;port=%s;dbname=%s;charset=%s',
        config('DB_HOST', '127.0.0.1'),
        config('DB_PORT', '3306'),
        config('DB_NAME', 'codequest'),
        config('DB_CHARSET', 'utf8mb4')
    );

    try {
        $pdo = new PDO($dsn, (string) config('DB_USER', 'root'), (string) config('DB_PASS', ''), [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,   // erros viram exceções
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,         // resultados como array associativo
            PDO::ATTR_EMULATE_PREPARES   => false,                    // prepared statements reais
        ]);
    } catch (PDOException $e) {
        // Detalhes técnicos só no log; ao usuário, apenas mensagem genérica.
        error_log('[CodeQuest] Falha ao conectar no MySQL: ' . $e->getMessage());
        http_response_code(500);
        if (config('APP_DEBUG', false)) {
            exit('Erro ao conectar ao banco: ' . htmlspecialchars($e->getMessage(), ENT_QUOTES, 'UTF-8'));
        }
        exit('Erro ao conectar ao banco de dados. Tente novamente mais tarde.');
    }

    return $pdo;
}
