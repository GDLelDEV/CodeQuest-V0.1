-- =====================================================================
-- CodeQuest — seed.sql (conteúdo inicial)
-- Execute DEPOIS do schema.sql, no phpMyAdmin (aba SQL ou Importar).
-- Execute UMA vez. Para repetir em ambiente de teste, recrie as tabelas
-- (veja o bloco comentado de reset no início do schema.sql).
--
-- Tipos de desafio: multipla_escolha | verdadeiro_falso |
--                   identificacao_codigo | preenchimento
-- Em "preenchimento", resposta_correta aceita alternativas separadas por "|".
-- XP: facil = 10 | medio = 20 | dificil = 30 | aula = 15
-- =====================================================================

USE codequest;
SET NAMES utf8mb4;
START TRANSACTION;

-- ---------- CURSOS ----------
INSERT INTO cursos (titulo, descricao, linguagem, dificuldade, icone, ativo) VALUES ('HTML — Estrutura da Web', 'Aprenda a estrutura de qualquer página da internet: tags, textos, links, imagens, listas, tabelas e formulários.', 'html', 'Iniciante', '🌐', 1);
INSERT INTO cursos (titulo, descricao, linguagem, dificuldade, icone, ativo) VALUES ('CSS — Estilização de páginas', 'Dê vida às páginas: seletores, cores, fontes, box model, Flexbox, Grid e design responsivo.', 'css', 'Iniciante', '🎨', 1);
INSERT INTO cursos (titulo, descricao, linguagem, dificuldade, icone, ativo) VALUES ('JavaScript — Programação para Web', 'Aprenda a lógica de programação com JavaScript: variáveis, condicionais, laços, funções, arrays e manipulação do DOM.', 'javascript', 'Iniciante', '⚡', 1);
INSERT INTO cursos (titulo, descricao, linguagem, dificuldade, icone, ativo) VALUES ('PHP — Desenvolvimento Backend', 'Programe o lado do servidor: variáveis, estruturas de controle, funções, formulários e acesso ao banco com PDO.', 'php', 'Intermediário', '🐘', 1);
INSERT INTO cursos (titulo, descricao, linguagem, dificuldade, icone, ativo) VALUES ('SQL — Banco de Dados', 'Aprenda SQL na prática: criar tabelas, inserir, consultar, atualizar, excluir e relacionar dados com JOIN.', 'sql', 'Intermediário', '🗄️', 1);

-- ---------- MÓDULOS ----------
INSERT INTO modulos (curso_id, titulo, descricao, ordem) VALUES ((SELECT id FROM cursos WHERE linguagem = 'html'), 'Primeiros passos no HTML', 'O que é HTML e como é a estrutura de uma página.', 1);
INSERT INTO modulos (curso_id, titulo, descricao, ordem) VALUES ((SELECT id FROM cursos WHERE linguagem = 'html'), 'Textos e mídias', 'Títulos, parágrafos, links e imagens.', 2);
INSERT INTO modulos (curso_id, titulo, descricao, ordem) VALUES ((SELECT id FROM cursos WHERE linguagem = 'html'), 'Listas, tabelas e formulários', 'Organize dados e colete informações do usuário.', 3);
INSERT INTO modulos (curso_id, titulo, descricao, ordem) VALUES ((SELECT id FROM cursos WHERE linguagem = 'css'), 'Fundamentos do CSS', 'Como aplicar estilos e escolher elementos.', 1);
INSERT INTO modulos (curso_id, titulo, descricao, ordem) VALUES ((SELECT id FROM cursos WHERE linguagem = 'css'), 'Estilo visual', 'Cores, fontes e o modelo de caixa.', 2);
INSERT INTO modulos (curso_id, titulo, descricao, ordem) VALUES ((SELECT id FROM cursos WHERE linguagem = 'css'), 'Layout moderno', 'Flexbox e Grid.', 3);
INSERT INTO modulos (curso_id, titulo, descricao, ordem) VALUES ((SELECT id FROM cursos WHERE linguagem = 'javascript'), 'Primeiros passos', 'Introdução, variáveis e tipos de dados.', 1);
INSERT INTO modulos (curso_id, titulo, descricao, ordem) VALUES ((SELECT id FROM cursos WHERE linguagem = 'javascript'), 'Lógica de programação', 'Operadores, condicionais e repetições.', 2);
INSERT INTO modulos (curso_id, titulo, descricao, ordem) VALUES ((SELECT id FROM cursos WHERE linguagem = 'javascript'), 'Funções, arrays e DOM', 'Reutilize código e interaja com a página.', 3);
INSERT INTO modulos (curso_id, titulo, descricao, ordem) VALUES ((SELECT id FROM cursos WHERE linguagem = 'php'), 'Fundamentos do PHP', 'Sintaxe, variáveis e operadores.', 1);
INSERT INTO modulos (curso_id, titulo, descricao, ordem) VALUES ((SELECT id FROM cursos WHERE linguagem = 'php'), 'Controle de fluxo e funções', 'Condicionais, repetições e funções.', 2);
INSERT INTO modulos (curso_id, titulo, descricao, ordem) VALUES ((SELECT id FROM cursos WHERE linguagem = 'php'), 'PHP na web e banco de dados', 'Formulários, PDO e CRUD.', 3);
INSERT INTO modulos (curso_id, titulo, descricao, ordem) VALUES ((SELECT id FROM cursos WHERE linguagem = 'sql'), 'Bases de dados e tabelas', 'O que são bancos e como criar tabelas.', 1);
INSERT INTO modulos (curso_id, titulo, descricao, ordem) VALUES ((SELECT id FROM cursos WHERE linguagem = 'sql'), 'Consultando e alterando dados', 'SELECT, UPDATE e DELETE.', 2);
INSERT INTO modulos (curso_id, titulo, descricao, ordem) VALUES ((SELECT id FROM cursos WHERE linguagem = 'sql'), 'Relacionamentos e JOIN', 'Conectando tabelas.', 3);

