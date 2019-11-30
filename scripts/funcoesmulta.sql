-- Quando um veículo tiver o lançamento de uma multa, 
-- inicialmente o condutor será o proprietário registrado para o veículo. 
-- Desde que a multa ainda não tenha sido paga, pode haver alteração do condutor

CREATE OR REPLACE FUNCTION checa_responsavel()
RETURNS TRIGGER
AS $$
BEGIN
	IF (TG_OP='INSERT') THEN
		UPDATE multa
		SET NEW.idcondutor = veiculo.idproprietario
		WHERE multa.idcondutor = veiculo.idproprietario;
		RETURN NEW;
		
	ELSIF (TG_OP='UPDATE' AND OLD.idcondutor <> NEW.idcondutor) THEN 
		IF (old.datapagamento is not null) THEN
			RAISE EXCEPTION 'OPERACAO INVALIDA, MULTA JÁ PAGA';
			RETURN OLD;
		END IF;
	END IF;
END; $$
LANGUAGE plpgsql;

CREATE TRIGGER responsavel_proprietario
BEFORE INSERT OR UPDATE ON multa
FOR EACH ROW
EXECUTE PROCEDURE checa_responsavel();

-- A data de vencimento da multa sempre será 40 dias depois da data de registro da infração. 
-- A data de vencimento não pode cair em um sábado, domingo ou feriado nacional;

CREATE FUNCTION seta_vencimento()
RETURNS TRIGGER
AS $$
DECLARE
	INTERVALO interval := '40 days'
	VENCIMENTO date := to_char(NEW.datainfracao+ INTERVALO, 'YYYY-MM-DD');
BEGIN
	IF (EXTRACT(DOW, VENCIMENTO) in (0,6)) THEN
		INTERVALO :='42 days'
		VENCIMENTO := to_char(NEW.datainfracao+ INTERVALO, 'YYYY-MM-DD');		
	END IF;
	
	UPDATE multa
	SET new.datavencimento = VENCIMENTO
	WHERE multa.idmulta = new.idmulta;
	RETURN NEW;
END; $$
LANGUAGE plpgsql;


CREATE TRIGGER data_vencimento
BEFORE INSERT ON multa
FOR EACH ROW
EXECUTE PROCEDURE seta_vencimento();
---- TODO: SABER SE É FERIADO NACIONAL -------

-- O valor da multa corresponde ao valor da infração identificada;

CREATE FUNCTION seta_valor()
RETURNS TRIGGER
AS $$
BEGIN
	UPDATE multa
	SET NEW.valor = infracao.valor
	WHERE multa.idInfracao = infracao.idInfracao;
END; $$
LANGUAGE plpgsql;

CREATE TRIGGER seta_valor
BEFORE INSERT ON multa
FOR EACH ROW
EXECUTE PROCEDURE seta_valor();

-- A data de pagamento da multa corresponde ao dia que efetivamente foi pago o boleto. 
-- Se a data de pagamento for maior do que a data de vencimento, adicione como juros 1% 
-- do valor da multa ao dia

CREATE OR REPLACE FUNCTION confere_juros()
RETURNS TRIGGER
AS $$
DECLARE
	DIFERENCA_DIAS integer := extract(days from age(NEW.DATAPAGAMENTO, OLD.DATAVENCIMENTO));
BEGIN
	IF (DIFERENCA_DIAS > 0) THEN
		UPDATE multa 
		SET NEW.juros = 0.01*DIFERENCA_DIAS
		WHERE NEW.IDMULTA = OLD.IDMULTA;
	END IF;
	RETURN NEW;
END; $$
LANGUAGE plpgsql;

CREATE TRIGGER confere_juros
BEFORE UPDATE ON multa
FOR EACH ROW
EXECUTE PROCEDURE confere_juros();
--------- TAMBÉM ATUALIZA O VALOR FINAL? ------------
