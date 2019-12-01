-- Cria função para gerar data de vencimento do licenciamento

CREATE OR REPLACE FUNCTION set_data_venc_licenc(placa char(7))
RETURNS date
LANGUAGE plpgsql
AS $$
DECLARE
  current_year int := date_part('year', CURRENT_DATE);
  placa_array char[] := string_to_array(placa, null);
  data_venc_licenc date;
BEGIN
  CASE placa_array[6]
    WHEN '1' THEN
      data_venc_licenc := '03-28-' || current_year;
    WHEN '2' THEN
      data_venc_licenc := '04-30-' || current_year;
    WHEN '3' THEN
      data_venc_licenc := '05-30-' || current_year;
    WHEN '4' THEN
      data_venc_licenc := '06-29-' || current_year;
    WHEN '5' THEN
      data_venc_licenc := '07-31-' || current_year;
    WHEN '6' THEN
      data_venc_licenc := '08-31-' || current_year;
    WHEN '7' THEN
      data_venc_licenc := '09-28-' || current_year;
    WHEN '8' THEN
      data_venc_licenc := '10-31-' || current_year;
    WHEN '9' THEN
      data_venc_licenc := '11-30-' || current_year;
    WHEN '0' THEN
      data_venc_licenc := '12-30-' || current_year;
  END CASE;

  RETURN data_venc_licenc::date;
END $$;

/* 
  Criação da trigger function que adiciona um licenciamento
  quando adicionar novo veiculo
*/

CREATE OR REPLACE FUNCTION set_licenciamento()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
  current_year int := date_part('year', CURRENT_DATE);
BEGIN
  INSERT INTO licenciamento (ano, renavam, datavenc, pago) 
  VALUES (current_year, NEW.renavam, set_data_venc_licenc(NEW.placa), 'S');

	return NEW;
END $$;

CREATE TRIGGER tg_set_licenciamento
AFTER INSERT ON veiculo
FOR EACH ROW
EXECUTE PROCEDURE set_licenciamento()

-- ======================================== --

-- Procedure que cria novos licenciamentos para todos os veículos na tabela (teste)

/*
  Quando executar essa procedure?
  Seria melhor gerar um novo licenciamento logo após o pagamento do atual?
  Como modificar a situação do veículo caso o condutor não pague até o vencimento?
*/

CREATE OR REPLACE PROCEDURE gerar_novos_licenc()
LANGUAGE plpgsql
AS $$
DECLARE
  current_year int := date_part('year', CURRENT_DATE);
  cursorVeiculos CURSOR FOR SELECT renavam, placa FROM veiculos;
BEGIN
  FOR linha IN cursorVeiculos LOOP
    INSERT INTO licenciamento (ano, renavam, datavenc)
    VALUES (current_year, linha.renavam, set_data_venc_licenc(linha.placa))
  END LOOP;
END $$;