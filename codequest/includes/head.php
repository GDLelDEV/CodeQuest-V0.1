<?php
/**
 * Início do HTML (<head>) compartilhado.
 * Variáveis esperadas: $titulo (string), $css (array opcional), $body_class (string opcional).
 */
$arquivos_css = array_merge(['style.css'], $css ?? [], ['responsive.css']); // responsive sempre por último
?><!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="theme-color" content="#0B1020">
  <title><?= e($titulo ?? 'CodeQuest') ?> — CodeQuest</title>
  <link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'%3E%3Ctext y='.9em' font-size='90'%3E%E2%9A%94%EF%B8%8F%3C/text%3E%3C/svg%3E">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap">
<?php foreach ($arquivos_css as $arquivo): ?>
  <link rel="stylesheet" href="<?= e(url('assets/css/' . $arquivo)) ?>">
<?php endforeach; ?>
  <script>document.documentElement.classList.add('js');</script>
</head>
<body class="<?= e($body_class ?? '') ?>">