-- ---------- AULAS ----------
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'html' AND m.ordem = 1), 'Introdução ao HTML', 'HTML (HyperText Markup Language) é a linguagem que descreve o conteúdo de uma página web. Ele não é uma linguagem de programação: usa "tags" para marcar o que é título, parágrafo, imagem, link e assim por diante. O navegador lê o arquivo .html e desenha a página na tela.', '<p>Olá, mundo!</p>', 'HTML marca o conteúdo usando tags. A maioria delas tem abertura (<p>) e fechamento (</p>).', 1, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'html' AND m.ordem = 1), 'Estrutura básica de uma página', 'Toda página HTML começa com <!DOCTYPE html> e é envolvida pela tag <html>. Dentro dela há o <head>, com informações da página (como o título que aparece na aba), e o <body>, com tudo o que é visível ao usuário.', '<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Minha página</title>
</head>
<body>
  <h1>Bem-vindo!</h1>
</body>
</html>', 'head guarda informações; body guarda o conteúdo visível. O lang e o charset ajudam com idioma e acentos.', 2, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'html' AND m.ordem = 2), 'Títulos e parágrafos', 'Os títulos vão de <h1> (mais importante) a <h6>. Use apenas um <h1> por página. Parágrafos de texto usam <p>. Para quebrar linha use <br> e, para destacar, use <strong> (importante) e <em> (ênfase).', '<h1>Meu blog</h1>
<h2>Primeiro post</h2>
<p>Este é um <strong>parágrafo</strong> com <em>ênfase</em>.</p>', 'h1 a h6 organizam o conteúdo em níveis; p cria parágrafos.', 1, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'html' AND m.ordem = 2), 'Links e imagens', 'Links usam a tag <a> com o atributo href, que indica o destino. Imagens usam <img> com src (caminho do arquivo) e alt (texto alternativo, importante para acessibilidade). A tag <img> não tem fechamento.', '<a href="https://www.wikipedia.org" target="_blank">Ir para a Wikipédia</a>
<img src="gato.jpg" alt="Gato dormindo no sofá">', 'a + href cria links; img + src + alt exibe imagens acessíveis.', 2, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'html' AND m.ordem = 3), 'Listas e tabelas', 'Listas não ordenadas usam <ul> e ordenadas usam <ol>; cada item é um <li>. Tabelas usam <table>, com linhas <tr>, células de cabeçalho <th> e células de dados <td>.', '<ul>
  <li>HTML</li>
  <li>CSS</li>
</ul>
<table>
  <tr><th>Nome</th><th>Nota</th></tr>
  <tr><td>Ana</td><td>9</td></tr>
</table>', 'ul/ol + li para listas; table, tr, th e td para tabelas.', 1, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'html' AND m.ordem = 3), 'Formulários', 'Formulários coletam dados com <form>. Dentro dele ficam campos como <input>, <textarea> e <select>, cada um com um <label>. O atributo type do input define o tipo do campo (text, email, password, number) e o botão de envio usa <button type="submit">.', '<form action="/enviar" method="post">
  <label for="email">E-mail:</label>
  <input type="email" id="email" name="email" required>
  <button type="submit">Enviar</button>
