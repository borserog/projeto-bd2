CREATE OR REPLACE FUNCTION historico_renavam(rena CHAR) 
RETURNS TABLE(renavam CHAR, modelo VARCHAR, marca VARCHAR, 
			  ano INTEGER, nome_prop VARCHAR, dataCompra DATE, dataVenda DATE)
AS $$
BEGIN
	RETURN QUERY
		SELECT trans.renavam, mode.denominacao, marca.nome, vei.ano,
		con.nome, trans.dataCompra, trans.dataVenda
		FROM tranferencia trans JOIN veiculo vei ON trans.renavam = vei.renavam
		JOIN modelo mode ON vei.idModelo = mode.idModelo
		JOIN marca ON mode.idMarca = marca.idMarca
		JOIN condutor con ON trans.idProprietario = con.idCadastro
		WHERE trans.renavam = rena
		ORDER BY dataVenda ASC;
	END; $$
LANGUAGE plpgsql;
select * from veiculo

--TESTE
select * from historico_renavam('10000000064');