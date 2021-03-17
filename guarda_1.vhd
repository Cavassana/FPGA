	-- 10^3
	m_c:	contadorTesteUnidade 
		PORT MAP(clock 	=>	pulso1s,
					cnt_en	=> enable(3),
					data		=> dado_paralelo,
					sclr		=>	rst,
					sload		=> habilita_paralelo,
					sset		=> '0',
					updown	=> sentido,
					cout		=> enable(4),
					q			=> saida_contador_m);
	m_d: decodificador7segmentos 
		PORT MAP( saida_contador_m, sa(3), sb(3), sc(3), sd(3), se(3), sf(3), sg(3));

	-- 10^4
	dm_c:	contadorTesteUnidade 
		PORT MAP(clock 	=>	pulso1s,
					cnt_en	=> enable(4),
					data		=> dado_paralelo,
					sclr		=>	rst,
					sload		=> habilita_paralelo,
					sset		=> '0',
					updown	=> sentido,
					cout		=> enable(5),
					q			=> saida_contador_dm); 
	dm_d: decodificador7segmentos 
		PORT MAP( saida_contador_dm, sa(4), sb(4), sc(4), sd(4), se(4), sf(4), sg(4));
	-- 10^5
	meg_c: contadorTesteUnidade 
		PORT MAP(clock 	=>	pulso1s,
					cnt_en	=> enable(5),
					data		=> dado_paralelo,
					sclr		=>	rst,
					sload		=> habilita_paralelo,
					sset		=> '0',
					updown	=> sentido,
					cout		=> overflow,
					q			=> saida_contador_meg);	
	meg_d: decodificador7segmentos 
		PORT MAP( saida_contador_meg, sa(5), sb(5), sc(5), sd(5), se(5), sf(5), sg(5));
		
COMPONENT contaHora_PM IS
	PORT(	clock		: IN STD_LOGIC ;
			cnt_en	: IN STD_LOGIC ;
			data		: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			sclr		: IN STD_LOGIC ;
			sload		: IN STD_LOGIC ;
			sset		: IN STD_LOGIC ;
			updown	: IN STD_LOGIC ;
			cout		: OUT STD_LOGIC ;
			q			: OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
END COMPONENT;