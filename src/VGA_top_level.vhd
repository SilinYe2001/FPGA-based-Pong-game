library IEEE;

use IEEE.std_logic_1164.all;

entity VGA_top_level is
	port(
			CLOCK_50 										: in std_logic;
			RESET_N											: in std_logic;
	
			--VGA 
			VGA_RED, VGA_GREEN, VGA_BLUE 					: out std_logic_vector(9 downto 0); 
			HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK		: out std_logic;
			
			--keyboard
			keyboard_clk, keyboard_data : in std_logic;
			LCD_RS, LCD_E, LCD_ON, RESET_LED, SEC_LED		: OUT	STD_LOGIC;
			LCD_RW						: BUFFER STD_LOGIC;
			DATA_BUS				: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
			score_display1		: out std_logic_vector(6 downto 0);
			score_display2		: out std_logic_vector(6 downto 0)
		);
end entity VGA_top_level;

architecture structural of VGA_top_level is
--------------------------------------------------------------------------------------------
component ps2 is 
--player 1:  leftshift for shot,  z x c for speed
--player 2:  rightshift for shot,  , . /  for speed
	port( 	start,keyboard_clk, keyboard_data, clock_50MHz ,
			reset : in std_logic;--, read : in std_logic;
			outa: out integer;
			shota:out std_logic;
			outb: out integer;
			shotb:out std_logic
			-- speed 1:1, speed 2: 2, speed3:3
			--shot: '1', no shot: '0'
		);
		
end component ps2;
component pixelGenerator is
	port(
			start													:in std_logic;
			clk, ROM_clk, rst_n, video_on, eof 				: in std_logic;
			pixel_row, pixel_column						    : in std_logic_vector(9 downto 0);
			spda,spdb											: in integer;
			shta,shtb											: in std_logic;
			win1,win2 										: out std_logic;
			score1,score2									:out std_logic_vector(3 downto 0);
			red_out, green_out, blue_out					: out std_logic_vector(9 downto 0)
		);
end component pixelGenerator;
component de2lcd IS
	PORT(reset, clk_50Mhz				: IN	STD_LOGIC;
			winA, winB						: in std_logic;
		 LCD_RS, LCD_E, LCD_ON, RESET_LED, SEC_LED		: OUT	STD_LOGIC;
		 LCD_RW						: BUFFER STD_LOGIC;
		 DATA_BUS				: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0));
END component de2lcd;
component start_signal is
    port ( 
        clk: in std_logic;
        rst: in std_logic;
        start: out std_logic
    );
end component start_signal;
COMPONENT leddcd is
PORT(data_in 	 : in std_logic_vector(3 downto 0);
	segments_out : out std_logic_vector(6 downto 0)); -- enter the port declaration of your led decoder here
end COMPONENT;


component PLL IS
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC 
	);
END component;
--------------------------------------------------------------------------------------------

component VGA_SYNC is
	port(
			clock_50Mhz										: in std_logic;
			horiz_sync_out, vert_sync_out, 
			video_on, pixel_clock, eof						: out std_logic;												
			pixel_row, pixel_column						    : out std_logic_vector(9 downto 0)
		);
end component VGA_SYNC;

--Signals for VGA sync
signal pixel_row_int 										: std_logic_vector(9 downto 0);
signal pixel_column_int 									: std_logic_vector(9 downto 0);
signal video_on_int											: std_logic;
signal VGA_clk_int											: std_logic;
signal eof														: std_logic;
--------------------------------------------------------------------------------------------
--keyboard
signal outa,outb												: integer; -- tank speed
signal shota,shotb											:std_logic;-- shooting signal
--start clock
signal start													:std_logic;
signal score1,score2			:std_logic_vector(3 downto 0); 
signal win1,win2: std_logic; 
signal CLOCK_100:std_logic; 
signal RESET_Y:std_logic;
--------------------------------------------------------------------------------------------
begin

-- generate start pulse
	pulse: start_signal
		port map(CLOCK_100,RESET_N,start);
-- draw tanks and bullets
	videoGen : pixelGenerator
		port map(start,CLOCK_50, VGA_clk_int, RESET_N, video_on_int, eof, pixel_row_int,
		pixel_column_int,outa,outb,shota,shotb,win1,win2,score1,score2,VGA_RED, VGA_GREEN, VGA_BLUE);
		
-- display win		
	delcd: de2lcd 
	PORT map( RESET_N,
	CLOCK_50,			
		win1,
		win2,					
		 LCD_RS, LCD_E, LCD_ON, RESET_LED, SEC_LED,
		 LCD_RW,
		 DATA_BUS);
--input speed and shoot
	
	keyboard: ps2
		port map(start,keyboard_clk, keyboard_data,CLOCK_50,RESET_N,outa,shota,outb,shotb);
-- LED display the score
	LED1: leddcd
		port map(score1,score_display1);
	LED2: leddcd
		port map(score2,score_display2);
	PLL1: PLL
		port map(RESET_Y,CLOCK_50,CLOCK_100);
	RESET_Y<=not RESET_N;
--------------------------------------------------------------------------------------------
--This section should not be modified in your design.  This section handles the VGA timing signals
--and outputs the current row and column.  You will need to redesign the pixelGenerator to choose
--the color value to output based on the current position.

	videoSync : VGA_SYNC
		port map(CLOCK_50, HORIZ_SYNC, VERT_SYNC, video_on_int, VGA_clk_int, eof, pixel_row_int, pixel_column_int);

	VGA_BLANK <= video_on_int;

	VGA_CLK <= VGA_clk_int;

--------------------------------------------------------------------------------------------	

end architecture structural;