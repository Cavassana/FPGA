library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;

ENTITY contadorBinario IS
	PORT(	clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			led : OUT STD_LOGIC_VECTOR(5 downto 0));
END contadorBinario;

ARCHITECTURE teste_contadorBinario OF contadorBinario IS 
	CONSTANT contador_max : natural := 50000000; -- 50Mhz
	SIGNAL op : STD_LOGIC;
	SIGNAL contadorLED : STD_LOGIC_VECTOR(5 downto 0);
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

PROCESS (contadorLED)
BEGIN
		IF (rst ='1') THEN
			contadorLED<="000000";
		ELSIF(op'EVENT AND op='1')THEN 
			contadorLED<=contadorLED+1;
		END IF;
END PROCESS;	
led <= contadorLED;

END teste_contadorBinario;