----------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION seta_responsavel()
RETURNS TRIGGER
AS $$
BEGIN
	IF (TG_OP='INSERT') THEN
		NEW.idcondutor := (SELECT veiculo.idproprietario from veiculo WHERE new.renavam = veiculo.renavam);
		RETURN NEW;
		
	ELSIF (TG_OP='UPDATE' AND OLD.idcondutor <> NEW.idcondutor) THEN 
		IF (old.datapagamento is not null) THEN
		    RETURN OLD.idCondutor;
			RAISE EXCEPTION 'OPERACAO INVALIDA, MULTA JÁ PAGA';
		END IF;
	END IF;

	RETURN NEW;
END; $$
LANGUAGE plpgsql;

CREATE TRIGGER seta_condutor
BEFORE INSERT OR UPDATE ON multa
FOR EACH ROW
EXECUTE PROCEDURE seta_responsavel();


------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION is_dia_util(data_ date)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
BEGIN
	IF (EXTRACT(DOW FROM data_) in (0,6) OR EXISTS (SELECT dataferiado from feriadosNacionais WHERE dataferiado = data_)) THEN
		RETURN FALSE;
	ELSE
		RETURN TRUE;
	END IF;
END; $$;

CREATE OR REPLACE FUNCTION seta_data_vencimento()
RETURNS TRIGGER
AS $$
DECLARE
	INTERVALO interval := '40 days';
	VENCIMENTO date := (NEW.datainfracao+ INTERVALO)::date;
BEGIN
	IF (NOT is_dia_util(vencimento)) THEN
		WHILE (NOT is_dia_util(vencimento)) LOOP 
		INTERVALO := '1 day';
		VENCIMENTO := (NEW.datainfracao+ INTERVALO)::date;
		END LOOP;
	END IF;
	NEW.dataVencimento := vencimento;
	RETURN NEW;
END; $$
LANGUAGE plpgsql;

CREATE TRIGGER seta_data_vencimento
BEFORE INSERT ON multa
FOR EACH ROW
EXECUTE PROCEDURE seta_data_vencimento();

-----------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION seta_valor()
RETURNS TRIGGER
AS $$
BEGIN
	NEW.valor := (SELECT infracao.valor FROM INFRACAO WHERE NEW.idInfracao = infracao.idInfracao);
	RETURN NEW;
END; $$
LANGUAGE plpgsql;

CREATE TRIGGER seta_valor
BEFORE INSERT ON multa
FOR EACH ROW
EXECUTE PROCEDURE seta_valor();
------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION confere_juros()
RETURNS TRIGGER
AS $$
DECLARE
	DIFERENCA_DIAS integer := date_part('day', NEW.DATAPAGAMENTO::timestamp - OLD.DATAVENCIMENTO::timestamp);
BEGIN
	IF (DIFERENCA_DIAS > 0) THEN
		NEW.juros = 0.01*DIFERENCA_DIAS;
		NEW.valorfinal = NEW.valor + (NEW.juros * NEW.valor);
	END IF;
	RETURN NEW;
END; $$
LANGUAGE plpgsql;

CREATE TRIGGER confere_juros
AFTER UPDATE ON multa
FOR EACH ROW
EXECUTE PROCEDURE confere_juros();
-------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION muda_pago()
RETURNS TRIGGER
AS $$
BEGIN
	IF (NEW.dataPagamento <> OLD.dataPagamento) THEN
		NEW.pago := 'S';
	END IF;
	RETURN NEW;
END; $$
LANGUAGE plpgsql;

CREATE TRIGGER muda_pago
BEFORE UPDATE ON multa
FOR EACH ROW
EXECUTE PROCEDURE muda_pago();
-------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION atualiza_valor_final()
RETURNS TRIGGER
AS $$
BEGIN
	NEW.valorFinal := NEW.valor + (NEW.juros * NEW.valor);
	RETURN NEW;
END; $$
LANGUAGE plpgsql;

CREATE TRIGGER atualiza_valor_final
AFTER INSERT OR UPDATE ON multa
FOR EACH ROW
EXECUTE PROCEDURE atualiza_valor_final();

drop trigger atualiza_valor_final on multa;

