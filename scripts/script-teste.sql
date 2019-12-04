
-- 6.4 TRANSFERÊNCIA DE PROPRIEDADE
update veiculo set idProprietario = 60, dataAquisicao = CURRENT_DATE where placa = 'HQY3110';
update veiculo set idProprietario = 40, dataAquisicao = CURRENT_DATE where placa = 'HQY3110';
update veiculo set idProprietario = 80, dataAquisicao = CURRENT_DATE where placa = 'HQY3110';
update veiculo set idProprietario = 60, dataAquisicao = CURRENT_DATE where placa = 'ZPL4832';
update veiculo set idProprietario = 40, dataAquisicao = CURRENT_DATE where placa = 'ZPL4832';
update veiculo set idProprietario = 80, dataAquisicao = CURRENT_DATE where placa = 'ZPL4832';


-- 7.1 FUNÇÃO QUE RETORNA TABELA
select * from historico_renavam('10000001502');

-- Insere proprietário do veículo como responsável pela multa;
insert into multa (renavam, idinfracao, datainfracao)
values('10000000273', 33, current_date);

insert into multa (renavam, idinfracao, datainfracao)
values('10000000273', 67, current_date);

insert into multa (renavam, idinfracao, datainfracao)
values('10000000326', 24, current_date);

insert into multa (renavam, idinfracao, datainfracao)
values('10000000091', 90, current_date);

insert into multa (renavam, idinfracao, datainfracao)
values('10000001409', 24, current_date);

insert into multa (renavam, idinfracao, datainfracao)
values('10000000376', 29, current_date);



-- Atualização do valor final da multa
UPDATE multa
set datapagamento = '11/04/2020'
where idmulta = 6;

-- Mudança do condutor responsável
UPDATE multa
set idcondutor = 44
where idcondutor = 24;

--

REFRESH MATERIALIZED VIEW infracoesmultas;