</form>', 'form agrupa campos; input type define o tipo; label descreve o campo; required torna obrigatório.', 2, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'css' AND m.ordem = 1), 'Introdução ao CSS', 'CSS (Cascading Style Sheets) controla a aparência do HTML. Uma regra tem um seletor e um bloco de declarações com propriedade e valor. O ideal é manter o CSS em um arquivo separado, ligado com <link rel="stylesheet" href="estilo.css">.', 'p {
  color: blue;
  font-size: 18px;
}', 'CSS = seletor + { propriedade: valor; }.', 1, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'css' AND m.ordem = 1), 'Seletores', 'Seletores escolhem quais elementos receberão o estilo. O seletor de tag usa o nome (p), o de classe usa ponto (.destaque) e o de id usa cerquilha (#topo). Classes podem se repetir em vários elementos; ids devem ser únicos.', 'p { color: gray; }
.destaque { background: yellow; }
#topo { font-size: 32px; }', 'tag, .classe e #id são os seletores mais usados.', 2, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'css' AND m.ordem = 2), 'Cores e fontes', 'Cores podem ser nomes (red), hexadecimais (#8B5CF6), rgb() ou hsl(). Para fontes usamos font-family, font-size e font-weight. Sempre informe uma fonte alternativa caso a primeira não esteja disponível.', 'body {
  font-family: "Poppins", Arial, sans-serif;
  color: #1e293b;
  background-color: #f8fafc;
}', 'Use hex/rgb para cores e font-family com alternativas para fontes.', 1, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'css' AND m.ordem = 2), 'Box Model', 'Todo elemento é uma caixa formada por: conteúdo, padding (espaço interno), border (borda) e margin (espaço externo). Com box-sizing: border-box, a largura definida já inclui padding e borda, o que facilita muito os cálculos.', '* { box-sizing: border-box; }
.card {
  width: 300px;
  padding: 16px;
  border: 2px solid #8B5CF6;
  margin: 24px;
}', 'conteúdo → padding → border → margin. Use border-box para simplificar.', 2, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'css' AND m.ordem = 3), 'Flexbox', 'Flexbox organiza itens em uma direção (linha ou coluna). Ative com display: flex no contêiner. Use justify-content para alinhar no eixo principal, align-items no eixo transversal e gap para espaçar os itens.', '.menu {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
}', 'display:flex + justify-content/align-items/gap alinham itens facilmente.', 1, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'css' AND m.ordem = 3), 'Grid', 'CSS Grid cria layouts em linhas e colunas. Defina com display: grid e grid-template-columns. A unidade fr divide o espaço disponível em frações.', '.galeria {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
}', 'Grid = layout bidimensional; fr divide o espaço em frações.', 2, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'javascript' AND m.ordem = 1), 'Introdução ao JavaScript', 'JavaScript é a linguagem que torna as páginas interativas e roda direto no navegador. Você pode escrevê-lo dentro de <script> ou em um arquivo .js. O comando console.log() exibe valores no console, ótimo para testar.', 'console.log("Olá, CodeQuest!");', 'JS roda no navegador; console.log mostra resultados para testes.', 1, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'javascript' AND m.ordem = 1), 'Variáveis e tipos de dados', 'Variáveis guardam valores. Use const para valores que não mudam e let para os que mudam; evite var. Tipos principais: string (texto), number (número), boolean (true/false), undefined e null. Para ver o tipo, use typeof.', 'const nome = "Ana";
let idade = 15;
const aprovado = true;
console.log(typeof idade); // "number"', 'const não pode ser reatribuída; let pode. Tipos: string, number, boolean...', 2, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'javascript' AND m.ordem = 2), 'Operadores e condicionais', 'Operadores aritméticos: + - * / %. De comparação: === (igual em valor e tipo), !==, >, <, >=, <=. Lógicos: && (e), || (ou), ! (não). A estrutura if / else if / else executa blocos conforme uma condição.', 'const nota = 7;
if (nota >= 7) {
  console.log("Aprovado");
} else {
  console.log("Em recuperação");
}', 'Use === para comparar e if/else para decidir caminhos.', 1, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'javascript' AND m.ordem = 2), 'Repetições', 'Laços repetem código. O for é ideal quando sabemos o número de repetições; o while repete enquanto uma condição for verdadeira. Cuidado com laços infinitos: a condição precisa mudar em algum momento.', 'for (let i = 1; i <= 3; i++) {
  console.log("Volta " + i);
}', 'for (início; condição; passo) e while (condição) repetem blocos de código.', 2, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'javascript' AND m.ordem = 3), 'Funções e arrays', 'Funções agrupam código reutilizável. Arrays guardam listas de valores, com posições começando em 0. Métodos úteis: push() adiciona, length informa o tamanho e map() transforma cada item.', 'function dobro(n) {
  return n * 2;
}
const numeros = [1, 2, 3];
numeros.push(4);
console.log(numeros.map(dobro)); // [2, 4, 6, 8]', 'function + return criam funções; arrays começam no índice 0.', 1, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'javascript' AND m.ordem = 3), 'Manipulando o DOM', 'O DOM é a representação da página que o JavaScript consegue alterar. Selecione elementos com document.querySelector(), mude textos com textContent e reaja a eventos com addEventListener.', 'const botao = document.querySelector("#btn");
botao.addEventListener("click", () => {
  document.querySelector("#msg").textContent = "Você clicou!";
});', 'querySelector seleciona, textContent altera o texto, addEventListener reage a eventos.', 2, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'php' AND m.ordem = 1), 'Introdução ao PHP', 'PHP é uma linguagem executada no servidor: o navegador recebe apenas o HTML gerado. Código PHP fica entre <?php e ?>. Cada instrução termina com ponto e vírgula, e echo exibe conteúdo.', '<?php
echo "Olá, mundo!";
?>', 'PHP roda no servidor; echo imprime; instruções terminam com ;.', 1, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'php' AND m.ordem = 1), 'Variáveis e operadores', 'Variáveis em PHP começam com $ e não precisam de tipo declarado. A concatenação de textos usa o ponto (.). Operadores aritméticos são + - * / %, e a comparação estrita é ===.', '<?php
$nome = "Ana";
$idade = 15;
echo "Olá, " . $nome . "! Você tem " . $idade . " anos.";
?>', '$ identifica variáveis; "." concatena textos.', 2, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'php' AND m.ordem = 2), 'Condicionais', 'Condicionais usam if, elseif e else. Para muitos casos sobre o mesmo valor existe o switch. Em PHP, && e || (ou and/or) combinam condições.', '<?php
$nota = 8;
if ($nota >= 7) {
    echo "Aprovado";
} elseif ($nota >= 5) {
    echo "Recuperação";
} else {
    echo "Reprovado";
}
?>', 'if / elseif / else escolhem qual bloco executar.', 1, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'php' AND m.ordem = 2), 'Repetições e funções', 'PHP possui for, while e foreach (para arrays). Funções são criadas com function e podem retornar valores com return. Use declare(strict_types=1) e tipos nos parâmetros para evitar erros.', '<?php
function dobro(int $n): int {
    return $n * 2;
}
$lista = [1, 2, 3];
foreach ($lista as $item) {
    echo dobro($item) . " ";
}
?>', 'foreach percorre arrays; function + return reaproveitam código.', 2, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'php' AND m.ordem = 3), 'Formulários', 'Dados de formulários chegam em $_POST (método post) ou $_GET (método get). NUNCA confie nos dados do usuário: valide e use htmlspecialchars() ao exibir, para evitar ataques XSS.', '<?php
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $nome = trim($_POST["nome"] ?? "");
    echo "Olá, " . htmlspecialchars($nome, ENT_QUOTES, "UTF-8");
}
?>', '$_POST recebe dados; htmlspecialchars protege a saída.', 1, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'php' AND m.ordem = 3), 'PDO e CRUD', 'PDO é a forma segura de acessar bancos em PHP. Com prepared statements, os valores são enviados separados do SQL, o que bloqueia SQL Injection. CRUD significa Create (INSERT), Read (SELECT), Update e Delete.', '<?php
$stmt = $pdo->prepare("SELECT * FROM users WHERE email = :email");
$stmt->execute([":email" => $email]);
$usuario = $stmt->fetch();
?>', 'Use sempre prepare() + execute() com parâmetros; nunca concatene entrada do usuário no SQL.', 2, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'sql' AND m.ordem = 1), 'Introdução aos bancos de dados', 'Um banco de dados armazena informações de forma organizada. Bancos relacionais, como MySQL e PostgreSQL, guardam dados em tabelas formadas por linhas (registros) e colunas (campos). A linguagem usada para conversar com eles é o SQL.', '-- Exemplo de tabela "alunos"
-- id | nome | idade
--  1 | Ana  | 15
--  2 | Davi | 16', 'Tabela = linhas (registros) + colunas (campos). SQL é a linguagem dos bancos relacionais.', 1, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'sql' AND m.ordem = 1), 'Tabelas e INSERT', 'CREATE TABLE define a estrutura, com colunas, tipos e restrições como PRIMARY KEY, NOT NULL e UNIQUE. INSERT INTO adiciona registros informando as colunas e os valores.', 'CREATE TABLE alunos (
  id INT PRIMARY KEY,
  nome VARCHAR(80) NOT NULL,
  idade INT
);

