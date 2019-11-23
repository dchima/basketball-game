----------------------------------------------------------------------------------
-- Company: University of Essex
-- Engineer: Nnadika Chima Daniel
-- Create Date:    22:45:40 03/10/2014 
--- Description: Ball detector (acts like a sensor for the basketball)
-- Project Name: DETECT
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity detect is
   generic (R  : natural := 20;
			COLOUR : std_logic_vector (7 downto 0) := "00000000" ); --orange
   port (
      PIXEL_CK : in std_logic;
      X, Y: in unsigned (10 downto 0);
      RGB : out std_logic_vector (7 downto 0); 
		BTN : in std_logic;
		SWX : in unsigned (3 downto 0);
		SWY : in unsigned (3 downto 0);
      MASK : out std_logic;
		SET : in std_logic;
		SET2 : in std_logic;
		BX : out unsigned (10 downto 0);
		BY : out unsigned (10 downto 0));

	
end detect;

architecture Behavioral of detect is
   signal DX2, DY2 : unsigned ((2*X'high+1) downto 0) := (others => '0'); 
   signal FLAG : std_logic;
   constant R2 : unsigned(DX2'range) := to_unsigned(R * R, DX2'length);
	signal CX : unsigned (10 downto 0) := to_unsigned(750, 11);
	signal CY : unsigned (10 downto 0) := to_unsigned(430, 11);
	signal Vy : unsigned (10 downto 0);
	signal Vx : unsigned (3 downto 0);
	signal RST : std_logic;
	signal CS : unsigned (10 downto 0);
begin
   process
   begin
      wait until rising_edge(PIXEL_CK);
      if X <= CX - R or X >= CX + R then
         DX2 <= R2;
      else
         DX2 <= DX2 + (X * 2) - (CX * 2) - 1;
      end if;
      
      if X = 0 then
         if (Y <= CY - R) or (Y >= CY + R) then
            DY2 <= R2;
         else
            DY2 <= DY2 + (Y * 2) - (CY * 2) - 1;
         end if;
      end if;
		
		
   end process;
   
	--HORIZONTAL MOTION
	process
	begin 
		wait until rising_edge(PIXEL_CK);
		if BTN = '1' and CX = 750 and CY = 430 then
				Vx <= SWX; 
			end if;
			if X <= 0  and Y <=0 then
				if RST = '1' then
					CX <= CX - Vx; --constant horizontal motion
				end if;
			end if;
			--reset detector x position
			if CX <= 10 or CX >= 790 or CY <= 10 or CY >=590 or SET = '1' or SET2 = '1' then 
				CX <= to_unsigned(750, 11);
			end if;
	end process;
	
	--VERTICAL MOTION
	process
	begin
		wait until rising_edge(PIXEL_CK);
			if BTN = '1' and CX = 750 and CY = 430 then
				RST <= '1';
				Vy <= SWY * 2; 
				CS <= to_unsigned(0, 11);
			end if;
			if X <= 0 and Y <=0 then
				--vertical motion physisc (gravitational pattern)
				if RST = '1' then 
					if Vy > 1 then
						CY <= CY - Vy;
						Vy <= Vy - 1;
					else
						CY <= CY + CS;
						CS <= CS + 1;
					end if;
				end if;
			end if;
			--reset detector y position
			if CX <= 10 or CX >= 790 or CY <= 10 or CY >=590 or SET = '1' or SET2 = '1' then
				CY <= to_unsigned(430, 11);
				RST <= '0';
			end if;
	end process;
	
	BX <= CX;
	BY <= CY;

	
   -- DISC
   FLAG <= '1' when (DX2 + DY2 < R2) else '0';
   RGB <= COLOUR when FLAG = '1' else (OTHERS => '0');
   MASK <= FLAG;
end Behavioral;

