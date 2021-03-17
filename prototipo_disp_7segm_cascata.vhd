library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;

ENTITY display7Segmentos IS 
    PORT(clk								: IN STD_LOGIC; 
			rst								: IN STD_LOGIC; 
			a0, b0, c0, d0, e0, f0, g0	: OUT STD_LOGIC;
			a1, b1, c1, d1, e1, f1, g1	: OUT STD_LOGIC;
			a2, b2, c2, d2, e2, f2, g2	: OUT STD_LOGIC;
			a3, b3, c3, d3, e3, f3, g3	: OUT STD_LOGIC);
END display7Segmentos;

ARCHITECTURE teste_display7Segmentos OF display7Segmentos IS 

	CONSTANT contador_max : natural := 50000000; -- 50Mhz
	SIGNAL op : STD_LOGIC;
	SIGNAL contador0 : STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL contador1 : STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL contador2 : STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL contador3 : STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL incrementa1 : STD_LOGIC;
	SIGNAL incrementa2 : STD_LOGIC;
	SIGNAL incrementa3 : STD_LOGIC;
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

PROCESS (op,rst) -- XXX0
	VARIABLE contagemSegundos: natural range 0 to 60;
BEGIN
		IF (rst ='1' OR (contagemSegundos = '60' AND contador0 = "1010") THEN
			contador0 <= "0000";
		ELSIF(op'EVENT AND op='1')THEN 
			contagemSegundos <= contagemSegundos+1;
		END IF;
		IF (contagemSegundos = '60') THEN
			contador0 <= contador0+1;
			incrementa1 <= '1';
		END IF;
END PROCESS;	

PROCESS (op,rst,incrementa1) -- XX0X
BEGIN
		IF (rst ='1' OR contador1= "0110") THEN
			contador1<="0000";
		ELSIF(op'EVENT AND op='1' AND incrementa1 = '1')THEN 
			contador1 <= contador1+1;
			incrementa1 <= '0'; 
		END IF;
		IF (contador1= "0110") THEN
			incrementa2 <= '1';
		END IF;
END PROCESS;

PROCESS (op,rst,incrementa2) -- X0XX
BEGIN
		IF (rst ='1' OR (contador2 = "1010" AND (contador3 = "00" OR contador3 ="01")) OR (contador2 = "0101" AND contador3 = "10")) THEN
			contador2 <= "0000";
		ELSIF(op'EVENT AND op='1' AND incrementa2 = '1')THEN 
			contador2 <= contador2+1;
			incrementa2 <= '0'; 
		END IF;
		IF (contador2 = "1010" AND (contador3 = "00" OR contador3 ="01")) THEN
			incrementa3 <= '1';
		END IF;
		IF (contador2 = "0101" AND (contador3 = "10")) THEN
			incrementa3 <= '1';
		END IF;
END PROCESS;

PROCESS (op,rst,incrementa3) -- 0XXX
BEGIN
		IF (rst ='1' OR contador3 = "0011") THEN
			contador3 <= "0000";
		ELSIF(op'EVENT AND op='1' AND incrementa3 = '1')THEN 
			contador3 <= contador3+1;
			incrementa3 <= '0'; 
		END IF;
END PROCESS;

PROCESS(contador0) -- XXX0
VARIABLE segmentos : STD_LOGIC_VECTOR(0 TO 6); 
BEGIN
	IF (op = '1') THEN
        CASE contador0 IS 
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
        a0 <= segmentos(0);
        b0 <= segmentos(1);
        c0 <= segmentos(2);
        d0 <= segmentos(3);
        e0 <= segmentos(4);
        f0 <= segmentos(5);
        g0 <= segmentos(6);
	END IF;
END PROCESS;

PROCESS(contador1) -- XX0X
VARIABLE segmentos : STD_LOGIC_VECTOR(0 TO 6); 
BEGIN
	IF (op = '1') THEN
        CASE contador1 IS 
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
        a1 <= segmentos(0);
        b1 <= segmentos(1);
        c1 <= segmentos(2);
        d1 <= segmentos(3);
        e1 <= segmentos(4);
        f1 <= segmentos(5);
        g1 <= segmentos(6);
	END IF;
END PROCESS;

PROCESS(contador2) -- X0XX
VARIABLE segmentos : STD_LOGIC_VECTOR(0 TO 6); 
BEGIN
	IF (op = '1') THEN
        CASE contador2 IS 
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
        a2 <= segmentos(0);
        b2 <= segmentos(1);
        c2 <= segmentos(2);
        d2 <= segmentos(3);
        e2 <= segmentos(4);
        f2 <= segmentos(5);
        g2 <= segmentos(6);
	END IF;
END PROCESS;

PROCESS(contador3) -- 0XXX
VARIABLE segmentos : STD_LOGIC_VECTOR(0 TO 6); 
BEGIN
	IF (op = '1') THEN
        CASE contador3 IS 
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
        a3 <= segmentos(0);
        b3 <= segmentos(1);
        c3 <= segmentos(2);
        d3 <= segmentos(3);
        e3 <= segmentos(4);
        f3 <= segmentos(5);
        g3 <= segmentos(6);
	END IF;
END PROCESS;

END teste_display7Segmentos;