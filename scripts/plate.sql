CREATE EXTENSION plpythonu;

CREATE OR REPLACE FUNCTION random_plate() RETURNS varchar
AS $$
import string
	import random
	DIGITS = string.digits
	ALPHABET = string.ascii_uppercase
	PLATE_LEN = 7
	
	def gen_plate():
		plate_result = ""
		turn = ALPHABET
		for i in range(PLATE_LEN):
			if i == 3:
				turn = DIGITS
			plate_result += random.choice(turn)
		return plate_result
	
	def check_plate_equals():
		cursor_list = plpy.execute("select placa from veiculo")
		while(True):
			plate = gen_plate()
			if plate not in cursor_list:
				return plate
	
	return check_plate_equals()
$$ LANGUAGE plpythonu;

insert into veiculo(placa,ano,idCategoria,idProprietario,idModelo,idCidade,dataCompra,dataAquisicao,valor,situacao) values(random_plate(),2018,1,1,1,1,'19/11/2019','19/11/2019',3000,'R')