INSERT INTO alunos (id, nome, idade)
VALUES (1, ''Ana'', 15);', 'CREATE TABLE cria a estrutura; INSERT INTO adiciona dados.', 2, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'sql' AND m.ordem = 2), 'SELECT', 'SELECT consulta dados. Use * para todas as colunas ou liste as desejadas. WHERE filtra linhas, ORDER BY ordena e LIMIT restringe a quantidade de resultados.', 'SELECT nome, idade
FROM alunos
WHERE idade >= 15
ORDER BY nome ASC
LIMIT 10;', 'SELECT colunas FROM tabela WHERE filtro ORDER BY ordem LIMIT n.', 1, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'sql' AND m.ordem = 2), 'UPDATE e DELETE', 'UPDATE altera registros existentes e DELETE remove registros. SEMPRE use WHERE nesses comandos: sem ele, TODAS as linhas da tabela serão afetadas!', 'UPDATE alunos SET idade = 16 WHERE id = 1;
DELETE FROM alunos WHERE id = 2;', 'UPDATE ... SET ... WHERE e DELETE FROM ... WHERE. Nunca esqueça o WHERE.', 2, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'sql' AND m.ordem = 3), 'Relacionamentos e chaves estrangeiras', 'Para evitar repetir dados, dividimos a informação em tabelas relacionadas. Uma chave estrangeira (FOREIGN KEY) em uma tabela aponta para a chave primária de outra, garantindo que a referência exista. Exemplo: cada pedido pertence a um cliente.', 'CREATE TABLE clientes (
  id INT PRIMARY KEY,
  nome VARCHAR(80)
);
CREATE TABLE pedidos (
  id INT PRIMARY KEY,
  cliente_id INT REFERENCES clientes(id),
  total NUMERIC(10,2)
);', 'FOREIGN KEY liga uma tabela à chave primária de outra, mantendo a integridade.', 1, 15);
INSERT INTO aulas (modulo_id, titulo, conteudo, codigo_exemplo, explicacao, ordem, xp_recompensa) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'sql' AND m.ordem = 3), 'JOIN', 'JOIN combina linhas de tabelas relacionadas. INNER JOIN retorna apenas linhas com correspondência nas duas tabelas; LEFT JOIN retorna todas as linhas da tabela da esquerda, mesmo sem correspondência. A condição de ligação usa ON.', 'SELECT c.nome, p.total
FROM clientes c
INNER JOIN pedidos p ON p.cliente_id = c.id;', 'INNER JOIN só traz o que combina; LEFT JOIN mantém todos da esquerda.', 2, 15);

-- ---------- DESAFIOS ----------
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'html' AND m.ordem = 1), 'O que é HTML?', 'Qual alternativa descreve melhor o HTML?', 'multipla_escolha', 'facil', '["Uma linguagem de marcação que estrutura o conteúdo da página", "Uma linguagem para criar bancos de dados", "Um programa para editar imagens", "Uma linguagem usada só para animações"]', 'Uma linguagem de marcação que estrutura o conteúdo da página', 'HTML é uma linguagem de marcação: ela descreve a estrutura e o significado do conteúdo.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'html' AND m.ordem = 1), 'HTML é programação?', 'HTML é uma linguagem de marcação e não uma linguagem de programação.', 'verdadeiro_falso', 'facil', '["Verdadeiro", "Falso"]', 'Verdadeiro', 'HTML não possui lógica como variáveis e condicionais; ele apenas marca o conteúdo.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'html' AND m.ordem = 1), 'Onde fica o conteúdo visível?', 'No código abaixo, qual tag guarda o conteúdo visível da página?

<html>
  <head><title>Oi</title></head>
  <body><p>Texto</p></body>
</html>', 'identificacao_codigo', 'medio', '["<head>", "<body>", "<title>", "<html>"]', '<body>', 'O <body> contém tudo o que aparece na janela do navegador. O <title> aparece apenas na aba.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'html' AND m.ordem = 1), 'Complete o título da aba', 'Complete a tag que define o texto exibido na aba do navegador:

<head>
  <____>Minha página</____>
</head>', 'preenchimento', 'facil', NULL, 'title', 'A tag <title> define o título mostrado na aba do navegador.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'html' AND m.ordem = 2), 'Maior título', 'Qual tag representa o título de maior importância?', 'multipla_escolha', 'facil', '["<h6>", "<h1>", "<title>", "<head>"]', '<h1>', '<h1> é o título principal; <h6> é o de menor importância.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'html' AND m.ordem = 2), 'Vários h1', 'Uma boa prática é usar vários <h1> na mesma página para destacar tudo.', 'verdadeiro_falso', 'facil', '["Verdadeiro", "Falso"]', 'Falso', 'O recomendado é um único <h1> por página, usando h2, h3... para as subdivisões.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'html' AND m.ordem = 2), 'Complete o link', 'Complete o atributo que guarda o destino do link:

<a ____="https://exemplo.com">Visitar</a>', 'preenchimento', 'facil', NULL, 'href', 'href (hypertext reference) guarda o endereço de destino do link.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'html' AND m.ordem = 2), 'Para que serve o alt?', 'Para que serve o atributo alt da tag <img>?', 'multipla_escolha', 'medio', '["Define o tamanho da imagem", "Texto alternativo exibido se a imagem falhar e lido por leitores de tela", "Muda a cor da imagem", "Cria um link na imagem"]', 'Texto alternativo exibido se a imagem falhar e lido por leitores de tela', 'O alt melhora a acessibilidade e aparece quando a imagem não carrega.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'html' AND m.ordem = 2), 'Encontre o erro', 'Qual das linhas abaixo cria uma imagem corretamente?', 'identificacao_codigo', 'dificil', '["<img href=\\"foto.png\\" alt=\\"Foto\\">", "<image src=\\"foto.png\\" alt=\\"Foto\\">", "<img src=\\"foto.png\\" alt=\\"Foto\\">", "<img link=\\"foto.png\\" alt=\\"Foto\\">"]', '<img src="foto.png" alt="Foto">', 'A imagem usa a tag <img> com o atributo src, e não href, image ou link.', 30, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'html' AND m.ordem = 3), 'Lista numerada', 'Qual tag cria uma lista numerada (1, 2, 3...)?', 'multipla_escolha', 'facil', '["<ul>", "<ol>", "<li>", "<table>"]', '<ol>', '<ol> é a lista ordenada. <ul> é a lista com marcadores.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'html' AND m.ordem = 3), 'Célula da tabela', 'Em uma tabela, a tag <td> representa uma linha inteira.', 'verdadeiro_falso', 'medio', '["Verdadeiro", "Falso"]', 'Falso', '<tr> é a linha; <td> é uma célula de dados dentro da linha.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'html' AND m.ordem = 3), 'Campo de senha', 'Complete o tipo para que o texto digitado fique oculto:

