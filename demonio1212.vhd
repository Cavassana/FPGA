library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;

LIBRARY lpm;
USE lpm.all;

ENTITY contadorWHora IS 
GENERIC( frequencia	: NATURAL := 250000; -- 250khz p/validação
			n 				: INTEGER := 6); 		-- define no. de contadores); -- 50MHz
    PORT(clk						: IN STD_LOGIC; 
			rst						: IN STD_LOGIC; 
			habilita_contador		: IN STD_LOGIC; 
			sentido					: IN STD_LOGIC;
			habilita_paralelo		: IN STD_LOGIC; 
			habilita_alarme			: IN STD_LOGIC; 
			desliga_buzzer			: IN STD_LOGIC; 
			dado_paralelo			: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			sel_1,sel_2,sel_3		: IN STD_LOGIC;
			overflow					: BUFFER STD_LOGIC;
			overflow_led			: OUT STD_LOGIC;
			buzzer					: OUT STD_LOGIC;
			pisca_placa				: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			led						: OUT STD_LOGIC_VECTOR(1 TO 8);
			sa,sb,sc,sd,se,sf,sg	: OUT STD_LOGIC_VECTOR(5 downto 0));
END contadorWHora;

ARCHITECTURE teste_contadorWHora OF contadorWHora IS 

COMPONENT divisorFrequencia 
GENERIC( frequencia_osc : NATURAL); -- 12.5Mhz (padrao p/ teste)
	PORT(	clk	: IN STD_LOGIC;
			pulso	: OUT STD_LOGIC); 
END COMPONENT;

COMPONENT decodificador7segmentosRev1
	PORT (seletor					: IN STD_LOGIC_VECTOR(1 downto 0);
			entrada_display		: IN STD_LOGIC_VECTOR(4 downto 0);
			a, b, c, d, e, f, g 	: OUT STD_LOGIC);
END COMPONENT;

COMPONENT contadorMOD60 
GENERIC ( modulo	: IN NATURAL; -- define unidade ou dezena
			tam_bus	: IN NATURAL); -- define bits
	PORT( cin		: IN STD_LOGIC ;
			clock		: IN STD_LOGIC ;
			data		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			sclr		: IN STD_LOGIC ;
			sload		: IN STD_LOGIC ;
			updown	: IN STD_LOGIC ;
			cout		: OUT STD_LOGIC ;
			q			: OUT STD_LOGIC_VECTOR (4 DOWNTO 0));
END COMPONENT;

COMPONENT contaHora2_PM
PORT
	(	clock		: IN STD_LOGIC ;
		cnt_en	: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		sclr		: IN STD_LOGIC ;
		sload		: IN STD_LOGIC ;
		updown	: IN STD_LOGIC ;
		cout		: OUT STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (4 DOWNTO 0));
END COMPONENT;

