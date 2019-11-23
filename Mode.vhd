----------------------------------------------------------------------------------
-- Company: University of Essex
-- Engineer: Nnadika Chima Daniel
-- Create Date:    20:28:59 03/09/2014 
--- Description: Basketball video game gameplay mode
-- Project Name: MODE
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Mode is
	port ( PIXEL_CK : in std_logic;
			 BX, BY, RX, RY : in unsigned (10 downto 0);
			 CK : in STD_LOGIC;
			 CATHODES : out STD_LOGIC_VECTOR (6 downto 0);
			 ANODES : out STD_LOGIC_VECTOR (3 downto 0);
			 TRIG : out STD_LOGIC;
			 TRIG2 : out STD_LOGIC;
			 M1 : in STD_LOGIC;
			 M2 : in STD_LOGIC);
end Mode;

architecture Behavioral of Mode is
	signal DIV_16 : UNSIGNED (15 downto 0);
	signal GOAL : UNSIGNED (3 downto 0):= to_unsigned(0, 4);
	signal TRY : UNSIGNED (3 downto 0) := to_unsigned(10, 4);
	signal SET: std_logic;
	signal SET2: std_logic;
	signal FLAG1 : STD_LOGIC;
	signal FLAG2 : STD_LOGIC;

begin
process
begin
	wait until rising_edge(CK);
	DIV_16 <= DIV_16 + 1;
end process;

--GOAL AND RETRY CONDITIONS
process 
begin
	wait until rising_edge(PIXEL_CK);
	if SET = '1' then
		GOAL <= GOAL + 1;
		TRY <= TRY - 1;
	elsif SET2 = '1' then
		TRY <= TRY - 1;
	end if;
	if BX <= 10 or BX >= 790 or BY <= 10 or BY >=590 then
		TRY <= TRY - 1;
	end if;
	--reset try and goal values
	if TRY = "0000" then
		GOAL <= "0000";
		TRY <= "1010";
	end if;
end process;
--set conditions for ball
SET <= '1' when BX >= (RX + 20) and BX <= (RX + 80) and	BY >= (RY + 1)  and BY <= (RY + 3) and BX <=  700 and BY <= 500 else '0';
--set conditions for detector
SET2 <= '1' when ((BX >= RX and BX <= (RX + 20)) or (BX >= (RX + 80) and BX <= (RX + 100))) and	
			BY >= RY and BY <= (RY + 5) and BX <=  700 and BY <= 500 and M1 = '1' and M2 = '1' else '0';
TRIG <= SET;
TRIG2 <= SET2;

--MULTIPLEXER TO DISPLAY 
Mux : entity four_digits(Behavioral)
	port map (D3 => "0000", D2 => "0000", D1 => TRY, D0 => GOAL,
                CK => DIV_16(15), CATHODES => CATHODES, ANODES => ANODES);
end Behavioral;

