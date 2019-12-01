CREATE OR REPLACE FUNCTION gerar_placa()
RETURNS varchar(7) AS $$
    DECLARE
        digits text[] := '[0:9]={0,1,2,3,4,5,6,7,8,9}';
        chars text[] := '[0:25]={A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z}';
        result varchar[] := '{}';
        rand_int int;
        DIGIT_LENGTH integer := 4;
        CHAR_LENGTH integer := 3;
    begin

            FOR char_element in 1..CHAR_LENGTH LOOP
                rand_int := random()*25::int;
                result := array_append(result, chars[rand_int]::varchar);
            END LOOP;

            FOR digit_element in 1..DIGIT_LENGTH LOOP
                rand_int := random()*9::int;
                result := array_append(result, digits[rand_int]::varchar);
            END LOOP;

            RETURN array_to_string(result, '');
    end;
$$ LANGUAGE plpgsql;