-- Cria a trigger function que verifica se a CNH do condutor será suspensa

CREATE OR REPLACE FUNCTION verificar_suspensao()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  pontos int;
BEGIN
  SELECT INTO pontos totalpontos FROM pontoscondutor WHERE idcadastro = NEW.idcondutor;
  IF ((NEW.idinfracao IN (16, 24, 27, 28)) OR (pontos >= 20)) THEN
    UPDATE condutor
    SET situacaocnh = 'S'
    WHERE idcadastro = NEW.idcondutor;
  END IF;
  RETURN NEW;
END $$;

-- Cria o trigger que é acionado "após" a inserção da multa no banco

CREATE TRIGGER tg_verificar_suspensao
AFTER INSERT ON multa
FOR EACH ROW
EXECUTE PROCEDURE verificar_suspensao()