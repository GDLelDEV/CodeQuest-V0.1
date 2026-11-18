<?php
declare(strict_types=1);

/**
 * Funções utilitárias usadas em todo o projeto.
 */

/** Escapa texto para exibir com segurança em HTML (proteção contra XSS). */
function e(?string $texto): string
{
    return htmlspecialchars((string) $texto, ENT_QUOTES, 'UTF-8');
}

/**
 * Monta uma URL a partir da raiz do projeto, funcionando em qualquer pasta
 * (ex.: /codequest/ no XAMPP ou a raiz da hospedagem). Use sempre url('pagina.php').
 */
function url(string $caminho = ''): string
{
    static $base = null;

    if ($base === null) {
        $raiz = str_replace('\\', '/', (string) realpath($_SERVER['DOCUMENT_ROOT'] ?? ''));
        $proj = str_replace('\\', '/', (string) realpath(__DIR__ . '/..'));
        $base = ($raiz !== '' && strncasecmp($proj, $raiz, strlen($raiz)) === 0)
            ? rtrim(substr($proj, strlen($raiz)), '/')
            : '';
    }

    return $base . '/' . ltrim($caminho, '/');
}

/** Redireciona para outra página e encerra o script. */
function redirecionar(string $destino): never
{
    header('Location: ' . $destino);
    exit;
}

// ---------------------------------------------------------------------
// Níveis (a progressão continua automaticamente depois do nível 6)
// XP acumulado para atingir o nível n: 25 * (n-1) * (n+2)
// => 100, 250, 450, 700, 1000, 1350, 1750...
// ---------------------------------------------------------------------
function xp_para_nivel(int $nivel): int
{
    return $nivel <= 1 ? 0 : 25 * ($nivel - 1) * ($nivel + 2);
}

function calcular_nivel(int $xp): int
{
    $nivel = 1;
    while (xp_para_nivel($nivel + 1) <= $xp) {
        $nivel++;
    }
    return $nivel;
}

/** Dados da barra de evolução: nível, XP no nível atual, XP necessário e %. */
function progresso_nivel(int $xp): array
{
    $nivel  = calcular_nivel($xp);
    $inicio = xp_para_nivel($nivel);
    $fim    = xp_para_nivel($nivel + 1);
    $no_nivel = $xp - $inicio;
    $precisa  = $fim - $inicio;

    return [
        'nivel'        => $nivel,
        'xp_no_nivel'  => $no_nivel,
        'xp_necessario' => $precisa,
        'xp_proximo'   => $fim,
        'percentual'   => (int) floor($no_nivel / $precisa * 100),
    ];
}

// ---------------------------------------------------------------------
// Textos de apoio
// ---------------------------------------------------------------------
function iniciais(string $nome): string
{
    $partes = preg_split('/\s+/', trim($nome)) ?: [];
    $letras = mb_substr($partes[0] ?? '?', 0, 1);
    if (count($partes) > 1) {
        $letras .= mb_substr(end($partes), 0, 1);
    }
    return mb_strtoupper($letras);
}

function primeiro_nome(string $nome): string
{
    $partes = preg_split('/\s+/', trim($nome)) ?: [];
    return $partes[0] ?? $nome;
}

// ---------------------------------------------------------------------
// Mensagens entre páginas (flash) e formulários
// ---------------------------------------------------------------------
function flash(string $tipo, string $mensagem): void
{
    $_SESSION['flash'] = ['tipo' => $tipo, 'msg' => $mensagem];
}

/** HTML da mensagem flash (exibida uma única vez). */
function flash_html(): string
{
    $f = $_SESSION['flash'] ?? null;
    unset($_SESSION['flash']);
    if (!$f) {
        return '';
    }
    $classe = $f['tipo'] === 'sucesso' ? 'sucesso' : 'erro';
    return '<div class="alerta alerta-' . $classe . '" role="alert">'
        . '<span>' . e($f['msg']) . '</span>'
        . '<button type="button" class="alerta-fechar" aria-label="Fechar">×</button></div>';
}

/** Volta para um formulário guardando erros por campo e os valores digitados. */
function voltar_com_erros(string $destino, array $erros, array $antigo = []): never
{
    $_SESSION['erros']  = $erros;
    $_SESSION['antigo'] = $antigo;
    redirecionar(url($destino));
}

function erros_obter(): array
{
    $e = $_SESSION['erros'] ?? [];
    unset($_SESSION['erros']);
    return $e;
}

function antigo_obter(): array
{
    $a = $_SESSION['antigo'] ?? [];
    unset($_SESSION['antigo']);
    return $a;
}
