library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;

ENTITY Romualdo4 IS -- maq_est2 MEALY
    PORT (	ck				: IN STD_LOGIC;
				entrada_N 	: IN INTEGER RANGE 0 TO 7; 		-- entrada N			
				iniciar		: IN STD_LOGIC; 								-- iniciar='1' => q="00"
				teste_z		: OUT STD_LOGIC; 	
				teste_regA	: OUT INTEGER RANGE 0 to 9999;
				teste_regB	: OUT INTEGER RANGE 0 to 9999;
				teste_i_m_a0: OUT INTEGER RANGE 0 to 9999;
				teste_i_m_a1: OUT INTEGER RANGE 0 to 9999;
				teste_i_m_a2: OUT INTEGER RANGE 0 to 9999;
				teste_i_m_b0: OUT INTEGER RANGE 0 to 9999;
				teste_i_m_b1: OUT INTEGER RANGE 0 to 9999;
				teste_i_m_b2: OUT INTEGER RANGE 0 to 9999;
				res_fat	 	: OUT INTEGER RANGE 0 TO 9999);	 	-- saida
END Romualdo4;

ARCHITECTURE testeRomualdo4 OF Romualdo4 IS 
--	caso_00 => inicio do fatorial 		:	a <= 1 	e 	b=N 	   
--	caso_01 => loop 					:	a <= a*b e 	b <= b-1
--	caso_10 => fim						:	a <= a		b <= b
TYPE st IS ( caso_10, caso_01, caso_00); 										-- novo tipo definido
SIGNAL estado 							: st := caso_00;								-- sinal estado tipo "st"
SIGNAL regA								: INTEGER RANGE 0 TO 999999 	:= 0; 
SIGNAL regB								: INTEGER RANGE 0 TO 999999	:= 0; 
SIGNAL i_mux_a_0 						: INTEGER RANGE 0 TO 999999	:= 0; 	-- sinais de entrada do mux_a
SIGNAL i_mux_a_1 						: INTEGER RANGE 0 TO 999999	:= 0; 	-- sinais de entrada do mux_a
SIGNAL i_mux_a_2						: INTEGER RANGE 0 TO 999999	:= 0; 	-- sinais de entrada do mux_a
SIGNAL i_mux_b_0					 	: INTEGER RANGE 0 TO 999999	:= 0;		-- sinais de entrada do mux_b
SIGNAL i_mux_b_1						: INTEGER RANGE 0 TO 999999	:= 0;		-- sinais de entrada do mux_b
SIGNAL i_mux_b_2						: INTEGER RANGE 0 TO 999999	:= 0;		-- sinais de entrada do mux_b
SIGNAL sel_mux_a						: STD_LOGIC_VECTOR(1 DOWNTO 0):= "10"; -- declara vetor que recebera os bits de selecao
SIGNAL sel_mux_b 						: STD_LOGIC_VECTOR(1 DOWNTO 0):= "00"; -- declara vetor que recebera os bits de selecao
SIGNAL ot_mux_a, ot_mux_b			: INTEGER RANGE 0 TO 999999	:= 0;  	-- saidas selecionadas no mux_a e mux_b 
SIGNAL z_in								: STD_LOGIC 						:= '0'; 	-- saida da comparacao entradaN == 0 ?					

BEGIN 
	
	res_fat <= regA;	-- saida N!
	i_mux_a_2 <= 1;											 					-- a <= 1
	i_mux_b_0 <= entrada_N;
	teste_z <= z_in;
	teste_regA <= regA;
	teste_regb <= regB;
	teste_i_m_a0  	<= i_mux_a_0;
	teste_i_m_a1 	<= i_mux_a_1;
	teste_i_m_a2	<= i_mux_a_2;
	teste_i_m_b0	<= i_mux_b_0;
	teste_i_m_b1	<= i_mux_b_1;
	teste_i_m_b2	<= i_mux_b_2;
	
	regs: PROCESS(ck)
	BEGIN
		i_mux_a_0 <= regA;
		i_mux_a_1 <= regA*regB;	
		i_mux_b_1 <= regB - 1;
		i_mux_b_2 <= regB;
	END PROCESS regs;
		
	MaqEst:PROCESS (ck,estado) -- Maquina de estado que controla as entradas dos mux_a e mux_b
	BEGIN
		IF ot_mux_b = 0 THEN
			z_in <= '1';
		ELSE 
			z_in <= '0';
		END IF;
		IF iniciar = '0' THEN estado <= caso_00; -- estado inicial
		ELSIF (ck'EVENT AND ck = '1') THEN
			CASE estado IS 
				WHEN caso_00 => 								
					IF z_in = '0' THEN 
						estado <= caso_01; 					
					ELSE 
						estado <= caso_01; 					
					END IF;
				WHEN caso_01 => 								
					IF z_in = '0' THEN 
						estado <= caso_01; 					
					ELSE 
						estado <= caso_10; 					
					END IF;
				WHEN caso_10 => 								
					IF z_in = '0' THEN 
						estado <= caso_10;				 	
					ELSE 
						estado <= caso_10; 					
					END IF;
			END CASE;	
			CASE sel_mux_a IS
				WHEN "10" => ot_mux_a <= i_mux_a_2; -- estado: inicio do fatorial
				WHEN "01" => ot_mux_a <= i_mux_a_1; -- estado: loop
				WHEN "00" => ot_mux_a <= i_mux_a_0; -- estado: fim
				WHEN OTHERS => ot_mux_a <= NULL;
			END CASE;
			CASE sel_mux_b IS
				WHEN "00" => ot_mux_b <= i_mux_b_0; -- estado: inicio do fatorial
				WHEN "01" => ot_mux_b <= i_mux_b_1; -- estado: loop
				WHEN "10" => ot_mux_b <= i_mux_b_2; -- estado: fim
				WHEN OTHERS => ot_mux_b <= NULL;
			END CASE;
		END IF; 
		regA <= ot_mux_a;
		regB <= ot_mux_b;
	END PROCESS MaqEst;
	
	WITH estado SELECT --define entradas do mux_a
		sel_mux_a	<=	"10" WHEN caso_00, 
							"01" WHEN caso_01, 
							"00" WHEN caso_10; 
						
	WITH estado SELECT --define entradas do mux_b
		sel_mux_b	<=	"00" WHEN caso_00, 
							"01" WHEN caso_01, 
							"10" WHEN caso_10; 
			
END testeRomualdo4;