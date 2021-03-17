library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;

ENTITY display7Segmentos IS 
    PORT(clk					: IN STD_LOGIC; 
		rst						: IN STD_LOGIC; 
		a, b, c, d, e, f, g	: OUT STD_LOGIC);
END display7Segmentos;

ARCHITECTURE teste_display7Segmentos OF display7Segmentos IS 

	CONSTANT contador_max : natural := 50000000; -- 50Mhz
	SIGNAL op : STD_LOGIC;
	SIGNAL contador : STD_LOGIC_VECTOR(3 downto 0);

BEGIN 

PROCESS(clk) -- sensível ao relogio
	VARIABLE aContagem: natural range 0 to contador_max;
BEGIN
	IF (clk'EVENT AND clk ='1' AND aContagem<(contador_max/2)-1) THEN
		op <='1';
		aContagem := aContagem+1;
	ELSIF (clk'EVENT AND clk ='1' AND aContagem<contador_max-1) THEN
		op <='0';
		aContagem := aContagem+1;
	ELSIF (clk'EVENT AND clk ='1' AND aContagem<contador_max) THEN
		op <='1';
		aContagem := 0;
	END IF;
END PROCESS;

PROCESS (contador)
BEGIN
		IF (rst ='1') THEN
			contador<="0000";
		ELSIF(op'EVENT AND op='1')THEN 
			contador<=contador+1;
		END IF;
END PROCESS;	

PROCESS(contador,op)
VARIABLE segmentos : STD_LOGIC_VECTOR(0 TO 6); 
BEGIN
	IF (op'EVENT AND op = '1') THEN
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

END teste_display7Segmentos;