library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;

ENTITY decodificador7segmentosDezHora IS 
    PORT(entrada_display		: IN STD_LOGIC_VECTOR(5 downto 0);
			a, b, c, d, e, f, g : OUT STD_LOGIC);
END decodificador7segmentosDezHora;

ARCHITECTURE teste_decodificador7segmentosDezHora OF decodificador7segmentosDezHora IS 

BEGIN 	

PROCESS(entrada_display)
	VARIABLE segmentos : STD_LOGIC_VECTOR(0 TO 6); 
BEGIN
	CASE entrada_display IS 
		WHEN "000000" => segmentos := "1111110";--00
		WHEN "000001" => segmentos := "1111110";--01
		WHEN "000010" => segmentos := "1111110";--02
		WHEN "000011" => segmentos := "1111110";--03
		WHEN "000100" => segmentos := "1111110";--04
		WHEN "000101" => segmentos := "1111110";--05
		WHEN "000110" => segmentos := "1111110";--06
		WHEN "000111" => segmentos := "1111110";--07
		WHEN "001000" => segmentos := "1111110";--08
		WHEN "001001" => segmentos := "1111110";--09
		WHEN "001010" => segmentos := "0110000";--10
		WHEN "001011" => segmentos := "0110000";--11
		WHEN "001100" => segmentos := "0110000";--12
		WHEN "001101" => segmentos := "0110000";--13
		WHEN "001110" => segmentos := "0110000";--14
		WHEN "001111" => segmentos := "0110000";--15
		WHEN "010000" => segmentos := "0110000";--16
		WHEN "010001" => segmentos := "0110000";--17
		WHEN "010010" => segmentos := "0110000";--18
		WHEN "010011" => segmentos := "0110000";--19
		WHEN "010100" => segmentos := "1101101";--20
		WHEN "010101" => segmentos := "1101101";--21
		WHEN "010110" => segmentos := "1101101";--22
		WHEN "010111" => segmentos := "1101101";--23
		WHEN "011000" => segmentos := "1101101";--24
		WHEN "011001" => segmentos := "1101101";--25
		WHEN "011010" => segmentos := "1101101";--26
		WHEN "011011" => segmentos := "1101101";--27
		WHEN "011100" => segmentos := "1101101";--28
		WHEN "011101" => segmentos := "1101101";--29
		WHEN "011110" => segmentos := "1101101";--30
		WHEN "011111" => segmentos := "1101101";--31
		WHEN "100000" => segmentos := "1101101";--32
		WHEN "100001" => segmentos := "1101101";--33
		WHEN "100010" => segmentos := "1101101";--34
		WHEN "100011" => segmentos := "1101101";--35
		WHEN "100100" => segmentos := "1101101";--36
		WHEN "100101" => segmentos := "1101101";--37
		WHEN "100010" => segmentos := "1101101";--38
		WHEN "100011" => segmentos := "1101101";--39
		WHEN "101000" => segmentos := "1101101";--40
		WHEN "101001" => segmentos := "1101101";--41
		WHEN "101010" => segmentos := "1101101";--42
		WHEN "101011" => segmentos := "1101101";--43
		WHEN "101100" => segmentos := "1101101";--44
		WHEN "101101" => segmentos := "1101101";--45
		WHEN "101110" => segmentos := "1101101";--46
		WHEN "101111" => segmentos := "1101101";--47
		WHEN "110000" => segmentos := "1101101";--48
		WHEN "110001" => segmentos := "1101101";--49
		WHEN "110010" => segmentos := "1101101";--50
		WHEN "110011" => segmentos := "1101101";--51
		WHEN "110100" => segmentos := "1101101";--52
		WHEN "110101" => segmentos := "1101101";--53
		WHEN "110110" => segmentos := "1101101";--54
		WHEN "110111" => segmentos := "1101101";--55
		WHEN "111000" => segmentos := "1101101";--56
		WHEN "111001" => segmentos := "1101101";--57
		WHEN "111010" => segmentos := "1101101";--58
		WHEN "111011" => segmentos := "1101101";--59
		WHEN "111100" => segmentos := "1101101";--60
		WHEN "111101" => segmentos := "1101101";--61
		WHEN "111110" => segmentos := "1101101";--62
		WHEN "111111" => segmentos := "1101101";--63
		WHEN OTHERS => segmentos := "0000000";
	END CASE;
	a <= segmentos(0);
	b <= segmentos(1);
	c <= segmentos(2);
	d <= segmentos(3);
	e <= segmentos(4);
	f <= segmentos(5);
    g <= segmentos(6);
END PROCESS;

END teste_decodificador7segmentosDezHora;