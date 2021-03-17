ENTITY maqEstadoFatorial IS -- maq_est2 MEALY
    PORT (	entrada_N 	: IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- entrada N			
			iniciar		: IN STD_LOGIC; -- iniciar='1' => q="00"
			res_fat	 	: IN STD_LOGIC_VECTOR(5 DOWNTO 0); -- saida
END maqEstadoFatorial;

ARCHITECTURE testemaqEstadoFatorial OF maqEstadoFatorial IS 
--	caso_00 => inicio do fatorial 	:	a <= 1 	 e 	b=N 	   
--	caso_01 => loop 				:	a <= a*b e 	b <= b-1
--	caso_10	=> fim					:	a <= a		b <= b
TYPE st IS ( caso_10, caso_01, caso_00); -- novo tipo definido
SIGNAL estado 							: st; -- sinal estado tipo "st"
SIGNAL regA								: IN UNSIGNED(5 DOWNTO 0); 
SIGNAL regB								: IN UNSIGNED(5 DOWNTO 0);
SIGNAL i_mux_a_0, i_mux_a_1, i_mux_a_2	: IN UNSIGNED(5 DOWNTO 0); -- sinais de entrada do mux_a
SIGNAL i_mux_b_0, i_mux_b_1, i_mux_b_2	: IN UNSIGNED(5 DOWNTO 0); -- sinais de entrada do mux_b
SIGNAL sel_mux_a						: STD_LOGIC_VECTOR(1 DOWNTO 0); -- declara vetor que recebera os bits de selecao
SIGNAL sel_mux_b 						: STD_LOGIC_VECTOR(1 DOWNTO 0); -- declara vetor que recebera os bits de selecao
SIGNAL ot_mux_a, ot_mux_b				: STD_LOGIC_VECTOR(5 DOWNTO 0); -- saidas selecionadas no mux_a e mux_b 
SIGNAL z_in								: STD_LOGIC; -- saida da comparacao entradaN == 0 ?					

BEGIN 
	
	i_mux_a_2 <= "000001"; -- a <= 1
	i_mux_b_0 <= UNSIGNED(entrada_N);
	
	comp_b: PROCESS(n_i) 
	BEGIN
		IF n_i == "000000" THEN
			z_in <= '1';
		ELSE 
			z_in <= '0';
		END IF;
	
	END PROCESS comp_b;

	mux_a: PROCESS(sel_mux_a)
	BEGIN
		CASE sel_mux_a IS
			WHEN "00" => ot_mux_a <= i_mux_a_2; -- estado: inicio do fatorial
			WHEN "01" => ot_mux_a <= i_mux_a_1; -- estado: loop
			WHEN "10" => ot_mux_a <= i_mux_a_0; -- estado: fim
			WHEN OTHERS => ot_mux_a <= NULL;
		END CASE;
	END PROCESS mux_a;
	
	mux_b: PROCESS(sel_mux_b) -- sinal "sel" inserido na lista
	BEGIN
		CASE sel_mux_b IS
			WHEN "00" => ot_mux_b <= i_mux_b_0; -- estado: inicio do fatorial
			WHEN "01" => ot_mux_b <= i_mux_b_1; -- estado: loop
			WHEN "10" => ot_mux_b <= i_mux_b_2; -- estado: fim
			WHEN OTHERS => ot_mux_b <= NULL;
		END CASE;
	END PROCESS mux_b;
	
	reg_a: PROCESS(ot_mux_a)
	BEGIN
		regA <= ot_mux_a;
	END PROCESS reg_a;
	
	reg_b: PROCESS(ot_mux_b)
	BEGIN
		regB <= ot_mux_b;
	END PROCESS reg_b;

	multi: PROCESS(regA,regB)
	BEGIN
		i_mux_a_0 <= regA;
		i_mux_a_1 <= regA*regB;	
	END PROCESS multi;
	
	sub: PROCESS(regA,regB)
	BEGIN
		i_mux_b_2 <= regB;
		i_mux_b_1 <= regB - 1;
	END PROCESS multi;
	
	MaqEst:PROCESS (z_in, iniciar) -- Maquina de estado que controla as entradas dos mux_a e mux_b
	BEGIN
	IF iniciar = '1' THEN estado <= caso_00; -- estado inicial
		CASE estado IS 
			WHEN caso_00 => 							-- q=0
				IF z_in = '0' THEN 
					estado <= caso_01; 					-- q=1
				ELSE 
					estado <= caso_01; 					-- q=2
				END IF;
			WHEN caso_01 => 							-- q=1
				IF z_in = '0' THEN 
					estado <= caso_01; 					-- q=3
				ELSE 
					estado <= caso_10; 					-- q=0
				END IF;
			WHEN caso_10 => 							-- q=3
				IF z_in = '0' THEN 
					estado <= caso_10;				 	-- q=2
				ELSE 
					estado <= caso_10; 					-- q=1
				END IF;
		END CASE;
	END IF; 
	END PROCESS MaqEst;
	
	WITH estado SELECT --define entradas do mux_a
		sel_mux_a	<=	"10" WHEN caso_00, 
						"01" WHEN caso_01, 
						"00" WHEN caso_10; 
						
	WITH estado SELECT --define entradas do mux_b
		sel_mux_b	<=	"00" WHEN caso_00, 
						"01" WHEN caso_01, 
						"10" WHEN caso_10; 
			
END testemaqEstadoFatorial;