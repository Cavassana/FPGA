library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;

ENTITY relogioRev3 IS 
GENERIC( frequencia	: NATURAL := 250000; -- 50MHz
			n 				: INTEGER := 6); -- define no. de contadores
    PORT(clk						: IN STD_LOGIC; 
			rst						: IN STD_LOGIC; 
			habilita_contador		: IN STD_LOGIC; 
			overflow					: BUFFER STD_LOGIC;
			led						: OUT STD_LOGIC_VECTOR(1 TO 6);
			sa,sb,sc,sd,se,sf,sg	: OUT STD_LOGIC_VECTOR(5 downto 0));
END relogioRev3;

ARCHITECTURE teste_relogioRev3 OF relogioRev3 IS 

COMPONENT contadorModuloGenerico
GENERIC( frequencia_relogio: NATURAL; 
			modulo_contador 	: NATURAL;
			n_bits				: NATURAL);
	PORT (clk 					: IN STD_LOGIC; 
			rst					: IN STD_LOGIC;
			habilita_contador	: IN STD_LOGIC; 
			flag_fim_contador : OUT STD_LOGIC; 
			saida_contador		: OUT STD_LOGIC_VECTOR(3 downto 0));
END COMPONENT;

COMPONENT decodificador7segmentos
	PORT (entrada_display		: IN STD_LOGIC_VECTOR(3 downto 0);
			a, b, c, d, e, f, g 	: OUT STD_LOGIC);
END COMPONENT;
-- interligacao habilita_prox_contador->habilita_contador 
SIGNAL enable: STD_LOGIC_VECTOR( 1 TO n-1); 
SIGNAL saida_contador_u : STD_LOGIC_VECTOR(3 downto 0):= (OTHERS => '0');
SIGNAL saida_contador_d : STD_LOGIC_VECTOR(3 downto 0):= (OTHERS => '0');
SIGNAL saida_contador_c : STD_LOGIC_VECTOR(3 downto 0):= (OTHERS => '0');
SIGNAL saida_contador_m : STD_LOGIC_VECTOR(3 downto 0):= (OTHERS => '0');
SIGNAL saida_contador_dm : STD_LOGIC_VECTOR(3 downto 0):= (OTHERS => '0');
SIGNAL saida_contador_meg : STD_LOGIC_VECTOR(3 downto 0) := (OTHERS => '0');
-- SIGNAL check_enable : STD_LOGIC;
BEGIN 	
PROCESS(enable(1),enable(2),enable(3),enable(4),enable(5),overflow)
	BEGIN 
		IF habilita_contador='1' THEN 
			led(1) <= '1'; 
		ELSE led(1) <= '0';	
		END IF;
		IF enable(1)='1'  THEN 
			led(2) <= '1'; 
		ELSE led(2) <= '0';	
		END IF;
		IF enable(2)='1'  THEN 
			led(3) <= '1'; 
		ELSE led(3) <= '0';	
		END IF;
		IF enable(3)='1'  THEN 
			led(4) <= '1'; 
		ELSE led(4) <= '0';	
		END IF;
		IF enable(5)='1'  THEN 
			led(5) <= '1'; 
		ELSE led(5) <= '0';	
		END IF;
		IF overflow ='1'  THEN 
			led(6) <= '1'; 
		ELSE led(6) <= '0';	
		END IF;
END PROCESS;
-- Display
	-- 10^0
	u_c:	contadorModuloGenerico 
		GENERIC MAP(frequencia,9,4)
		PORT MAP(clk, rst, habilita_contador, enable(1), saida_contador_u);
	u_d:	decodificador7segmentos PORT MAP( saida_contador_u, sa(0), sb(0), sc(0), sd(0), se(0), sf(0), sg(0));
	-- 10^1
	d_c: 	contadorModuloGenerico 
		GENERIC MAP(frequencia,5,4)
		PORT MAP(clk, rst, enable(1), enable(2), saida_contador_d);
	d_d:	decodificador7segmentos 
		PORT MAP( saida_contador_d, sa(1), sb(1), sc(1), sd(1), se(1), sf(1), sg(1));	
	-- 10^2
	c_c:	contadorModuloGenerico
		GENERIC MAP(frequencia,9,4)
		PORT MAP(clk, rst, enable(2), enable(3), saida_contador_c);
	c_d: decodificador7segmentos 
		PORT MAP( saida_contador_c, sa(2), sb(2), sc(2), sd(2), se(2), sf(2), sg(2));			
	-- 10^3
	m_c:	contadorModuloGenerico 
		GENERIC MAP(frequencia,5,4)
		PORT MAP(clk, rst, enable(3), enable(4), saida_contador_m);
	m_d: decodificador7segmentos 
		PORT MAP( saida_contador_m, sa(3), sb(3), sc(3), sd(3), se(3), sf(3), sg(3));
	-- 10^4
	dm_c:	contadorModuloGenericoComDivHora 
		GENERIC MAP(frequencia,9,4)
		PORT MAP(clk, rst, habilita_contador, enable(5), saida_contador_dm);
	dm_d: decodificador7segmentos 
		PORT MAP( saida_contador_m, sa(4), sb(4), sc(4), sd(4), se(4), sf(4), sg(4));
	-- 10^5
	meg_c: contadorModuloGenericoComDivHora 
		GENERIC MAP(frequencia,2,4)
		PORT MAP(clk, rst, enable(5), overflow, saida_contador_meg);
	meg_d: decodificador7segmentos 
		PORT MAP( saida_contador_meg, sa(5), sb(5), sc(5), sd(5), se(5), sf(5), sg(5));
			
END teste_relogioRev3;