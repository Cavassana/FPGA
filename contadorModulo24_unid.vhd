library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

ENTITY contadorModulo24_unid IS
GENERIC( frequencia_relogio: NATURAL := 12500000);
			--modulo_contador 	: NATURAL := 5;
			--n_bits				: NATURAL := 4 ); -- 12.5Mhz 
	PORT(	clk							: IN STD_LOGIC;
			rst							: IN STD_LOGIC; -- RST ALTO
			habilita_contador 		: IN STD_LOGIC;
			flag_fim_contador			: OUT STD_LOGIC; -- informa à cel. seguinte para incrementar 
			saida_contador				: OUT STD_LOGIC_VECTOR(4-1 downto 0));
END contadorModulo24_unid;

ARCHITECTURE teste_contadorModulo24_unid OF contadorModulo24_unid IS 
TYPE estadoDisplay IS (	estagio_0, estagio_1, estagio_2, 
								estagio_3, estagio_4, estagio_5, 
								estagio_6, estagio_7, estagio_8, 
								estagio_9, estagio_10, estagio_11, 
								estagio_12, estagio_13, estagio_14, 
								estagio_15, estagio_16, estagio_17,
								estagio_18, estagio_19, estagio_20,
								estagio_21, estagio_22, estagio_23); 
SIGNAL estadoAtual : estadoDisplay; -- estado atual
SIGNAL checaEstado : estadoDisplay; -- comparador
SIGNAL ctrl_unid_h : UNSIGNED (1 DOWNTO 0) := "00";
SIGNAL pulso_int : STD_LOGIC;

COMPONENT divisorFrequencia
GENERIC (frequencia_osc : NATURAL); 
	PORT (clk	: IN STD_LOGIC;
			pulso	: OUT STD_LOGIC); 
END COMPONENT;
	
BEGIN
-- Divisor de frequencia
	div_f0:	divisorFrequencia 
		GENERIC MAP(frequencia_osc=>frequencia_relogio)
		PORT MAP(clk,pulso_int);		
		
-- MAQUINA DE ESTADO 24unid			   
	configura_estado:PROCESS (pulso_int, rst) -- sensivel a pulso_int
	VARIABLE contador : UNSIGNED (3  downto 0);
	BEGIN
		IF (pulso_int'EVENT AND pulso_int='1') THEN -- borda de subida do pulso 
			IF rst = '0' THEN estadoAtual <= estagio_0; -- reseta síncrono
			ELSIF (rst = '1' AND habilita_contador = '1') THEN
				CASE estadoAtual IS
					WHEN estagio_0 => estadoAtual <= estagio_1;	
					WHEN estagio_1 => estadoAtual <= estagio_2;
					WHEN estagio_2 => estadoAtual <= estagio_3;
					WHEN estagio_3 => estadoAtual <= estagio_4;
					WHEN estagio_4 => estadoAtual <= estagio_5;
					WHEN estagio_5 => estadoAtual <= estagio_6;
					WHEN estagio_6 => estadoAtual <= estagio_7;
					WHEN estagio_7 => estadoAtual <= estagio_8;
					WHEN estagio_8 => estadoAtual <= estagio_9;
					WHEN estagio_9 => estadoAtual <= estagio_10;
					WHEN estagio_10 => estadoAtual <= estagio_11;
					WHEN estagio_11 => estadoAtual <= estagio_12;
					WHEN estagio_12 => estadoAtual <= estagio_13;
					WHEN estagio_13 => estadoAtual <= estagio_14;
					WHEN estagio_14 => estadoAtual <= estagio_15;
					WHEN estagio_15 => estadoAtual <= estagio_16;
					WHEN estagio_16 => estadoAtual <= estagio_17;
					WHEN estagio_17 => estadoAtual <= estagio_18;
					WHEN estagio_18 => estadoAtual <= estagio_19;
					WHEN estagio_19 => estadoAtual <= estagio_0;
					WHEN estagio_20 => estadoAtual <= estagio_21;
					WHEN estagio_21 => estadoAtual <= estagio_22;
					WHEN estagio_22 => estadoAtual <= estagio_23;
					WHEN estagio_23 => estadoAtual <= estagio_0;				
					WHEN OTHERS => NULL;
				END CASE;	
			END IF;
		END IF; 
	END PROCESS configura_estado;
	
	checagem_unidade:PROCESS(estadoAtual, rst) -- sensivel a pulso_int
	BEGIN
		IF rst = '0' THEN ctrl_unid_h<= "00";
		END IF;
		IF (estadoAtual=estagio_9 AND ctrl_unid_h<"10" ) THEN 
			ctrl_unid_h <= ctrl_unid_h+1;
			flag_fim_contador <= '1'; 	-- habilita o incremento na prox. celula
		ELSIF (estadoAtual=estagio_3 AND ctrl_unid_h="11" ) THEN 
			flag_fim_contador <= '1'; 	-- habilita o incremento na prox. celula
			ctrl_unid_h <= "00";
		ELSE	
			flag_fim_contador <= '0'; -- desabilita inc prox. celula
		END IF;
	END PROCESS checagem_unidade;	
		
	WITH estadoAtual SELECT	
		saida_contador <=	"0000" WHEN estagio_0, 		
								"0001" WHEN estagio_1, 		 	
								"0010" WHEN estagio_2, 			
								"0011" WHEN estagio_3, 		
								"0100" WHEN estagio_4, 			
								"0101" WHEN estagio_5, 			
								"0110" WHEN estagio_6, 			
								"0111" WHEN estagio_7, 			
								"1000" WHEN estagio_8, 			
								"1001" WHEN estagio_9,
								"0000" WHEN estagio_10, 		
								"0001" WHEN estagio_11, 		 	
								"0010" WHEN estagio_12, 			
								"0011" WHEN estagio_13, 		
								"0100" WHEN estagio_14, 			
								"0101" WHEN estagio_15, 			
								"0110" WHEN estagio_16, 			
								"0111" WHEN estagio_17, 			
								"1000" WHEN estagio_18, 			
								"1001" WHEN estagio_19,
								"0000" WHEN estagio_20, 		
								"0001" WHEN estagio_21, 		 	
								"0010" WHEN estagio_22, 			
								"0011" WHEN estagio_23;	
							
END teste_contadorModulo24_unid;