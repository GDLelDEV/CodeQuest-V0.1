<?php
declare(strict_types=1);

/**
 * Sistema central de XP. TODA concessão de XP do projeto passa por aqui.
 * O valor do XP sempre vem do banco (aulas/desafios), nunca do navegador.
 * Estas funções DEVEM ser chamadas dentro de uma transação (beginTransaction).
 */

/** Já existe um registro com esta atividade para o usuário? (evita bônus repetido) */
function atividade_ja_registrada(PDO $pdo, int $uid, string $atividade): bool
{
    $st = $pdo->prepare('SELECT 1 FROM historico_atividades WHERE usuario_id = :u AND atividade = :a LIMIT 1');
    $st->execute([':u' => $uid, ':a' => $atividade]);
    return (bool) $st->fetchColumn();
}

/** Atualiza a sequência de dias estudados (1 por dia). */
function registrar_estudo(PDO $pdo, int $uid): void
{
    $st = $pdo->prepare('SELECT ultimo_estudo, sequencia_dias FROM usuarios WHERE id = :id');
    $st->execute([':id' => $uid]);
    $u = $st->fetch();
    if (!$u) {
        return;
    }
    $hoje  = date('Y-m-d');
    $ontem = date('Y-m-d', strtotime('-1 day'));
    if ($u['ultimo_estudo'] === $hoje) {
        return;
    }
    $nova = ($u['ultimo_estudo'] === $ontem) ? ((int) $u['sequencia_dias'] + 1) : 1;
    $pdo->prepare('UPDATE usuarios SET sequencia_dias = :s, ultimo_estudo = :d WHERE id = :id')
        ->execute([':s' => $nova, ':d' => $hoje, ':id' => $uid]);
}

/**
 * Concede XP: soma no usuário, recalcula o nível e registra no histórico.
 * $atividade é a "chave" da atividade (ex.: 'aula_concluida', 'modulo:3', 'curso:1').
 * (Missões e conquistas serão acopladas aqui na ETAPA 6.)
 *
 * @return array{xp:int,total:int,nivel_antes:int,nivel_depois:int}
 */
function conceder_xp(PDO $pdo, int $uid, int $xp, string $atividade, string $descricao): array
{
    if (!$pdo->inTransaction()) {
        throw new LogicException('conceder_xp() exige uma transação ativa.');
    }
    if ($xp < 0) {
        throw new InvalidArgumentException('XP inválido.');
    }

    $st = $pdo->prepare('SELECT xp_total FROM usuarios WHERE id = :id FOR UPDATE');
    $st->execute([':id' => $uid]);
    $atual = (int) $st->fetchColumn();
    $novo  = $atual + $xp;
    $nivel = calcular_nivel($novo);

    $pdo->prepare('UPDATE usuarios SET xp_total = :x, nivel = :n WHERE id = :id')
        ->execute([':x' => $novo, ':n' => $nivel, ':id' => $uid]);

    $pdo->prepare(
        'INSERT INTO historico_atividades (usuario_id, atividade, descricao, xp_ganho)
         VALUES (:u, :a, :d, :x)'
    )->execute([':u' => $uid, ':a' => $atividade, ':d' => mb_substr($descricao, 0, 255), ':x' => $xp]);

    return ['xp' => $xp, 'total' => $novo, 'nivel_antes' => calcular_nivel($atual), 'nivel_depois' => $nivel];
}
