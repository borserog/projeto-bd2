
SET datestyle TO dmy;

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

CREATE TABLE condutor
(
	idCadastro SERIAL PRIMARY KEY,
	cpf char(11) NOT NULL,
	nome varchar(50) NOT NULL,
	dataNasc date NOT NULL,
	idCategoriaCNH char(3) NOT NULL,
	endereco varchar(50) NOT NULL, 
	bairro varchar(30) NOT NULL,
	idCidade int NOT NULL,
	situacaoCNH char(1) NOT NULL,
	CONSTRAINT FK_categoria_cnh FOREIGN KEY (idCategoriaCNH)
		REFERENCES categoria_cnh (idCategoriaCNH) MATCH SIMPLE,
	CONSTRAINT FK_cidade FOREIGN KEY (idCidade)
		REFERENCES cidade (idCidade) MATCH SIMPLE,
	CONSTRAINT cpf_valido CHECK (cpf NOT LIKE '[0-9]'),
	CONSTRAINT situacao_valida CHECK (situacaoCNH ~* '[r||s||R||S]')
);

CREATE TABLE marca
(
  idMarca SERIAL PRIMARY KEY,
  nome varchar(40) NOT NULL,
  origem varchar(40) NOT NULL
);

CREATE TABLE tipo
(
    idTipo SERIAL PRIMARY KEY,
    descricao varchar(30)
);

CREATE TABLE modelo
(
    idModelo SERIAL PRIMARY KEY,
    denominacao varchar(40),
    idMarca int NOT NULL,
    idTipo int NOT NULL,
    CONSTRAINT FK_marca FOREIGN KEY (idMarca)
        REFERENCES marca MATCH SIMPLE,
    CONSTRAINT FK_tipo FOREIGN KEY (idTipo)
        REFERENCES tipo MATCH SIMPLE
);

CREATE TABLE infracao
(
	idInfracao SERIAL PRIMARY KEY,
	descricao VARCHAR(50) NOT NULL,
	valor numeric(5,2) NOT NULL,
	pontos INT NOT NULL
);

CREATE TABLE especie
(
	idEspecie SERIAL PRIMARY KEY,
	descricao VARCHAR(30) NOT NULL
);

CREATE TABLE categoria_veiculo
(
	idCategoria SERIAL PRIMARY KEY,
	descricao VARCHAR(30) NOT NULL,
	idEspecie INT NOT NULL,
	CONSTRAINT FK_categoriaVeiculo FOREIGN KEY (idEspecie)
		REFERENCES especie
);

-- TODO VEICULO

-- TODO MULTA

-- TODO LICENCIAMENTO

-- TODO TRANSFERENCIA


