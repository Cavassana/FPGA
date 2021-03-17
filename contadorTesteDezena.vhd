LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY lpm;
USE lpm.all;

ENTITY contadorTesteDezena IS
	PORT(	cin		: IN STD_LOGIC ;
			clock	: IN STD_LOGIC ;
			cnt_en	: IN STD_LOGIC ;
			data	: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			sclr	: IN STD_LOGIC ;
			sload	: IN STD_LOGIC ;
			updown	: IN STD_LOGIC ;
			cout	: OUT STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (2 DOWNTO 0));
END contadorTesteDezena;

ARCHITECTURE SYN OF contadorTesteDezena IS

	SIGNAL sub_wire0	: STD_LOGIC ;
	SIGNAL sub_wire1	: STD_LOGIC_VECTOR (2 DOWNTO 0);

	COMPONENT lpm_counter
	GENERIC (
		lpm_direction	: STRING;
		lpm_modulus		: NATURAL;
		lpm_port_updown	: STRING;
		lpm_type		: STRING;
		lpm_width		: NATURAL);
		
	PORT (clock		: IN STD_LOGIC ;
			sclr	: IN STD_LOGIC ;
			cnt_en	: IN STD_LOGIC ;
			cout	: OUT STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
			sload	: IN STD_LOGIC ;
			updown	: IN STD_LOGIC ;
			cin		: IN STD_LOGIC ;
			data	: IN STD_LOGIC_VECTOR (2 DOWNTO 0));
	END COMPONENT;

BEGIN
	cout <= sub_wire0;
	q    <= sub_wire1(2 DOWNTO 0);

	LPM_COUNTER_component : LPM_COUNTER
GENERIC MAP (	lpm_direction => "UNUSED",
				lpm_modulus => 6,
				lpm_port_updown => "PORT_USED",
				lpm_type => "LPM_COUNTER",
				lpm_width => 3)
	PORT MAP (	clock => clock,
				sclr => sclr,
				cnt_en => cnt_en,
				sload => sload,
				updown => updown,
				cin => cin,
				data => data,
				cout => sub_wire0,
				q => sub_wire1);

END SYN;