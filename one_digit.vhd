----------------------------------------------------------------------------------
-- Author: NNADIKA CHIMA DANIEL
-- Class: CE339 
-- Create Date:    08:59:38 01/21/2014 
-- Module Name:    one_digit - Behavioral 
-- Target Devices: BASYS2
-- Description: BCD Decoder

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- I/O ports
entity one_digit is
	Port ( DIGIT : in UNSIGNED(3 downto 0);
			 CATHODES : out STD_LOGIC_VECTOR (6 downto 0));
end one_digit;

architecture Behavioral of one_digit is

-- sets behaviour of entity (CATHODES value dependent on DIGIT)
begin
	with DIGIT select
	CATHODES <= "1000000" when "0000", --0
					"1111001" when "0001", --1
					"0100100" when "0010", --2
					"0110000" when "0011", --3
					"0011001" when "0100", --4
					"0010010" when "0101", --5
					"0000010" when "0110", --6
					"1111000" when "0111", --7
					"0000000" when "1000", --8
					"0010000" when "1001", --9
					"0001000" when "1010", --10
					"0000001" when "1011", --11
					"1000110" when "1100", --12
					"0100001" when "1101", --13
					"0000110" when "1110", --14
					"0001110" when others; --15
					
					 


end Behavioral;

