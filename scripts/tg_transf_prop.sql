-- Trigger function
CREATE OR REPLACE FUNCTION transf_propriedade() RETURNS TRIGGER
AS $$
BEGIN
	INSERT INTO tranferencia (renavam,idProprietario,dataCompra,dataVenda) 
	VALUES(OLD.renavam, OLD.idProprietario, OLD.dataCompra, CURRENT_DATE);
	RETURN OLD;
END $$
LANGUAGE plpgsql;

-- Trigger

CREATE TRIGGER mudanca_prop
AFTER UPDATE
ON veiculo
FOR EACH ROW
EXECUTE PROCEDURE transf_propriedade();

--UPDATE DE TESTE
update veiculo set idProprietario = 60, dataAquisicao = CURRENT_DATE where placa = 'WFY4564';