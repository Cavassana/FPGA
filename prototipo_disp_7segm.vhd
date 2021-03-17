library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;

ENTITY decodificador7segmentos IS 
    PORT(habilita_load_paralelo	: IN STD_LOGIC;		
		entrada_paralela		: IN STD_LOGIC_VECTOR(3 downto 0);
		entrada_serial			: IN STD_LOGIC_VECTOR(3 downto 0);
		a, b, c, d, e, f, g 	: OUT STD_LOGIC);
END display7Segmentos;

ARCHITECTURE teste_decodificador7segmentos OF decodificador7segmentos IS 

BEGIN 	

PROCESS(entrada_serial)
VARIABLE segmentos : STD_LOGIC_VECTOR(0 TO 6); 
BEGIN
	IF habilita_load_bcd = '0' THEN
		CASE contador IS 
			WHEN "0000" => segmentos := "1111110";
			WHEN "0001" => segmentos := "0110000";
			WHEN "0010" => segmentos := "1101101";
			WHEN "0011" => segmentos := "1111001";
			WHEN "0100" => segmentos := "0110011";
			WHEN "0101" => segmentos := "1011011";
			WHEN "0110" => segmentos := "1011111";
			WHEN "0111" => segmentos := "1110000";
			WHEN "1000" => segmentos := "1111111";
			WHEN "1001" => segmentos := "1110011";
			WHEN OTHERS => segmentos := "0000000";
		END CASE;
		a <= segmentos(0);
		b <= segmentos(1);
		c <= segmentos(2);
		d <= segmentos(3);
		e <= segmentos(4);
		f <= segmentos(5);
        g <= segmentos(6);
	END IF;
END PROCESS;

PROCESS(habilita_load_bcd)	
BEGIN
    IF 	habilita_load_bcd = '1' THEN 
		display <= bcd;
	 END IF;
END PROCESS;

END teste_decodificador7segmentos;