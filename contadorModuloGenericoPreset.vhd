library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

ENTITY contadorModuloGenericoPreset IS
GENERIC( frequencia_relogio		: NATURAL := 12500000; -- 12.5Mhz 
			n_bits						: NATURAL := 4);
	PORT(	clk							: IN STD_LOGIC;
			rst							: IN STD_LOGIC; -- RST ALTO
			habilita_contador 		: IN STD_LOGIC;
			preset			 			: IN STD_LOGIC; -- controla unidade hora
			flag_fim_contador			: OUT STD_LOGIC; -- informa à cel. seguinte para incrementar 
			saida_contador				: OUT STD_LOGIC_VECTOR(n_bits-1 downto 0));
END contadorModuloGenericoPreset;

ARCHITECTURE teste_contadorModuloGenericoPreset OF contadorModuloGenericoPreset IS 
COMPONENT divisorFrequencia
GENERIC (frequencia_osc : NATURAL); 
	PORT (clk	: IN STD_LOGIC;
			pulso	: OUT STD_LOGIC); 
END COMPONENT;
	SIGNAL pulso_int : STD_LOGIC;
BEGIN
-- Divisor de frequencia
	div_f0:	divisorFrequencia 
		GENERIC MAP(frequencia_osc=>frequencia_relogio)
		PORT MAP(clk,pulso_int);		
-- Contador 
contador :PROCESS (pulso_int, rst) -- lista de sensibilidade
	VARIABLE contador : UNSIGNED (n_bits-1  downto 0);
	BEGIN
		IF preset = '0' THEN
			IF ((contador = 9)AND (habilita_contador='1')) THEN flag_fim_contador	 <= '1'; 	-- habilita o incremento na prox. celula
			ELSE flag_fim_contador	 <= '0'; -- desabilita inc prox. celula
			END IF;
			IF (pulso_int'EVENT AND pulso_int='1') THEN -- borda de subida do pulso 
				IF rst = '0' THEN contador := "0000"; -- reseta síncrono
				ELSIF (rst = '1' AND habilita_contador = '1') THEN
					IF contador = 9 THEN contador := "0000"; -- retorna a zero
					ELSIF contador < 9 THEN contador := contador +1; -- incrementa
					END IF;
				END IF;
			END IF; 
		ELSE 	
			IF ((contador = 2)AND (habilita_contador='1')) THEN flag_fim_contador	 <= '1'; 	-- habilita o incremento na prox. celula
			ELSE flag_fim_contador	 <= '0'; -- desabilita inc prox. celula
			END IF;
			IF (pulso_int'EVENT AND pulso_int='1') THEN -- borda de subida do pulso 
				IF rst = '0' THEN contador := "0000"; -- reseta síncrono
				ELSIF (rst = '1' AND habilita_contador = '1') THEN
					IF contador = 2 THEN contador := "0000"; -- retorna a zero
					ELSIF contador < 2 THEN contador := contador +1; -- incrementa
					END IF;
				END IF;
			END IF; 
		END IF;
		saida_contador <= STD_LOGIC_VECTOR(contador);
	END PROCESS contador;
END teste_contadorModuloGenericoPreset;