-- SINAIS
-- habilita o próximo contador MOD60
SIGNAL enable						: STD_LOGIC_VECTOR(1 TO n-1); 
-- frequencia de 1hz quando frequencia_osc = 50Mhz
SIGNAL pulso1s						: STD_LOGIC; 
-- sinal que habilita a dezena do contador de hora
SIGNAL habilita_dez_hora		: STD_LOGIC;
-- sinal de overflow para led 
SIGNAL over_int					: STD_LOGIC;
-- registradores para alarme
SIGNAL reg8_alarme_mem			: STD_LOGIC_VECTOR(14 downto 0):= (OTHERS => '0');
SIGNAL reg8_alarme_cmp			: STD_LOGIC_VECTOR(14 downto 0):= (OTHERS => '0');
-- sinais de saida dos contadores de modulo 60 e 24
SIGNAL saida_contador_u 		: STD_LOGIC_VECTOR(4 downto 0):= (OTHERS => '0');
SIGNAL saida_contador_d 		: STD_LOGIC_VECTOR(4 downto 0):= (OTHERS => '0');
SIGNAL saida_contador_c 		: STD_LOGIC_VECTOR(4 downto 0):= (OTHERS => '0');
SIGNAL saida_contador_m 		: STD_LOGIC_VECTOR(4 downto 0):= (OTHERS => '0');
SIGNAL saida_contador_dm		: STD_LOGIC_VECTOR(4 downto 0):= (OTHERS => '0');
SIGNAL saida_contador_meg 		: STD_LOGIC_VECTOR(4 downto 0):= (OTHERS => '0');
-- sinais que guardam o horario de alarme
SIGNAL mem_saida_contador_c 	: STD_LOGIC_VECTOR(4 downto 0):= (OTHERS => '0');
SIGNAL mem_saida_contador_m 	: STD_LOGIC_VECTOR(4 downto 0):= (OTHERS => '0');
SIGNAL mem_saida_contador_dm	: STD_LOGIC_VECTOR(4 downto 0):= (OTHERS => '0');
SIGNAL mem_saida_contador_meg : STD_LOGIC_VECTOR(4 downto 0):= (OTHERS => '0');
-- sinais para ajustar a hora
SIGNAL dado_paralelo_u 			: STD_LOGIC_VECTOR (4 DOWNTO 0):= (OTHERS => '0');
SIGNAL dado_paralelo_d			: STD_LOGIC_VECTOR (4 DOWNTO 0):= (OTHERS => '0');
SIGNAL dado_paralelo_c 			: STD_LOGIC_VECTOR (4 DOWNTO 0):= (OTHERS => '0');
SIGNAL dado_paralelo_m			: STD_LOGIC_VECTOR (4 DOWNTO 0):= (OTHERS => '0');
SIGNAL dado_paralelo_dm			: STD_LOGIC_VECTOR (4 DOWNTO 0):= (OTHERS => '0');
SIGNAL dado_paralelo_meg		: STD_LOGIC_VECTOR (4 DOWNTO 0):= (OTHERS => '0');
-- sinais que vão para o decode7segm
SIGNAL dado_display_u 			: STD_LOGIC_VECTOR (4 DOWNTO 0):= (OTHERS => '0');
SIGNAL dado_display_d			: STD_LOGIC_VECTOR (4 DOWNTO 0):= (OTHERS => '0');
SIGNAL dado_display_c 			: STD_LOGIC_VECTOR (4 DOWNTO 0):= (OTHERS => '0');
SIGNAL dado_display_m			: STD_LOGIC_VECTOR (4 DOWNTO 0):= (OTHERS => '0');
SIGNAL dado_display_dm			: STD_LOGIC_VECTOR (4 DOWNTO 0):= (OTHERS => '0');
SIGNAL dado_display_meg			: STD_LOGIC_VECTOR (4 DOWNTO 0):= (OTHERS => '0');
-- mux de seleção de contador p/ ajuste da hora
SIGNAL sel_mux						: STD_LOGIC_VECTOR (2 DOWNTO 0):= (OTHERS => '0');
-- guarda lixo
SIGNAL ot_mux						: STD_LOGIC_VECTOR(3 downto 0):= (OTHERS => '0');
-- alguma flag
SIGNAL flag 						: STD_LOGIC;

BEGIN 
--  forma vetor do mux com os bits de seleção
sel_mux <= sel_3 & sel_2 & sel_1; 
-- acende led onboard
	overflow_led <= NOT over_int;
-- Divisor de frequencia
div_f0:	divisorFrequencia 
GENERIC MAP(frequencia)
	PORT MAP(clk, pulso1s); 
-- ajuste do relogio e do alarme
abc: PROCESS(sel_mux, habilita_paralelo, habilita_alarme) -- sinal "sel" inserido na lista
	BEGIN
		IF rst ='1' THEN
			dado_paralelo_u 	<= (OTHERS => '0');
			dado_paralelo_d	<= (OTHERS => '0');
			dado_paralelo_c 	<= (OTHERS => '0');		
			dado_paralelo_m	<= (OTHERS => '0');		
			dado_paralelo_dm	<= (OTHERS => '0');
			dado_paralelo_meg	<= (OTHERS => '0');
		ELSIF habilita_paralelo = '1' AND habilita_alarme = '0' THEN 
			CASE sel_mux IS
				WHEN "000" => dado_paralelo_u 	<= dado_paralelo;
								  dado_paralelo_d		<= "00000";
								  dado_paralelo_c		<= "00000";
								  dado_paralelo_m		<= "00000";
								  dado_paralelo_dm 	<= "00000";
								  dado_paralelo_meg	<= "00000";
				WHEN "001" => dado_paralelo_d 	<= dado_paralelo;
				WHEN "010" => dado_paralelo_c 	<= dado_paralelo; 
				WHEN "011" => dado_paralelo_m 	<= dado_paralelo;
				WHEN "100" => dado_paralelo_dm 	<= dado_paralelo; 
				WHEN OTHERS => ot_mux <= null;
			END CASE;
		ELSIF habilita_paralelo = '1' AND habilita_alarme = '1' THEN
				CASE sel_mux IS
					WHEN "000" => mem_saida_contador_c	 <= "00000";
									  mem_saida_contador_m	 <= "00000";
									  mem_saida_contador_dm  <= "00000";
									  mem_saida_contador_meg <= "00000";
					WHEN "001" => mem_saida_contador_c 	 <= dado_paralelo;
					WHEN "010" => mem_saida_contador_m 	 <= dado_paralelo; 
					WHEN "100" => mem_saida_contador_dm  <= dado_paralelo;
					WHEN OTHERS => ot_mux <= null;
				END CASE;
				reg8_alarme_mem <=  mem_saida_contador_dm  & mem_saida_contador_m & mem_saida_contador_c;
		END IF;
	END PROCESS abc;
