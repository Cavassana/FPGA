library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;

ENTITY decod7segSomaDez IS 
    PORT(entrada_display		: IN STD_LOGIC_VECTOR(5 downto 0);
			a, b, c, d, e, f, g 	: OUT STD_LOGIC);
END decod7segSomaUnid;

ARCHITECTURE teste_decod7segSomaDez OF decod7segSomaDez IS 

BEGIN 	

PROCESS(entrada_display)
	VARIABLE segmentos : STD_LOGIC_VECTOR(0 TO 6); 
BEGIN
	if entrada_display = "000000" THEN
		segmentos := "1111110";														  -- 0
	ELSIF entrada_display = "000001" OR entrada_display = "111111" THEN -- 1 OU -1
		segmentos := "1111110"; 
	ELSIF entrada_display = "000010" OR entrada_display = "111110" THEN -- 2 OU -2
		segmentos := "1111110"; 
	ELSIF entrada_display = "000011" OR entrada_display = "111101" THEN -- 3 OU -3
		segmentos := "1111110"; 
	ELSIF entrada_display = "000100" OR entrada_display = "111100" THEN -- 4 OU -4
		segmentos := "1111110"; 
	ELSIF entrada_display = "000101" OR entrada_display = "111011" THEN -- 5 OU -5
		segmentos := "1111110"; 
	ELSIF entrada_display = "000110" OR entrada_display = "111010" THEN -- 6 OU -6
		segmentos := "1111110"; 
	ELSIF entrada_display = "000111" OR entrada_display = "111001" THEN -- 7 OU -7
		segmentos := "1111110"; 
	ELSIF entrada_display = "001000" OR entrada_display = "111000" THEN -- 8 OU -8
		segmentos := "1111110";
	ELSIF entrada_display = "001001" OR entrada_display = "110111" THEN -- 9 OU -9
		segmentos := "1111110"; 
	ELSIF entrada_display = "001010" OR entrada_display = "110110" THEN -- 10 OU -10
		segmentos := "0110000"; 
	ELSIF entrada_display = "001011" OR entrada_display = "110101" THEN -- 11 OU -11
		segmentos := "0110000"; 
	ELSIF entrada_display = "001100" OR entrada_display = "110100" THEN -- 12 OU -12
		segmentos := "0110000"; 
	ELSIF entrada_display = "001101" OR entrada_display = "110011" THEN -- 13 OU -13
		segmentos := "0110000"; 
	ELSIF entrada_display = "001110" OR entrada_display = "110010" THEN -- 14 OU -14
		segmentos := "0110000"; 
	ELSE
		segmentos := "0000000"; -- null
	END IF;
	a <= segmentos(0);
	b <= segmentos(1);
	c <= segmentos(2);
	d <= segmentos(3);
	e <= segmentos(4);
	f <= segmentos(5);
    g <= segmentos(6);
	 
END PROCESS;

END teste_decod7segSomaDez;