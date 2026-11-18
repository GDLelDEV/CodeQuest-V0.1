<?php
declare(strict_types=1);
/**
 * Inclua no topo de TODA página/ação do painel administrativo (ETAPA 7).
 * Barra usuários sem login (redireciona) e usuários comuns (403).
 */
require_once __DIR__ . '/auth.php';
$usuario = exigir_admin();
