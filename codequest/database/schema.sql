-- =====================================================================
-- CodeQuest — schema.sql (MySQL / MariaDB — XAMPP)
-- Como executar: phpMyAdmin > aba "SQL" > cole este arquivo > Executar
-- (ou aba "Importar" > escolha o arquivo).
-- Pode ser executado mais de uma vez (CREATE ... IF NOT EXISTS).
-- =====================================================================

CREATE DATABASE IF NOT EXISTS codequest
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE codequest;

SET NAMES utf8mb4;

-- Para recomeçar do zero em ambiente de TESTE (apaga TODOS os dados),
-- descomente o bloco abaixo, execute, e depois rode schema + seed de novo:
-- SET FOREIGN_KEY_CHECKS = 0;
-- DROP TABLE IF EXISTS historico_atividades, usuario_conquistas, conquistas,
--     usuario_missoes, missoes, tentativas, desafios, progresso_aulas,
--     aulas, modulos, cursos, usuarios;
-- SET FOREIGN_KEY_CHECKS = 1;

-- ---------------------------------------------------------------------
-- USUÁRIOS
-- senha: guarda o HASH gerado por password_hash() (nunca texto puro)
-- tipo_usuario: 'student' (estudante) ou 'admin' (administrador)
-- sequencia_dias / ultimo_estudo: usados pelas conquistas de constância
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS usuarios (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome            VARCHAR(120) NOT NULL,
    username        VARCHAR(50)  NOT NULL,
    email           VARCHAR(150) NOT NULL,
    senha           VARCHAR(255) NOT NULL,
    avatar          VARCHAR(255) NULL,
    xp_total        INT UNSIGNED NOT NULL DEFAULT 0,
    nivel           INT UNSIGNED NOT NULL DEFAULT 1,
    tipo_usuario    ENUM('student','admin') NOT NULL DEFAULT 'student',
    sequencia_dias  INT UNSIGNED NOT NULL DEFAULT 0,
    ultimo_estudo   DATE NULL,
    data_cadastro   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_usuarios_username (username),
    UNIQUE KEY uq_usuarios_email (email),
    KEY idx_usuarios_ranking (xp_total, id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- CURSOS / MÓDULOS / AULAS
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS cursos (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    titulo      VARCHAR(120) NOT NULL,
    descricao   TEXT NULL,
    linguagem   VARCHAR(50)  NOT NULL,          -- html, css, javascript, php, sql
    dificuldade VARCHAR(30)  NULL,
    icone       VARCHAR(100) NULL,
    ativo       TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cursos_linguagem (linguagem)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS modulos (
    id         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    curso_id   BIGINT UNSIGNED NOT NULL,
    titulo     VARCHAR(120) NOT NULL,
    descricao  TEXT NULL,
    ordem      INT UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    UNIQUE KEY uq_modulos_ordem (curso_id, ordem),
    CONSTRAINT fk_modulos_curso FOREIGN KEY (curso_id)
        REFERENCES cursos (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- codigo_exemplo e explicacao foram adicionados porque a especificação
-- pede "exemplos de código" e "explicações" em cada aula.
CREATE TABLE IF NOT EXISTS aulas (
    id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    modulo_id      BIGINT UNSIGNED NOT NULL,
    titulo         VARCHAR(120) NOT NULL,
    conteudo       TEXT NULL,
    codigo_exemplo TEXT NULL,
    explicacao     TEXT NULL,
    ordem          INT UNSIGNED NOT NULL DEFAULT 1,
    xp_recompensa  INT UNSIGNED NOT NULL DEFAULT 15,
    PRIMARY KEY (id),
    UNIQUE KEY uq_aulas_ordem (modulo_id, ordem),
    CONSTRAINT fk_aulas_modulo FOREIGN KEY (modulo_id)
        REFERENCES modulos (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- PROGRESSO DAS AULAS
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS progresso_aulas (
    id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    usuario_id     BIGINT UNSIGNED NOT NULL,
    aula_id        BIGINT UNSIGNED NOT NULL,
    concluida      TINYINT(1) NOT NULL DEFAULT 0,
    data_conclusao DATETIME NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_progresso_usuario_aula (usuario_id, aula_id),
    CONSTRAINT fk_progresso_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE,
    CONSTRAINT fk_progresso_aula FOREIGN KEY (aula_id)
        REFERENCES aulas (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- DESAFIOS
-- tipo: multipla_escolha | verdadeiro_falso | identificacao_codigo | preenchimento
-- alternativas: lista JSON (ex.: ["A","B","C"]); NULL em "preenchimento"
-- resposta_correta: NUNCA deve ser enviada ao navegador.
--   Em "preenchimento" aceita alternativas separadas por "|".
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS desafios (
    id               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    modulo_id        BIGINT UNSIGNED NOT NULL,
    titulo           VARCHAR(120) NOT NULL,
    enunciado        TEXT NOT NULL,
    tipo             ENUM('multipla_escolha','verdadeiro_falso','identificacao_codigo','preenchimento') NOT NULL,
    dificuldade      ENUM('facil','medio','dificil') NOT NULL DEFAULT 'facil',
    alternativas     TEXT NULL,
    resposta_correta TEXT NOT NULL,
    explicacao       TEXT NULL,
    xp_recompensa    INT UNSIGNED NOT NULL DEFAULT 10,
    ativo            TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    KEY idx_desafios_modulo (modulo_id),
    CONSTRAINT fk_desafios_modulo FOREIGN KEY (modulo_id)
        REFERENCES modulos (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- TENTATIVAS (todas, inclusive as erradas)
-- xp_ganho: XP concedido nesta tentativa (0 se errou ou se já havia ganho).
-- xp_concedido: vale 1 SOMENTE na tentativa que concedeu XP, senão NULL.
--   Com o UNIQUE abaixo, o próprio banco impede XP duplicado do mesmo
--   desafio para o mesmo usuário (valores NULL não contam como duplicados).
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tentativas (
    id                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    usuario_id        BIGINT UNSIGNED NOT NULL,
    desafio_id        BIGINT UNSIGNED NOT NULL,
    resposta_enviada  TEXT NULL,
    acertou           TINYINT(1) NOT NULL DEFAULT 0,
    xp_ganho          INT UNSIGNED NOT NULL DEFAULT 0,
    xp_concedido      TINYINT(1) NULL DEFAULT NULL,
    data_tentativa    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_tentativa_xp_unico (usuario_id, desafio_id, xp_concedido),
    KEY idx_tentativas_usuario (usuario_id, data_tentativa),
    KEY idx_tentativas_desafio (desafio_id),
    CONSTRAINT fk_tentativas_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE,
    CONSTRAINT fk_tentativas_desafio FOREIGN KEY (desafio_id)
        REFERENCES desafios (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- MISSÕES DIÁRIAS
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS missoes (
    id            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    titulo        VARCHAR(120) NOT NULL,
    descricao     TEXT NULL,
    tipo          VARCHAR(50)  NOT NULL,   -- concluir_aula | resolver_desafios | ganhar_xp | acessar_curso
    meta          INT UNSIGNED NOT NULL DEFAULT 1,
    xp_recompensa INT UNSIGNED NOT NULL DEFAULT 0,
    ativa         TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    UNIQUE KEY uq_missoes_titulo (titulo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS usuario_missoes (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    usuario_id      BIGINT UNSIGNED NOT NULL,
    missao_id       BIGINT UNSIGNED NOT NULL,
    progresso       INT UNSIGNED NOT NULL DEFAULT 0,
    concluida       TINYINT(1) NOT NULL DEFAULT 0,
    data_referencia DATE NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_usuario_missao_dia (usuario_id, missao_id, data_referencia),
    CONSTRAINT fk_umissoes_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE,
    CONSTRAINT fk_umissoes_missao FOREIGN KEY (missao_id)
        REFERENCES missoes (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- CONQUISTAS
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS conquistas (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    titulo          VARCHAR(100) NOT NULL,
    descricao       TEXT NULL,
    icone           VARCHAR(100) NULL,
    tipo_requisito  VARCHAR(50)  NOT NULL,
    valor_requisito INT UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    UNIQUE KEY uq_conquistas_titulo (titulo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS usuario_conquistas (
    id               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    usuario_id       BIGINT UNSIGNED NOT NULL,
    conquista_id     BIGINT UNSIGNED NOT NULL,
    data_desbloqueio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_usuario_conquista (usuario_id, conquista_id),
    CONSTRAINT fk_uconq_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE,
    CONSTRAINT fk_uconq_conquista FOREIGN KEY (conquista_id)
        REFERENCES conquistas (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- HISTÓRICO DE ATIVIDADES
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS historico_atividades (
    id             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    usuario_id     BIGINT UNSIGNED NOT NULL,
    atividade      VARCHAR(50)  NOT NULL,
    descricao      VARCHAR(255) NULL,
    xp_ganho       INT UNSIGNED NOT NULL DEFAULT 0,
    data_atividade TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_historico_usuario (usuario_id, data_atividade),
    CONSTRAINT fk_historico_usuario FOREIGN KEY (usuario_id)
        REFERENCES usuarios (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
