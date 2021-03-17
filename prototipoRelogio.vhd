library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;

ENTITY prototipoRelogio IS 
	GENERIC( n : INTEGER := 3); -- define no. de contadores
    PORT(clk, rst				: IN STD_LOGIC; 
		habilita_contador		: IN STD_LOGIC; 
		habilita_load_bcd		: IN STD_LOGIC;	-- ENTRADA PARALELA	
		entrada_paralela		: IN STD_LOGIC_VECTOR(3 downto 0);
		overflow				: OUT STD_LOGIC;
		sa,sb,sc,sd,se,sf,sg	: OUT STD_LOGIC);
END prototipoRelogio;

ARCHITECTURE teste_prototipoRelogio OF prototipoRelogio IS 

COMPONENT contadorMOD6
	PORT (	clk, habilita_contador, rst	: IN STD_LOGIC; 
			habilita_prox_contador 		: OUT STD_LOGIC; 
			saida_contador				: OUT STD_LOGIC_VECTOR(5 downto 0));
END COMPONENT;

COMPONENT decodificador7segmentos
	PORT (	clk, habilita_load_bcd	: IN STD_LOGIC; 
			entrada_paralela 		: IN STD_LOGIC_VECTOR(3 downto 0); 
			entrada_serial	 		: IN STD_LOGIC_VECTOR(3 downto 0);
			a, b, c, d, e, f, g 	: OUT STD_LOGIC);
END COMPONENT;

-- interligacao habilita_prox_contador->habilita_contador 
SIGNAL enable: BIT_VECTOR( 1 TO n-1); 

BEGIN 
	-- menos significativo - unidades
	unidades:	celula_contador PORT MAP(clk, rst, habilita_contador, enable(1), saida_contador);
				decodificador7segmentos PORT MAP(clk, habilita_load_bcd, entrada_paralela, saida_contador, a, b, c, d, e, f, g);
	-- 2-celula_contador - dezenas
	dezenas: 	celula_contador PORT MAP(clk, rst, enable(1), enable(2), saida_contador);
				decodificador7segmentos PORT MAP(clk, habilita_load_bcd, entrada_paralela, saida_contador, a, b, c, d, e, f, g);
	-- mais significativo - centenas
	centenas: 	celula_contador PORT MAP(clk, rst, enable(2), overflow, saida_contador);
				decodificador7segmentos PORT MAP(clk, habilita_load_bcd, entrada_paralela, saida_contador, a, b, c, d, e, f, g);
				
END teste_prototipoRelogio;