<input type="____" name="senha">', 'preenchimento', 'medio', NULL, 'password', 'O tipo password esconde os caracteres digitados.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'html' AND m.ordem = 3), 'Método de envio', 'Qual atributo do <form> define como os dados são enviados (GET ou POST)?', 'multipla_escolha', 'medio', '["action", "method", "type", "name"]', 'method', 'method define o método HTTP; action define o destino.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'html' AND m.ordem = 3), 'Campo obrigatório', 'Qual atributo impede o envio do formulário com o campo vazio?', 'identificacao_codigo', 'dificil', '["placeholder", "required", "value", "disabled"]', 'required', 'O atributo required faz o navegador exigir o preenchimento antes de enviar.', 30, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'css' AND m.ordem = 1), 'Função do CSS', 'Qual é a função do CSS?', 'multipla_escolha', 'facil', '["Estilizar a aparência das páginas", "Guardar dados no servidor", "Criar a lógica de programação", "Definir o texto das páginas"]', 'Estilizar a aparência das páginas', 'CSS cuida da apresentação visual: cores, fontes, espaçamentos e layout.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'css' AND m.ordem = 1), 'Cor do texto', 'Complete a propriedade que muda a cor do texto:

h1 { ____: red; }', 'preenchimento', 'facil', NULL, 'color', 'A propriedade color define a cor do texto.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'css' AND m.ordem = 1), 'Seletor de classe', 'Qual símbolo inicia um seletor de classe?', 'multipla_escolha', 'facil', '["#", ".", "@", "*"]', '.', 'Classe usa ponto (.classe). O id usa #.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'css' AND m.ordem = 1), 'Qual elemento é afetado?', 'Dado o CSS ".aviso { color: red; }", qual elemento fica vermelho?', 'identificacao_codigo', 'medio', '["<p class=\\"aviso\\">Atenção</p>", "<p id=\\"aviso\\">Atenção</p>", "<aviso>Atenção</aviso>", "<p name=\\"aviso\\">Atenção</p>"]', '<p class="aviso">Atenção</p>', 'O seletor .aviso afeta elementos com class="aviso".', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'css' AND m.ordem = 2), 'Cor hexadecimal', 'Qual das opções é uma cor em hexadecimal?', 'multipla_escolha', 'facil', '["rgb(0,0,0)", "#22C55E", "blue", "hsl(120,50%,50%)"]', '#22C55E', 'Cores hexadecimais começam com # seguido de 6 dígitos.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'css' AND m.ordem = 2), 'Fonte', 'Complete a propriedade que define a família da fonte:

body { ____: Arial, sans-serif; }', 'preenchimento', 'medio', NULL, 'font-family', 'font-family escolhe a fonte; os valores seguintes são alternativas.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'css' AND m.ordem = 2), 'Espaço externo', 'Qual propriedade cria espaço FORA da borda do elemento?', 'multipla_escolha', 'medio', '["padding", "margin", "border", "gap"]', 'margin', 'margin é o espaço externo; padding é o interno.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'css' AND m.ordem = 2), 'Padding', 'O padding é o espaço entre o conteúdo e a borda do elemento.', 'verdadeiro_falso', 'medio', '["Verdadeiro", "Falso"]', 'Verdadeiro', 'O padding fica dentro da borda, ao redor do conteúdo.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'css' AND m.ordem = 2), 'Largura total', 'Com box-sizing: content-box, um elemento com width:200px, padding:10px e border:5px (cada lado) ocupa quantos pixels de largura?', 'identificacao_codigo', 'dificil', '["200px", "210px", "230px", "215px"]', '230px', '200 + 10×2 (padding) + 5×2 (borda) = 230px.', 30, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'css' AND m.ordem = 3), 'Ativar o Flexbox', 'Complete o código para ativar o Flexbox no contêiner:

.caixa { display: ____; }', 'preenchimento', 'facil', NULL, 'flex', 'display: flex transforma o elemento em um contêiner flexível.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'css' AND m.ordem = 3), 'Centralizar', 'Qual propriedade centraliza os itens no eixo principal em um contêiner flex?', 'multipla_escolha', 'medio', '["align-items", "justify-content", "text-align", "float"]', 'justify-content', 'justify-content trabalha no eixo principal; align-items no transversal.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'css' AND m.ordem = 3), 'Colunas iguais', 'Qual valor cria 3 colunas de larguras iguais?', 'multipla_escolha', 'medio', '["grid-template-columns: repeat(3, 1fr)", "grid-columns: 3", "columns: 1fr 3", "display: columns(3)"]', 'grid-template-columns: repeat(3, 1fr)', 'repeat(3, 1fr) repete 3 colunas de 1 fração cada.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'css' AND m.ordem = 3), 'Flex x Grid', 'O Grid é ideal para layouts em duas dimensões (linhas e colunas ao mesmo tempo).', 'verdadeiro_falso', 'dificil', '["Verdadeiro", "Falso"]', 'Verdadeiro', 'Flexbox é unidimensional; Grid trabalha com linhas e colunas simultaneamente.', 30, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'css' AND m.ordem = 3), 'Responsividade', 'Complete a media query que aplica o estilo em telas de até 600px:

@media (____-width: 600px) { .menu { flex-direction: column; } }', 'preenchimento', 'dificil', NULL, 'max', 'max-width aplica as regras enquanto a tela for menor ou igual ao valor.', 30, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'javascript' AND m.ordem = 1), 'Para que serve', 'Qual é o principal uso do JavaScript em uma página web?', 'multipla_escolha', 'facil', '["Deixar a página interativa", "Definir apenas as cores", "Armazenar o banco de dados", "Criar o servidor de e-mail"]', 'Deixar a página interativa', 'JS adiciona comportamento: reage a cliques, valida formulários e atualiza a página.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'javascript' AND m.ordem = 1), 'Exibir no console', 'Complete o comando que exibe uma mensagem no console:

