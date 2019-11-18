-- Cria uma sequencia serializada para a criação dos renavams

CREATE SEQUENCE renavam_sequence
MAXVALUE 9999999999
START 1000000000;

-- Altera coluna 'renavam', adicionando um valor default

ALTER TABLE veiculo ALTER COLUMN renavam SET DEFAULT nextval('renavam_sequence')::varchar(10);

-- Cria a trigger function que gera um renavam com o digito verificador

CREATE OR REPLACE FUNCTION set_renavam()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
	base int[] := array[3,2,9,8,7,6,5,4,3,2];
	renavam int[] := string_to_array(NEW.renavam, null);
	renavam_string char(11);
	res int = 0;
BEGIN
	FOR num IN 1..10 LOOP
		res := res + base[num]*renavam[num];
	END LOOP;
	res := res%11;

	renavam := array_append(renavam, res);
	renavam_string := array_to_string(renavam, '');
	NEW.renavam := renavam_string;
	
	return NEW;
END $$;

/*
  Cria o trigger para ser acionado antes de todo insert na tabela 'veiculo',
  executando a trigger function set_renavam()
*/

CREATE TRIGGER tg_set_renavam
BEFORE INSERT ON veiculo
FOR EACH ROW
EXECUTE PROCEDURE set_renavam()