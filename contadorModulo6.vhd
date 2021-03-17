library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

ENTITY contadorMOD6 IS
	PORT(	clk, rst				: IN STD_LOGIC;
			habilita_contador 		: IN STD_LOGIC;
			habilita_prox_contador  : OUT STD_LOGIC; -- informa à cel. seguinte para incrementar 
			saida_contador			: OUT STD_LOGIC_VECTOR(5 downto 0));
END contadorMOD6;

ARCHITECTURE teste_contadorMOD6 OF contadorMOD6 IS 
	CONSTANT contador_max : NATURAL := 50000000; -- 50Mhz
	SIGNAL pulso : STD_LOGIC;
BEGIN

-- Divisor de frequencia
PROCESS(clk) 
	VARIABLE aContagem: natural range 0 to contador_max;
BEGIN
	IF (clk'EVENT AND clk ='1' AND aContagem<(contador_max/2)-1) THEN
		pulso <='1';
		aContagem := aContagem+1;
	ELSIF (clk'EVENT AND clk ='1' AND aContagem<contador_max-1) THEN
		pulso <='0';
		aContagem := aContagem+1;
	ELSIF (clk'EVENT AND clk ='1' AND aContagem<contador_max) THEN
		pulso <='1';
		aContagem := 0;
	END IF;
END PROCESS; -- 

-- Contador 
contador :PROCESS (pulso, habilita_contador, rst) -- lista de sensibilidade
	VARIABLE contador : UNSIGNED (5 downto 0));
	BEGIN
		IF ((contador = 9)AND (habilita_contador='1')) THEN habilita_prox_contador <= '1'; 	-- habilita o incremento na prox. celula
		ELSE habilita_prox_contador <= '0'; -- desabilita inc prox. celula
		END IF;
		IF (pulso'EVENT AND pulso='1')) THEN -- borda de subida do pulso 
			IF rst = '0' THEN contador := 0; -- reseta síncrono
			ELSIF (rst = '1' AND habilita_contador = '1') THEN
				IF contador = 9  THEN contador := 0; -- retorna a zero
				ELSIF contador < 9 THEN contador := contador +1; -- incrementa
				END IF;
			END IF;
		END IF; 
		saida_contador <= std_logic_vector(contador);
	END PROCESS contador;

END teste_contadorMOD6;

-- GUARDEI AQUI

-- limpa ultimo valor 
PROCESS(saida_contador_u,saida_contador_d,saida_contador_c,saida_contador_m,saida_contador_dm, saida_contador_meg)
	BEGIN 
		IF habilita_paralelo = '0' THEN
			mem_saida_contador_u 	<= "00000";
			mem_saida_contador_d 	<= "00000";
			mem_saida_contador_c	 	<= "00000";
			mem_saida_contador_m 	<= "00000";
			mem_saida_contador_dm 	<= "00000";
			mem_saida_contador_meg 	<= "00000";
		END IF;
END PROCESS;