____.log("Oi");', 'preenchimento', 'facil', NULL, 'console', 'console.log() imprime no console do navegador.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'javascript' AND m.ordem = 1), 'Qual o tipo?', 'Qual o tipo do valor "10" (entre aspas)?', 'multipla_escolha', 'facil', '["number", "string", "boolean", "undefined"]', 'string', 'Qualquer valor entre aspas é string, mesmo que pareça número.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'javascript' AND m.ordem = 1), 'const', 'Uma variável declarada com const pode receber um novo valor depois.', 'verdadeiro_falso', 'medio', '["Verdadeiro", "Falso"]', 'Falso', 'const impede a reatribuição. Para valores que mudam, use let.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'javascript' AND m.ordem = 1), 'Resultado do typeof', 'O que o código imprime?

let x = true;
console.log(typeof x);', 'identificacao_codigo', 'dificil', '["\\"string\\"", "\\"number\\"", "\\"boolean\\"", "\\"true\\""]', '"boolean"', 'true é um valor booleano, então typeof retorna "boolean".', 30, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'javascript' AND m.ordem = 2), 'Resto da divisão', 'Qual operador retorna o resto de uma divisão?', 'multipla_escolha', 'facil', '["/", "%", "*", "//"]', '%', '% é o módulo: 10 % 3 resulta em 1.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'javascript' AND m.ordem = 2), 'Resultado', 'O que o código imprime?

const n = 5;
if (n > 10) { console.log("A"); }
else if (n > 3) { console.log("B"); }
else { console.log("C"); }', 'identificacao_codigo', 'medio', '["A", "B", "C", "Nada"]', 'B', 'n (5) não é maior que 10, mas é maior que 3, então o segundo bloco executa.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'javascript' AND m.ordem = 2), 'Quantas voltas', 'Quantas vezes o laço abaixo executa?

for (let i = 0; i < 4; i++) { }', 'multipla_escolha', 'facil', '["3", "4", "5", "Infinitas"]', '4', 'i assume 0, 1, 2 e 3: são 4 repetições.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'javascript' AND m.ordem = 2), 'Soma', 'Complete para somar 1 a i a cada volta:

for (let i = 0; i < 5; ____) { }', 'preenchimento', 'medio', NULL, 'i++|i += 1|i=i+1|i = i + 1', 'i++ incrementa i em 1 a cada repetição.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'javascript' AND m.ordem = 2), 'Laço infinito', 'O código while (true) { } sem nenhuma instrução de parada gera um laço infinito.', 'verdadeiro_falso', 'dificil', '["Verdadeiro", "Falso"]', 'Verdadeiro', 'A condição true nunca muda para falso, então o laço nunca termina.', 30, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'javascript' AND m.ordem = 3), 'Primeiro item', 'Como acessar o primeiro item do array frutas?', 'multipla_escolha', 'facil', '["frutas[1]", "frutas[0]", "frutas.first", "frutas(0)"]', 'frutas[0]', 'Arrays são indexados a partir do 0.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'javascript' AND m.ordem = 3), 'Retorno', 'Complete para a função devolver a soma:

function somar(a, b) { ____ a + b; }', 'preenchimento', 'medio', NULL, 'return', 'return devolve o valor calculado para quem chamou a função.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'javascript' AND m.ordem = 3), 'Selecionar elemento', 'Qual método seleciona o primeiro elemento que combina com um seletor CSS?', 'multipla_escolha', 'medio', '["document.querySelector()", "document.getAll()", "document.find()", "window.select()"]', 'document.querySelector()', 'querySelector aceita qualquer seletor CSS (#id, .classe, tag).', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'javascript' AND m.ordem = 3), 'Eventos', 'addEventListener("click", ...) executa uma função quando o usuário clica no elemento.', 'verdadeiro_falso', 'medio', '["Verdadeiro", "Falso"]', 'Verdadeiro', 'Ele "escuta" o evento e chama a função informada quando ele ocorre.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'javascript' AND m.ordem = 3), 'Qual evento', 'Qual evento dispara quando um formulário é enviado?', 'identificacao_codigo', 'dificil', '["click", "submit", "change", "load"]', 'submit', 'O evento submit é disparado no <form> ao enviá-lo.', 30, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'php' AND m.ordem = 1), 'Onde roda', 'Onde o código PHP é executado?', 'multipla_escolha', 'facil', '["No navegador do usuário", "No servidor", "No monitor", "No roteador"]', 'No servidor', 'O servidor executa o PHP e envia ao navegador apenas o resultado (HTML).', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'php' AND m.ordem = 1), 'Exibir texto', 'Complete o comando que exibe texto em PHP:

<?php ____ "Oi"; ?>', 'preenchimento', 'facil', NULL, 'echo', 'echo envia o texto para a saída da página.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'php' AND m.ordem = 1), 'Variável', 'Qual é uma variável válida em PHP?', 'multipla_escolha', 'facil', '["nome", "$nome", "@nome", "#nome"]', '$nome', 'Toda variável PHP começa com o símbolo $.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'php' AND m.ordem = 1), 'Concatenação', 'O que o código imprime?

$a = "Code";
$b = "Quest";
echo $a . $b;', 'identificacao_codigo', 'medio', '["Code Quest", "CodeQuest", "Code.Quest", "$a$b"]', 'CodeQuest', 'O ponto concatena os textos sem espaço entre eles.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'php' AND m.ordem = 1), 'Tipos', 'Em PHP é obrigatório declarar o tipo da variável ao criá-la.', 'verdadeiro_falso', 'medio', '["Verdadeiro", "Falso"]', 'Falso', 'PHP é dinamicamente tipado: o tipo é definido pelo valor atribuído.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'php' AND m.ordem = 2), 'Else if', 'Qual palavra-chave testa uma segunda condição em PHP?', 'multipla_escolha', 'facil', '["elseif", "elif", "else-if", "elsif"]', 'elseif', 'Em PHP escreve-se elseif (ou else if). elif é do Python.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'php' AND m.ordem = 2), 'Resultado', 'O que o código imprime?

