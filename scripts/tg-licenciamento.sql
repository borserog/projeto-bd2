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
      data_venc_licenc := '28-03-' || current_year;
    WHEN '2' THEN
      data_venc_licenc := '30-04-' || current_year;
    WHEN '3' THEN
      data_venc_licenc := '30-05-' || current_year;
    WHEN '4' THEN
      data_venc_licenc := '29-06-' || current_year;
    WHEN '5' THEN
      data_venc_licenc := '31-07-' || current_year;
    WHEN '6' THEN
      data_venc_licenc := '31-08-' || current_year;
    WHEN '7' THEN
      data_venc_licenc := '28-09-' || current_year;
    WHEN '8' THEN
      data_venc_licenc := '31-10-' || current_year;
    WHEN '9' THEN
      data_venc_licenc := '30-11-' || current_year;
    WHEN '0' THEN
      data_venc_licenc := '30-12-' || current_year;
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
EXECUTE PROCEDURE set_licenciamento();

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
  cursorVeiculos CURSOR FOR SELECT renavam, placa FROM veiculo;
BEGIN
  FOR linha IN cursorVeiculos LOOP
    INSERT INTO licenciamento (ano, renavam, datavenc)
    VALUES (current_year, linha.renavam, set_data_venc_licenc(linha.placa))
  END LOOP;
END $$;