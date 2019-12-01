
-- 6.4 TRANSFERÊNCIA DE PROPRIEDADE
update veiculo set idProprietario = 60, dataAquisicao = CURRENT_DATE where placa = 'STV6224';
update veiculo set idProprietario = 40, dataAquisicao = CURRENT_DATE where placa = 'STV6224';
update veiculo set idProprietario = 80, dataAquisicao = CURRENT_DATE where placa = 'STV6224';


-- 7.1 FUNÇÃO QUE RETORNA TABELA
select * from historico_renavam('10000006162');