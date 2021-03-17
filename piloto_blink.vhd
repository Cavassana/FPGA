library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY piloto_blink IS
	PORT(	botao : in STD_LOGIC;
			led0	: out STD_LOGIC;
			led1	: out STD_LOGIC;
			led2	: out STD_LOGIC;
			led3	: out STD_LOGIC;
			led4	: out STD_LOGIC;
			led5	: out STD_LOGIC);
END piloto_blink;

ARCHITECTURE teste_piloto_blink OF piloto_blink IS 
BEGIN
	led0 <= botao;
	led1 <= NOT botao;
	led2 <= botao;
	led3 <= botao;
	led4 <= NOT botao;
	led5 <= botao;
END teste_piloto_blink;