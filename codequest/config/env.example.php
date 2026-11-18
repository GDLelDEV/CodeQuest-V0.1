<?php
/**
 * MODELO de configuração do ambiente.
 *
 * Como usar:
 *   1) Copie este arquivo para  config/env.php
 *   2) Ajuste os valores abaixo.
 *
 * O arquivo config/env.php está no .gitignore: ele NÃO vai para o GitHub.
 * Os valores abaixo já funcionam no XAMPP padrão.
 */
return [
    'DB_HOST'    => '127.0.0.1',   // na hospedagem, use o host informado pelo painel
    'DB_PORT'    => '3306',
    'DB_NAME'    => 'codequest',
    'DB_USER'    => 'root',        // XAMPP: root  | hospedagem: usuário criado no painel
    'DB_PASS'    => '',            // XAMPP: vazio | hospedagem: senha criada no painel
    'DB_CHARSET' => 'utf8mb4',

    // true = mostra mensagens técnicas (SOMENTE no seu computador)
    // false = mostra apenas mensagens genéricas (use na hospedagem)
    'APP_DEBUG'  => true,
];