$n = 5;
if ($n > 5) { echo "A"; } elseif ($n == 5) { echo "B"; } else { echo "C"; }', 'identificacao_codigo', 'medio', '["A", "B", "C", "Nada"]', 'B', 'n não é maior que 5, mas é igual a 5, logo executa o bloco elseif.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'php' AND m.ordem = 2), 'Percorrer array', 'Qual estrutura é feita para percorrer arrays?', 'multipla_escolha', 'facil', '["foreach", "loopeach", "repeat", "each-for"]', 'foreach', 'foreach percorre cada elemento de um array.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'php' AND m.ordem = 2), 'Função', 'Complete a palavra que declara uma função:

____ saudacao($nome) { return "Oi, " . $nome; }', 'preenchimento', 'medio', NULL, 'function', 'Funções em PHP são declaradas com a palavra function.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'php' AND m.ordem = 2), 'Retorno', 'Uma função sem a instrução return devolve NULL por padrão.', 'verdadeiro_falso', 'dificil', '["Verdadeiro", "Falso"]', 'Verdadeiro', 'Sem return explícito, a função retorna NULL.', 30, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'php' AND m.ordem = 3), 'Superglobal', 'Qual variável recebe os dados enviados por um formulário com method="post"?', 'multipla_escolha', 'facil', '["$_GET", "$_POST", "$_FORM", "$_DATA"]', '$_POST', '$_POST guarda os campos enviados via POST.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'php' AND m.ordem = 3), 'Proteção XSS', 'Qual função ajuda a evitar XSS ao exibir texto digitado pelo usuário?', 'multipla_escolha', 'medio', '["htmlspecialchars()", "strtoupper()", "trim()", "count()"]', 'htmlspecialchars()', 'Ela converte caracteres especiais do HTML em entidades inofensivas.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'php' AND m.ordem = 3), 'Prepared statements', 'Qual é a principal vantagem dos prepared statements?', 'multipla_escolha', 'medio', '["Deixam o SQL mais bonito", "Protegem contra SQL Injection", "Aceleram a internet", "Criam tabelas automaticamente"]', 'Protegem contra SQL Injection', 'Valores e SQL são enviados separadamente, impedindo que a entrada altere o comando.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'php' AND m.ordem = 3), 'CRUD', 'A letra "U" de CRUD corresponde à operação UPDATE.', 'verdadeiro_falso', 'medio', '["Verdadeiro", "Falso"]', 'Verdadeiro', 'CRUD = Create, Read, Update, Delete.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'php' AND m.ordem = 3), 'Qual é seguro', 'Qual consulta é segura contra SQL Injection?', 'identificacao_codigo', 'dificil', '["$pdo->query(\\"SELECT * FROM users WHERE id = \\" . $_GET[\\"id\\"]);", "$pdo->prepare(\\"SELECT * FROM users WHERE id = :id\\")->execute([\\":id\\" => $_GET[\\"id\\"]]);", "mysql_query(\\"SELECT * FROM users WHERE id = $id\\");", "$pdo->exec(\\"DELETE FROM users WHERE id = {$_GET[''id'']}\\");"]', '$pdo->prepare("SELECT * FROM users WHERE id = :id")->execute([":id" => $_GET["id"]]);', 'Somente a opção com prepare()+parâmetro nomeado separa o SQL dos dados do usuário.', 30, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'sql' AND m.ordem = 1), 'O que é SQL', 'O que significa SQL?', 'multipla_escolha', 'facil', '["Structured Query Language", "Simple Question List", "System Quick Link", "Style Query Layout"]', 'Structured Query Language', 'SQL é a linguagem estruturada de consulta usada em bancos relacionais.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'sql' AND m.ordem = 1), 'Banco relacional', 'MySQL e PostgreSQL são bancos de dados relacionais.', 'verdadeiro_falso', 'facil', '["Verdadeiro", "Falso"]', 'Verdadeiro', 'Ambos organizam os dados em tabelas relacionadas entre si.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'sql' AND m.ordem = 1), 'Inserir dados', 'Complete o comando que adiciona um registro:

____ INTO alunos (id, nome) VALUES (2, ''Davi'');', 'preenchimento', 'facil', NULL, 'INSERT', 'INSERT INTO adiciona uma nova linha na tabela.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'sql' AND m.ordem = 1), 'Chave primária', 'Para que serve uma PRIMARY KEY?', 'multipla_escolha', 'medio', '["Identificar cada registro de forma única", "Apagar a tabela", "Ordenar os dados alfabeticamente", "Criptografar a senha"]', 'Identificar cada registro de forma única', 'A chave primária é única e não nula: identifica cada linha.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'sql' AND m.ordem = 1), 'Qual está correto', 'Qual comando cria uma tabela corretamente?', 'identificacao_codigo', 'dificil', '["CREATE TABLE produtos (id INT PRIMARY KEY, nome VARCHAR(50));", "NEW TABLE produtos (id INT, nome VARCHAR(50));", "CREATE produtos TABLE (id INT, nome VARCHAR(50));", "MAKE TABLE produtos { id INT };"]', 'CREATE TABLE produtos (id INT PRIMARY KEY, nome VARCHAR(50));', 'A sintaxe correta é CREATE TABLE nome (coluna tipo, ...).', 30, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'sql' AND m.ordem = 2), 'Filtrar', 'Qual cláusula filtra as linhas retornadas por um SELECT?', 'multipla_escolha', 'facil', '["WHERE", "ORDER BY", "GROUP", "FILTER"]', 'WHERE', 'WHERE aplica a condição de filtro às linhas.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'sql' AND m.ordem = 2), 'Ordenar', 'Complete para ordenar do maior para o menor:

SELECT * FROM alunos ORDER BY idade ____;', 'preenchimento', 'medio', NULL, 'DESC', 'DESC ordena de forma decrescente; ASC, crescente.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'sql' AND m.ordem = 2), 'Sem WHERE', 'Executar DELETE FROM alunos; (sem WHERE) apaga todos os registros da tabela.', 'verdadeiro_falso', 'facil', '["Verdadeiro", "Falso"]', 'Verdadeiro', 'Sem condição, DELETE afeta todas as linhas.', 10, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'sql' AND m.ordem = 2), 'Atualizar', 'Complete o comando:

