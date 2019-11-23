----------------------------------------------------------------------------------
-- Company: University of Essex
-- Engineer: Nnadika Chima Daniel
-- Create Date:    19:22:41 03/08/2014  
--- Description: Rim and basket level
-- Project Name: RIM
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Rim is
	generic (LENGHT  : natural := 100;
			   LENGHT2  : natural := 90;
			 COLOUR : std_logic_vector (7 downto 0) := "11100000"; --RED RIM
			 COLOUR2 : std_logic_vector (7 downto 0) := "11111111"); --WHITE NET

	 port (	PIXEL_CK : in std_logic;
				X, Y: in unsigned (10 downto 0); 
				RGB : out std_logic_vector (7 downto 0);
				RGB2 : out std_logic_vector (7 downto 0);
				MASK : out std_logic;
				MASK2: out std_logic;
				RX : out unsigned (10 downto 0);
				RY : out unsigned (10 downto 0);
				BTN : in std_logic);
end Rim;

architecture Behavioral of Rim is
	signal PX : unsigned (10 downto 0) := to_unsigned(70, 11);
   signal PY : unsigned (10 downto 0) := to_unsigned(300, 11);
	signal PX2 : unsigned (10 downto 0) := to_unsigned(75, 11);
   signal PY2 : unsigned (10 downto 0) := to_unsigned(305, 11);
	signal FLAG : std_logic;
	signal FLAG2 : std_logic;
	signal TRIG : std_logic;
	signal RST : std_logic := '0';
	

begin
	--BASKET RIM
	process
	begin
		wait until rising_edge (PIXEL_CK);
		if X >= PX and X <= PX +  LENGHT and Y >= PY and Y <= PY +  (LENGHT - 95) then 
			FLAG <= '1'; 	
		else 
			FLAG <='0';
		end if;
	end process;
	
	--BASKET NET
	process
		begin
			wait until rising_edge (PIXEL_CK);
			if X >= PX2 and X <= PX2 +  LENGHT2 and Y >= PY2 and Y <= PY2 +  60 then 
				FLAG2 <= '1'; 	
			else 
				FLAG2 <='0';
			end if;
		end process;
		
	--RIM DIFFICULTY	
	process
	begin
		wait until rising_edge (PIXEL_CK);
		if BTN = '1' then
		--TOGGLE BETWEEN MODES
			RST <= not RST;
		end if;	
		if X <= 0  and Y <=0 then
			if RST = '1' then 
				if PX >= 70 and PX <= 500 and TRIG = '0' then
					PX <= PX + 5;
					PX2 <= PX2 + 5;
					if PX >= 495 then
						TRIG <= '1';
					end if;
				end if;
				if PX >= 70 and PX <= 500 and TRIG = '1' then
					PX <= PX - 5;
					PX2 <= PX2 - 5;
					if PX <= 75 then
						TRIG <= '0';
					end if;
				end if;
			else
				PX <= to_unsigned(70, 11);
				PX2 <= to_unsigned(75, 11);
			end if;
		end if;
	end process;
		
		
	RX <= PX;
	RY <= PY;	
	--layer attribute
	RGB <= COLOUR when FLAG = '1' else (OTHERS => '0');
	RGB2 <= COLOUR2 when FLAG2 = '1'  else (OTHERS => '0');
	MASK <= FLAG;
	MASK2 <= FLAG2;
	

end Behavioral;

