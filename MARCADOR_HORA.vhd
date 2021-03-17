-- PODE MARCAR CADA HORA SE CONFIGURADO

-- leds e buzzer
PROCESS(mem_saida_contador_c, saida_contador_c, flag, pulso1s)
	VARIABLE count 	: NATURAL RANGE 0 TO 300 := 300;
	VARIABLE count2 	: NATURAL RANGE 0 TO 3 := 0;
	VARIABLE flag1 	: STD_LOGIC;
	BEGIN 
		IF flag(0)='1' THEN led(1) <= '1'; 
							ELSE led(1) <= '0'; END IF;
		IF flag(1)='1' THEN led(2) <= '1'; 
							ELSE led(2) <= '0'; END IF;
		IF flag(2)='1' THEN led(3) <= '1'; 
							ELSE led(3) <= '0'; END IF;
		--	ALARME
		IF (pulso1s = '1' ) THEN
			IF (flag1 = '1') THEN count := count-1; 
			END IF;
		END IF;		
		IF flag(3)='1' THEN 
			count := 300; 
			count2 := 3; 
			flag1 := '1'; 
			END IF;
		IF count >160 AND count2 > 0 AND flag1 = '1' THEN
			led(8) <= '1';
			buzzer <= '1';
		END IF;
		IF count <=80 AND count2 > 0 AND flag1 = '1' THEN
			buzzer <= '0';
			led(8) <= '0';
		END IF;
		IF count = 0 AND count2 > 0 THEN 
			count2:= count2-1;
			count := 240; 
		END IF;
		IF count2 = 0 THEN flag1 := '0'; END IF;
		
END PROCESS;