-- alarme	
alarme: PROCESS(pulso1s)
		VARIABLE conta_pulsos 	: NATURAL RANGE 0 TO 9999999 := 0;
		VARIABLE a 					: INTEGER RANGE 0 TO 9999999;
		VARIABLE b 					: INTEGER RANGE 0 TO 9999999;
	BEGIN
		reg8_alarme_cmp <= saida_contador_dm & saida_contador_m & saida_contador_c;
		a := to_integer(unsigned(reg8_alarme_mem));
		b := to_integer(unsigned(reg8_alarme_cmp));
		IF a = b AND desliga_buzzer = '0' THEN
			IF (pulso1s'EVENT AND pulso1s ='1') THEN
				conta_pulsos := conta_pulsos+1;
			END IF;
			IF conta_pulsos <120 THEN
				buzzer <= '1';
			ELSE 
				buzzer <= '0';
			END IF;
		ELSE 
			conta_pulsos := 0;
			buzzer <= '0';
		END IF;
	END PROCESS alarme;
-- define Display
def_display: PROCESS(habilita_paralelo, habilita_alarme) -- sinal "sel" inserido na lista
	BEGIN 
		IF habilita_paralelo = '0' AND habilita_alarme = '0' THEN 
			dado_display_u 	<= saida_contador_u;
			dado_display_d		<= saida_contador_d;
			dado_display_c		<= saida_contador_c;
			dado_display_m		<= saida_contador_m;
			dado_display_dm	<= saida_contador_dm;
			dado_display_meg	<= saida_contador_meg;
		ELSIF habilita_paralelo = '1' AND habilita_alarme = '0' THEN 
			dado_display_u 	<= dado_paralelo_u;
			dado_display_d		<= dado_paralelo_d;
			dado_display_c		<= dado_paralelo_c;
			dado_display_m		<= dado_paralelo_m;
			dado_display_dm	<= dado_paralelo_dm;
			dado_display_meg	<= dado_paralelo_meg;
		ELSIF habilita_paralelo = '1' AND habilita_alarme = '1' THEN 
			dado_display_u 	<= "00000";
			dado_display_d		<= "00000";
			dado_display_c		<= mem_saida_contador_c;
			dado_display_m		<= mem_saida_contador_m;
			dado_display_dm	<= mem_saida_contador_dm;
			dado_display_meg	<= mem_saida_contador_meg;
		END IF;
END PROCESS;
-- Display
d_0:	decodificador7segmentosRev1 
		PORT MAP( "01", dado_display_u, sa(0), sb(0), sc(0), sd(0), se(0), sf(0), sg(0));
d_1:	decodificador7segmentosRev1 
		PORT MAP( "01", dado_display_d, sa(1), sb(1), sc(1), sd(1), se(1), sf(1), sg(1));	
d_2: decodificador7segmentosRev1 
		PORT MAP( "01", dado_display_c, sa(2), sb(2), sc(2), sd(2), se(2), sf(2), sg(2));		
d_3: decodificador7segmentosRev1 
		PORT MAP( "01", dado_display_m, sa(3), sb(3), sc(3), sd(3), se(3), sf(3), sg(3));	
d_4: decodificador7segmentosRev1 
		PORT MAP( "01", dado_display_dm, sa(4), sb(4), sc(4), sd(4), se(4), sf(4), sg(4));
d_5: decodificador7segmentosRev1 	
		PORT MAP( "10", dado_display_meg, sa(5), sb(5), sc(5), sd(5), se(5), sf(5), sg(5));			
-- Contador
-- 10^0
u_c:	contadorMOD60 
	GENERIC MAP(modulo	=> 10, -- define unidade ou dezena
					tam_bus	=>  5) -- define bits
		PORT MAP(cin		=> habilita_contador,
					clock 	=>	pulso1s,
					data		=> dado_paralelo_u,
					sclr		=>	rst,
					sload		=> habilita_paralelo,
					updown	=> sentido,
					cout		=> enable(1),
					q			=> saida_contador_u);
-- 10^1
d_c: 	contadorMOD60 
	GENERIC MAP(modulo	=>  6, -- define unidade ou dezena
					tam_bus	=>  5) -- define bits
		PORT MAP(cin		=> enable(1),
					clock 	=>	pulso1s,
					data		=> dado_paralelo_d,
					sclr		=>	rst,
					sload		=> habilita_paralelo,
					updown	=> sentido,
					cout		=> enable(2),
					q			=> saida_contador_d);
-- 10^2
c_c:	contadorMOD60 
	GENERIC MAP(modulo	=> 10, -- define unidade ou dezena
					tam_bus	=>  5) -- define bits
		PORT MAP(cin		=> enable(2),
					clock 	=>	pulso1s,
					data		=> dado_paralelo_c,
					sclr		=>	rst,
					sload		=> habilita_paralelo,
					updown	=> sentido,
					cout		=> enable(3),
					q			=> saida_contador_c);	
	-- 10^3
m_c:	contadorMOD60 
	GENERIC MAP(modulo	=>  6, -- define unidade ou dezena
					tam_bus	=>  5) -- define bits
		PORT MAP(cin		=> enable(3),
					clock 	=>	pulso1s,
					data		=> dado_paralelo_m,
					sclr		=>	rst,
					sload		=> habilita_paralelo,
					updown	=> sentido,
					cout		=> enable(4),
					q			=> saida_contador_m);
-- 10^4
dm_c:	contaHora2_PM 
		PORT MAP(cnt_en	=> enable(4), 
					clock 	=>	pulso1s,
					data		=> dado_paralelo_dm,
					sclr		=>	rst,
					sload		=> habilita_paralelo,
					updown	=> sentido,
					cout		=> enable(5),
					q			=> saida_contador_dm);	
-- 10^5
meg_c:	contaHora2_PM 
		PORT MAP(cnt_en	=> enable(4), 
					clock 	=>	pulso1s,
					data		=> dado_paralelo_dm,
					sclr		=>	rst,
					sload		=> habilita_paralelo,
					updown	=> sentido,
					cout		=> overflow,
					q			=> saida_contador_meg);	
-- leds
PROCESS(enable(1),enable(2),enable(3),enable(4),enable(5),overflow,sentido)
	BEGIN 
		IF enable(1)='1'  THEN led(1) <= '1'; 
								ELSE led(1) <= '0'; END IF;
		IF enable(2)='1'  THEN led(2) <= '1'; 
								ELSE led(2) <= '0'; END IF;
		IF enable(3)='1'  THEN led(3) <= '1'; 
								ELSE led(3) <= '0'; END IF;
		IF enable(4)='1'  THEN led(4) <= '1'; 
								ELSE led(4) <= '0'; END IF;
		IF enable(5)='1'  THEN led(5) <= '1'; 
								ELSE led(5) <= '0'; END IF;
		IF over_int ='1'  THEN led(6) <= '1'; 
								ELSE led(6) <= '0'; END IF;
		IF habilita_paralelo ='1'  THEN led(7) <= '1'; 
											ELSE led(7) <= '0'; END IF;	
		IF habilita_contador ='1'  THEN led(8) <= '1'; 
											ELSE led(8) <= '0'; END IF;
		IF sentido ='1'   THEN	pisca_placa(1) <= '1'; 
										pisca_placa(0) <= '0'; 
								ELSE 	pisca_placa(1) <= '0'; 
										pisca_placa(0) <= '1'; END IF;
END PROCESS;
END teste_contadorWHora;

-- leds
PROCESS(enable(1),enable(2),enable(3),enable(4),enable(5),overflow,sentido)
	BEGIN 
		IF enable(1)='1'  THEN led(1) <= '1'; 
								ELSE led(1) <= '0'; END IF;
		IF enable(2)='1'  THEN led(2) <= '1'; 
								ELSE led(2) <= '0'; END IF;
		IF enable(3)='1'  THEN led(3) <= '1'; 
								ELSE led(3) <= '0'; END IF;
		IF enable(4)='1'  THEN led(4) <= '1'; 
								ELSE led(4) <= '0'; END IF;
		IF enable(5)='1'  THEN led(5) <= '1'; 
								ELSE led(5) <= '0'; END IF;
		IF overflow ='1'  THEN led(6) <= '1'; 
								ELSE led(6) <= '0'; END IF;
		IF habilita_paralelo ='1'  THEN led(7) <= '1'; 
											ELSE led(7) <= '0'; END IF;	
		IF habilita_contador ='1'  THEN led(8) <= '1'; 
											ELSE led(8) <= '0'; END IF;
		IF sentido ='1'   THEN	pisca_placa(1) <= '1'; 
										pisca_placa(0) <= '0'; 
								ELSE 	pisca_placa(1) <= '0'; 
										pisca_placa(0) <= '1'; END IF;
END PROCESS;
