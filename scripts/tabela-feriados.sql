CREATE OR REPLACE FUNCTION data_pascoa( ano INTEGER ) 
RETURNS DATE AS
$BODY$
DECLARE
    mes   INTEGER;
    dia   INTEGER;
    sec   INTEGER;
    I   INTEGER;
    J   INTEGER;
    K   INTEGER;
    L   INTEGER;
    N   INTEGER;
BEGIN
    sec := trunc( ano / 100 );
    N := ano - 19 * (trunc( ano / 19 ) );
    K := trunc( (sec - 17) / 25 );
    I := sec - trunc( sec / 4 ) - trunc( (sec - K) / 3) + 19 * N + 15;
    I := I - 30 * (trunc( I / 30 ) );
    I := I - ( trunc( I / 28 ) ) * (1 - ( trunc( 1 / 28 ) ) * ( trunc(29 / (I + 1) ) ) * ( trunc( (21 - N) / 11) ) );
    J := ano + trunc( ano / 4 ) + I + 2 - sec + trunc( sec / 4 );
    J := J - 7 * ( trunc( J / 7 ) );
    L := I - J;
    mes := 3 + trunc( (L + 40) / 44 );
    dia := L + 28 - 31 * ( trunc( mes / 4 ) );

    RETURN to_date( to_char( dia, '00') || to_char( mes, '00') || to_char( ano,'0000'), 'DDMMYYYY');
END;
$BODY$
LANGUAGE plpgsql;


SET datestyle TO dmy;
CREATE TABLE FeriadosNacionais (IdFeriado SERIAL PRIMARY KEY,
			DataFeriado DATE NOT NULL,
            Descricao VARCHAR(100) NOT NULL);

DO $$
DECLARE 
	data_pascoa DATE;
	dias_segunda_carnaval interval := '48 days';
	dias_terca_carnaval interval := '47 days';
	dias_sexta_santa interval := '2 days';
	dias_corpus_christi interval := '60 days';
BEGIN
	FOR ANO IN 2000..2025 LOOP
	data_pascoa := data_pascoa(ANO);
 	INSERT INTO feriadosnacionais (dataferiado, descricao) VALUES (('01/01/'||ano)::date, 'Confraternização Universal');
	INSERT INTO feriadosnacionais (dataferiado, descricao) VALUES (('21/04/'||ano)::date, 'Tiradentes');
	INSERT INTO feriadosnacionais (dataferiado, descricao) VALUES (('01/05/'||ano)::date, 'Dia do Trabalhador');
	INSERT INTO feriadosnacionais (dataferiado, descricao) VALUES (('07/09/'||ano)::date, 'Dia da Independência');
	INSERT INTO feriadosnacionais (dataferiado, descricao) VALUES (('12/10/'||ano)::date, 'Nossa Sra Aparecida');
	INSERT INTO feriadosnacionais (dataferiado, descricao) VALUES (('02/11/'||ano)::date, 'Finados');
	INSERT INTO feriadosnacionais (dataferiado, descricao) VALUES (('15/11/'||ano)::date, 'Proclamação da República');
	INSERT INTO feriadosnacionais (dataferiado, descricao) VALUES (('25/12/'||ano)::date, 'Natal');
	INSERT INTO feriadosnacionais (dataferiado, descricao) VALUES ((data_pascoa - dias_sexta_santa)::date, 'Paixão de Cristo');
	INSERT INTO feriadosnacionais (dataferiado, descricao) VALUES ((data_pascoa - dias_terca_carnaval)::date, 'Terça de Carnaval');
	INSERT INTO feriadosnacionais (dataferiado, descricao) VALUES ((data_pascoa - dias_segunda_carnaval)::date, 'Segunda de Carnaval');
	INSERT INTO feriadosnacionais (dataferiado, descricao) VALUES ((data_pascoa + dias_corpus_christi)::date, 'Corpus Christi');
	END LOOP;
END $$;

select * from feriadosnacionais;
