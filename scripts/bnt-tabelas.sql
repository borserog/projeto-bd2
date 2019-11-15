
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
    CONSTRAINT fk_estado FOREIGN KEY (uf)
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
	situacaoCNH char(1) NOT NULL DEFAULT 'R',
	CONSTRAINT fk_categoria_cnh FOREIGN KEY (idCategoriaCNH)
		REFERENCES categoria_cnh (idCategoriaCNH) MATCH SIMPLE,
	CONSTRAINT fk_cidade FOREIGN KEY (idCidade)
		REFERENCES cidade (idCidade) MATCH SIMPLE,
	CONSTRAINT chk_cpf_valido CHECK (cpf NOT LIKE '[0-9]'),
	CONSTRAINT chk_situacao_valida
	    CHECK (situacaoCNH IN ('R', 'S'))
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
    CONSTRAINT fk_marca FOREIGN KEY (idMarca)
        REFERENCES marca MATCH SIMPLE,
    CONSTRAINT fk_tipo FOREIGN KEY (idTipo)
        REFERENCES tipo MATCH SIMPLE
);

CREATE TABLE infracao
(
	idInfracao SERIAL PRIMARY KEY,
	descricao VARCHAR(100) NOT NULL,
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
	CONSTRAINT fk_categoriaVeiculo FOREIGN KEY (idEspecie)
		REFERENCES especie
);

CREATE TABLE veiculo
(
  renavam char(13) PRIMARY KEY,
  placa char(7) NOT NULL,
  ano int NOT NULL,
  idCategoria int NOT NULL,
  idProprietario int NOT NULL,
  idModelo int NOT NULL,
  idCidade int NOT NULL,
  dataCompra date NOT NULL,
  dataAquisicao date NOT NULL,
  valor numeric(7, 2) NOT NULL,
  situacao char(1) NOT NULL,
    CONSTRAINT fk_categoria_veiculo FOREIGN KEY (idCategoria)
		REFERENCES categoria_veiculo,
    CONSTRAINT fk_condutor FOREIGN KEY (idProprietario)
		REFERENCES condutor,
    CONSTRAINT fk_modelo FOREIGN KEY (idModelo)
		REFERENCES modelo,
    CONSTRAINT fk_cidade FOREIGN KEY (idCidade)
		REFERENCES cidade,
    CONSTRAINT chk_situacao_valida CHECK (situacao IN ('R', 'I', 'B'))
);

CREATE TABLE multa
(
  idMulta SERIAL PRIMARY KEY,
  renavam char(13) NOT NULL,
  idInfracao int NOT NULL,
  idCondutor int NOT NULL,
  dataInfracao date NOT NULL,
  dataVencimento date NOT NULL,
  dataPagamento date,
  valor numeric(5,2) NOT NULL,
  juros numeric(3,2) NOT NULL DEFAULT 0,
  valorFinal numeric(6,2) NOT NULL DEFAULT 0,
  pago char(1) NOT NULL DEFAULT 'N',
  CONSTRAINT fk_renavam FOREIGN KEY (renavam)
    REFERENCES veiculo,
  CONSTRAINT fk_infracao FOREIGN KEY (idInfracao)
    REFERENCES infracao,
  CONSTRAINT fk_condutor FOREIGN KEY (idCondutor)
    REFERENCES condutor,
  CONSTRAINT chk_pago_valido
    CHECK (pago IN ('S', 'N'))
);

-- TODO LICENCIAMENTO

-- TODO TRANSFERENCIA


