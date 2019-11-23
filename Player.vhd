----------------------------------------------------------------------------------
-- Company: University of Essex
-- Engineer: Nnadika Chima Daniel
-- Create Date:    13:05:06 03/06/2014 
--- Description: Basketball video game player representation
-- Project Name: PLAYER
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Player is
 generic (PX : natural := 750;
			PY : natural := 450;
			LENGHT  : natural := 30;
			COLOUR : std_logic_vector (7 downto 0) := "00011100" ); --GREEN

	 port (	PIXEL_CK : in std_logic;
				X, Y: in unsigned (10 downto 0); 
				RGB : out std_logic_vector (7 downto 0);
				MASK : out std_logic );
end Player;

architecture Behavioral of Player is
	signal FLAG : std_logic;
begin
	process
	begin
		wait until rising_edge(PIXEL_CK);
		 if X >= PX and X <= PX +  LENGHT and Y >= PY and Y <= PY +  (LENGHT + 120) then
				FLAG <= '1';
		else 
				FLAG <= '0';
		end if;
	end process;
	--layer attribute
	RGB <= COLOUR when FLAG = '1' else (OTHERS => '0');
	MASK <= FLAG;

end Behavioral;

