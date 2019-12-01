
-- 6.4 TRANSFERÊNCIA DE PROPRIEDADE
update veiculo set idProprietario = 60, dataAquisicao = CURRENT_DATE where placa = 'STV6224';
update veiculo set idProprietario = 40, dataAquisicao = CURRENT_DATE where placa = 'STV6224';
update veiculo set idProprietario = 80, dataAquisicao = CURRENT_DATE where placa = 'STV6224';


-- 7.1 FUNÇÃO QUE RETORNA TABELA
select * from historico_renavam('10000006162');


insert into multa (renavam, idinfracao, idcondutor, datainfracao)
values('10000006849', 33, 14, current_date);

insert into multa (renavam, idinfracao, datainfracao)
values('10000006916', 33, current_date);