____ alunos SET nome = ''Ana Lima'' WHERE id = 1;', 'preenchimento', 'medio', NULL, 'UPDATE', 'UPDATE tabela SET coluna = valor WHERE condição.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'sql' AND m.ordem = 2), 'Comando perigoso', 'Qual comando altera a idade de TODOS os alunos para 20?', 'identificacao_codigo', 'dificil', '["UPDATE alunos SET idade = 20;", "UPDATE alunos SET idade = 20 WHERE id = 1;", "SELECT idade = 20 FROM alunos;", "INSERT alunos idade = 20;"]', 'UPDATE alunos SET idade = 20;', 'Sem WHERE, o UPDATE atinge todas as linhas.', 30, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'sql' AND m.ordem = 3), 'Chave estrangeira', 'O que garante uma chave estrangeira?', 'multipla_escolha', 'medio', '["Que o valor referenciado exista na outra tabela", "Que a tabela fique criptografada", "Que não haja duplicados", "Que a coluna seja numérica"]', 'Que o valor referenciado exista na outra tabela', 'Ela mantém a integridade referencial entre as tabelas.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'sql' AND m.ordem = 3), 'Relação 1:N', 'Em "um cliente tem vários pedidos", a tabela pedidos guarda o id do cliente.', 'verdadeiro_falso', 'medio', '["Verdadeiro", "Falso"]', 'Verdadeiro', 'No lado "muitos" fica a chave estrangeira apontando para o lado "um".', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'sql' AND m.ordem = 3), 'INNER JOIN', 'O que o INNER JOIN retorna?', 'multipla_escolha', 'medio', '["Somente linhas com correspondência nas duas tabelas", "Todas as linhas da primeira tabela", "Todas as linhas de ambas, sempre", "Apenas linhas duplicadas"]', 'Somente linhas com correspondência nas duas tabelas', 'Linhas sem correspondência em alguma das tabelas ficam de fora.', 20, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'sql' AND m.ordem = 3), 'Condição do JOIN', 'Complete a palavra que informa a condição de ligação:

SELECT * FROM pedidos p JOIN clientes c ____ p.cliente_id = c.id;', 'preenchimento', 'dificil', NULL, 'ON', 'A cláusula ON define como as tabelas se relacionam.', 30, 1);
INSERT INTO desafios (modulo_id, titulo, enunciado, tipo, dificuldade, alternativas, resposta_correta, explicacao, xp_recompensa, ativo) VALUES ((SELECT m.id FROM modulos m JOIN cursos c ON c.id = m.curso_id WHERE c.linguagem = 'sql' AND m.ordem = 3), 'LEFT JOIN', 'Um cliente sem nenhum pedido aparece no resultado de qual consulta?', 'identificacao_codigo', 'dificil', '["clientes c INNER JOIN pedidos p ON p.cliente_id = c.id", "clientes c LEFT JOIN pedidos p ON p.cliente_id = c.id", "pedidos p INNER JOIN clientes c ON c.id = p.cliente_id", "Nenhuma das anteriores"]', 'clientes c LEFT JOIN pedidos p ON p.cliente_id = c.id', 'LEFT JOIN mantém todas as linhas da tabela da esquerda (clientes), com NULL onde não há pedido.', 30, 1);

-- ---------- CONQUISTAS ----------
INSERT INTO conquistas (titulo, descricao, icone, tipo_requisito, valor_requisito) VALUES ('Primeiro Passo', 'Conclua sua primeira aula.', '👣', 'aulas_concluidas', 1);
INSERT INTO conquistas (titulo, descricao, icone, tipo_requisito, valor_requisito) VALUES ('Primeiro Desafio', 'Resolva corretamente seu primeiro desafio.', '🎯', 'desafios_acertados', 1);
INSERT INTO conquistas (titulo, descricao, icone, tipo_requisito, valor_requisito) VALUES ('Estudante Dedicado', 'Conclua 10 aulas.', '📚', 'aulas_concluidas', 10);
INSERT INTO conquistas (titulo, descricao, icone, tipo_requisito, valor_requisito) VALUES ('Desbravador', 'Conclua um curso completo.', '🏁', 'cursos_concluidos', 1);
INSERT INTO conquistas (titulo, descricao, icone, tipo_requisito, valor_requisito) VALUES ('Programador Iniciante', 'Alcance 100 XP.', '🌱', 'xp_total', 100);
INSERT INTO conquistas (titulo, descricao, icone, tipo_requisito, valor_requisito) VALUES ('Persistente', 'Estude durante 7 dias seguidos.', '🔥', 'sequencia_dias', 7);
INSERT INTO conquistas (titulo, descricao, icone, tipo_requisito, valor_requisito) VALUES ('Mestre dos Desafios', 'Resolva corretamente 50 desafios.', '🏆', 'desafios_acertados', 50);
INSERT INTO conquistas (titulo, descricao, icone, tipo_requisito, valor_requisito) VALUES ('Mestre do HTML', 'Conclua o curso de HTML.', '🌐', 'curso_concluido:html', 1);
INSERT INTO conquistas (titulo, descricao, icone, tipo_requisito, valor_requisito) VALUES ('Explorador', 'Conclua aulas em 3 cursos diferentes.', '🧭', 'cursos_iniciados', 3);
INSERT INTO conquistas (titulo, descricao, icone, tipo_requisito, valor_requisito) VALUES ('Lenda do Código', 'Alcance 1.000 XP (nível 6).', '👑', 'xp_total', 1000);

-- ---------- MISSÕES DIÁRIAS ----------
INSERT INTO missoes (titulo, descricao, tipo, meta, xp_recompensa, ativa) VALUES ('Concluir uma aula', 'Conclua 1 aula hoje.', 'concluir_aula', 1, 15, 1);
INSERT INTO missoes (titulo, descricao, tipo, meta, xp_recompensa, ativa) VALUES ('Resolver dois desafios', 'Acerte 2 desafios hoje.', 'resolver_desafios', 2, 20, 1);
INSERT INTO missoes (titulo, descricao, tipo, meta, xp_recompensa, ativa) VALUES ('Ganhar 30 XP', 'Acumule 30 XP hoje.', 'ganhar_xp', 30, 25, 1);
INSERT INTO missoes (titulo, descricao, tipo, meta, xp_recompensa, ativa) VALUES ('Acessar um curso', 'Abra um curso hoje.', 'acessar_curso', 1, 10, 1);

COMMIT;
