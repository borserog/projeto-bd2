-- Visão 1: ‘tabela’ que indique a relação de condutores com pontos na carteira (de acordo com as infrações cometidas)
-- o, agrupados por ano:
-- idCadastro/Nome do Condutor/categoria_cnh/ano da multa?????/total de pontos de infração

CREATE OR REPLACE VIEW PONTOSCONDUTOR AS (
    SELECT date_part('year', multa.datainfracao) AS ANOINFRACAO, condutor.idcadastro, condutor.nome,
           condutor.idcategoriacnh, COUNT(infracao.pontos) AS TOTALPONTOS
    FROM condutor
    INNER JOIN multa ON condutor.idcadastro = multa.idcondutor
    INNER JOIN infracao ON multa.idinfracao = infracao.idinfracao
    WHERE EXISTS(SELECT condutor.idcadastro
                    FROM condutor INNER JOIN multa
                    ON condutor.idcadastro = multa.idcondutor)
    GROUP BY  date_part('year', multa.datainfracao), condutor.idcadastro, condutor.nome, condutor.idcategoriacnh,infracao.pontos
);
--
-- Visão 2: ‘tabela’ que apresenta a relação dos veiculos/proprietários na base.
-- renavam/placa/Nome do proprietario/modelo/marca/cidade/estado/tipo

CREATE OR REPLACE VIEW VEICULOPROPRIETARIO AS (
    SELECT veiculo.renavam, veiculo.placa, condutor.nome as nomecondutor, modelo.denominacao, marca.nome as marca, cidade.nome as cidade, estado.nome as estado, tipo.descricao
    FROM veiculo
    INNER JOIN condutor ON veiculo.idproprietario = condutor.idcadastro
    INNER JOIN modelo on veiculo.idmodelo = modelo.idmodelo
    INNER JOIN marca on modelo.idmarca = marca.idmarca
    INNER JOIN tipo on modelo.idtipo = tipo.idtipo
    INNER JOIN cidade on veiculo.idcidade = cidade.idcidade
    INNER JOIN estado on cidade.uf = estado.uf
);

select * from VEICULOPROPRIETARIO;

--
-- Visão 3: ‘tabela’ que apresente o número de infrações e valores em multas registrados por ano e mês.

CREATE MATERIALIZED VIEW INFRACOESMULTAS AS (
    SELECT date_part('month', multa.datainfracao) as MES, date_part('year', multa.datainfracao) as ANO, COUNT(infracao.idinfracao) as QTDINFRACOES, SUM(infracao.valor) AS VALORINFRACOES
    FROM infracao
    INNER JOIN multa ON infracao.idinfracao = multa.idinfracao
    GROUP BY date_part('month', multa.datainfracao), date_part('year', multa.datainfracao)
);
