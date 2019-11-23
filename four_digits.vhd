----------------------------------------------------------------------------------
-- Author: NNADIKA CHIMA DANIEL
-- Class: CE339 
-- Create Date:    09:01:02 01/22/2014 
-- Module Name:    four_digits - Behavioral 
-- Target Devices: BASYS2
-- Description: 4-Digit Multiplexer
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- I/O ports
entity four_digits is
	port ( D0 : in UNSIGNED (3 downto 0);
			 D1 : in UNSIGNED (3 downto 0);
			 D2 : in UNSIGNED (3 downto 0);
			 D3 : in UNSIGNED (3 downto 0);
			 CK : in STD_LOGIC;
			 --DP : out STD_LOGIC;
			 CATHODES : out STD_LOGIC_VECTOR (6 downto 0);
			 ANODES : out STD_LOGIC_VECTOR (3 downto 0));
end four_digits;

architecture Behavioral of four_digits is
-- define internal signals
signal DIGIT : UNSIGNED (3 downto 0);
signal S : UNSIGNED (1 downto 0);

begin
-- clock rising edge connected to button
process 
begin
	wait until rising_edge(CK);
	 S <= S + 1;
end process;

-- Inplements lover level module (ONE DIGIT)
one_digit_unit : entity one_digit(Behavioral)
      port map (DIGIT => DIGIT,
         CATHODES => CATHODES);
			
-- enable multplex values
	with S select
		DIGIT <= D0 when "00",
					D1 when "01",
					D2 when "10",
					D3 when others;
-- enable anodes (inverted)					
	with S select
		ANODES <= "1110" when "00",
					 "1101" when "01",
					 "1011" when "10",
					 "0111" when others;
-- enable Decimal point at second display digit 
--	with S select
--		DP <= '0' when "10",
--				'1' when others;		


end Behavioral;
