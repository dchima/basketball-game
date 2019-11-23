----------------------------------------------------------------------------------
-- Company: University of Essex
-- Engineer: Nnadika Chima Daniel
-- Create Date:    12:53:12 02/12/2014 
--- Description: Top level of basketball video game
-- Project Name: BASKETBALL GAME
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity main is
   Port (	UCLK		: in STD_LOGIC;
				MCLK     : in STD_LOGIC;
				RCCLK 	: in STD_LOGIC;
				BTN      : in STD_LOGIC;
				BTN2      : in STD_LOGIC;
				SWX 		: in UNSIGNED (3 downto 0);
				SWY  		: in UNSIGNED (3 downto 0);
				CATHODES : out STD_LOGIC_VECTOR (6 downto 0);
				ANODES   : out STD_LOGIC_VECTOR (3 downto 0);
				HSYNC		: out STD_LOGIC;
				VSYNC		: out STD_LOGIC;
				RGB_OUT	: out STD_LOGIC_VECTOR (7 downto 0));
				
				attribute LOC : string;
				attribute LOC of MCLK  : signal is "B8";
				attribute LOC of RCCLK : signal is "C8";
				attribute LOC of BTN  : signal is "G12";
				attribute LOC of BTN2  : signal is "C11";
				attribute LOC of SWX   : signal is "N3 E2 F3 G3";
				attribute LOC of SWY   : signal is "B4 K3 L3 P11";
				attribute LOC of CATHODES : signal is "M12 L13 P12 N11 N14 H12 L14";
				attribute LOC of ANODES   : signal is "K14 M13 J12 F12";
				
end main;



architecture Behavioral of main is
signal hcount : UNSIGNED (10 downto 0);
signal vcount : UNSIGNED (10 downto 0);
signal blank : STD_LOGIC;
signal MASK  : STD_LOGIC;
signal MASK2 : STD_LOGIC;
signal MASK3 : STD_LOGIC;
signal MASK4 : STD_LOGIC;
signal MASK5 : STD_LOGIC;
signal CIR_RGB : STD_LOGIC_VECTOR (7 downto 0);
signal PL_RGB : STD_LOGIC_VECTOR (7 downto 0);
signal TRI_RGB : STD_LOGIC_VECTOR (7 downto 0);
signal RIM_RGB : STD_LOGIC_VECTOR (7 downto 0);
signal BASK_RGB : STD_LOGIC_VECTOR (7 downto 0);
signal DET_RGB : STD_LOGIC_VECTOR (7 downto 0);
signal BX: UNSIGNED (10 downto 0);
signal BY : UNSIGNED (10 downto 0);
signal RX: UNSIGNED (10 downto 0);
signal RY : UNSIGNED (10 downto 0);
signal SET : STD_LOGIC;
signal SET2 : STD_LOGIC;




begin

--800x600 resolutions
resolution : entity vga_controller_800_60(Behavioral)
	port map(rst => '0', pixel_clk => UCLK, HS => HSYNC, VS => VSYNC,
				hcount => hcount, vcount => vcount, blank => blank);
--basketball entiry
Basketball : entity disc(Iter)
	port map(PIXEL_CK => UCLK, X => hcount, Y => vcount, 
				RGB => CIR_RGB, BTN => BTN, SWX => SWX,  
				SWY => SWY, MASK => MASK, SET => SET2);
--basketball detect entity (detects ball orientation goal reach)
detect : entity detect(Behavioral)
	port map(PIXEL_CK => UCLK, X => hcount, Y => vcount, 
				RGB => DET_RGB, BTN => BTN, SWX => SWX,  
				SWY => SWY, MASK => MASK4, SET => SET, SET2 => SET2,
				BX => BX, BY => BY);
--Player entity
Player : entity Player(Behavioral)
	port map(PIXEL_CK => UCLK, X => hcount, Y => vcount, 
				RGB => PL_RGB, MASK => MASK2);
--rim and basket entity
Rim : entity Rim(Behavioral)
	port map(PIXEL_CK => UCLK, X => hcount, Y => vcount, 
				RGB => RIM_RGB, RGB2 => BASK_RGB, MASK => MASK3, MASK2 => MASK5, 
				RX => RX, RY => RY, BTN => BTN2);
--game mode entity with goal and try checks				
Mode : entity Mode(Behavioral)
	port map (PIXEL_CK => UCLK, BX => BX, BY => BY, 
				RX => RX, RY => RY, CK => MCLK,  
				CATHODES => CATHODES, ANODES => ANODES, TRIG => SET, TRIG2 => SET2,
				M1 => MASK4, M2 => MASK3);
--Set all RGB output with layer attribute	
RGB_OUT <= PL_RGB when MASK2 = '1' else
			RIM_RGB when MASK3 = '1' else
			BASK_RGB when	MASK5 = '1' else
			CIR_RGB when MASK = '1' else
			DET_RGB when MASK4 = '1' 
				else (OTHERS => '0');


		
end Behavioral;
