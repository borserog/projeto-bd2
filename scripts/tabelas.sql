CREATE TABLE estado
(
    uf char(2) NOT NULL,
    nome varchar(40) NOT NULL,
    PRIMARY KEY (uf)
);

CREATE TABLE cidade
(
    idCidade int NOT NULL,
    nome varchar(50) NOT NULL,
    uf char(2) NOT NULL,
    PRIMARY KEY (idCidade),
    CONSTRAINT FK_estado FOREIGN KEY (uf)
        REFERENCES estado (uf) MATCH SIMPLE
);

CREATE TABLE categoria_cnh
(
    idCategoriaCNH char(3) NOT NULL,
    descricao text NOT NULL,
    PRIMARY KEY (idCategoriaCNH)
);

CREATE TABLE tipo
(
    idTipo SERIAL,
    descricao varchar(30)
);

CREATE TABLE marca
(
  idMarca SERIAL,
  nome varchar(40) NOT NULL,
  origem varchar(40) NOT NULL
);

/* ----- */

CREATE TABLE especie
(
	idEspecie SERIAL PRIMARY KEY,
	descricao VARCHAR(30) NOT NULL
);

/* 
    TABELA categoria_veiculo - Não entendi a parte da FK que recebe da tabela especie (???)
*/

CREATE TABLE infracao
(
	idInfracao SERIAL PRIMARY KEY,
	descricao VARCHAR(50) NOT NULL,
	valor numeric(5,2) NOT NULL,
	pontos INT NOT NULL
);