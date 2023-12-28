library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pixelGenerator is
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
end entity pixelGenerator;

architecture behavioral of pixelGenerator is

constant color_red 	 	 : std_logic_vector(2 downto 0) := "000";
constant color_green	 : std_logic_vector(2 downto 0) := "001";
constant color_blue 	 : std_logic_vector(2 downto 0) := "010";
constant color_yellow 	 : std_logic_vector(2 downto 0) := "011";
constant color_magenta 	 : std_logic_vector(2 downto 0) := "100";
constant color_cyan 	 : std_logic_vector(2 downto 0) := "101";
constant color_black 	 : std_logic_vector(2 downto 0) := "110";
constant color_white	 : std_logic_vector(2 downto 0) := "111";
	
component colorROM is
	port
	(
		address		: in std_logic_vector (2 downto 0);
		clock		: in std_logic  := '1';
		q			: out std_logic_vector (29 downto 0)
	);
end component colorROM;
--------------------------------------------------------------------------------------------
component tank1 is 
port(
			clk, rst_n, start, shot			: in std_logic;
			spd							: in integer;
			tank_x, tank_y			: out integer
		);
end component tank1;
component tank2 is 
port(
			clk, rst_n, start, shot			: in std_logic;
			spd							: in integer;
			tank_x, tank_y			: out integer
		);
end component tank2;
component bullet1 is 
	port(
			clk, rst_n, start,shoot			: in std_logic;
			tank1_x, tank1_y,tank2_x,tank2_y		: in integer;
			bullet_x, bullet_y	: out integer;
			win: out std_logic;
			score:out std_logic_vector
		);
end component bullet1;
component bullet2 is 
	port(
			clk, rst_n, start,shoot			: in std_logic;
			tank1_x, tank1_y,tank2_x,tank2_y		: in integer;
			bullet_x, bullet_y	: out integer;
			win: out std_logic;
			score:out std_logic_vector
		);
end component bullet2;

-- component score1 is
-- 	port(
-- 			clk, rst_n, start, score, exist		: in std_logic;
-- 			win       :out std_logic
-- 		);
-- end component score1;
-- component score2 is
-- 	port(
-- 			clk, rst_n, start, score, exist		: in std_logic;
-- 			win       :out std_logic
-- 		);
-- end component score2;
--------------------------------------------------------------------------------------------
signal colorAddress : std_logic_vector (2 downto 0);
signal color        : std_logic_vector (29 downto 0);
signal pixel_row_int, pixel_column_int : natural;



--------------------------------------------------------------------------------------------
signal column_pos1, column_pos2 : integer;
signal row_pos1, row_pos2 : integer;
signal clk_cnt, move_cnt : integer;
signal pos_flag1, pos_flag2 : std_logic;
signal bullet1_col,bullet1_row,bullet2_col,bullet2_row:integer;
--signal exist1,exist2:std_logic;
signal wina,winb:std_logic;
--signal score_1,score_2: std_logic;
--------------------------------------------------------------------------------------------

begin

--------------------------------------------------------------------------------------------
	
	red_out <= color(29 downto 20);
	green_out <= color(19 downto 10);
	blue_out <= color(9 downto 0);

	pixel_row_int <= to_integer(unsigned(pixel_row));
	pixel_column_int <= to_integer(unsigned(pixel_column));
		win1<=wina;
		win2<=winb;
--------------------------------------------------------------------------------------------	
	
	colors : colorROM
		port map(colorAddress, ROM_clk, color);
		
	tank1_position : tank1
		port map(
			clk => clk,
			rst_n => rst_n,
			start=>start,
			shot => shta,
			spd=>spda,
			tank_x => column_pos1,
			tank_y => row_pos1
		);
	tank2_position : tank2
		port map(
			clk => clk,
			rst_n => rst_n,
			start=>start,
			shot => shtb,
			spd=>spdb,
			tank_x => column_pos2,
			tank_y => row_pos2
		);
	B1:bullet1
		port map(
			clk=>clk,
			rst_n=>rst_n,
			start=>start,
			shoot=>shta,
			tank1_x=>column_pos1 ,
			tank1_y=>row_pos1,
			tank2_x=>column_pos2,
			tank2_y=>row_pos2,
			bullet_x=>bullet1_col,
			bullet_y=>bullet1_row,
			win=>wina,
			score=>score1
		);
	B2:bullet2
		port map(
			clk=>clk,
			rst_n=>rst_n,
			start=>start,
			shoot=>shtb,
			tank1_x=>column_pos1 ,
			tank1_y=>row_pos1,
			tank2_x=>column_pos2,
			tank2_y=>row_pos2,
			bullet_x=>bullet2_col,
			bullet_y=>bullet2_row,
			win=>winb,
			score=>score2
		);
		
		-- S1: score1 
		-- port map(
		-- 		clk=>clk, 
		-- 		rst_n=>rst_n,
		-- 	start=>start, 
		-- 	score=>score_1,
		-- 	exist=>exist1,
		-- 	win => win1     
		-- 	);
		-- 	S2: score2 
		-- port map(
		-- 		clk=>clk, 
		-- 		rst_n=>rst_n,
		-- 	start=>start, 
		-- 	score=>score_2,
		-- 	exist=>exist2,
		-- 	win => win2     
		-- 	);
	
	

--------------------------------------------------------------------------------------------	

	pixelDraw : process(clk,rst_n) is
	
	begin
	
			
		if (rising_edge(clk)) then	
			
			if (pixel_row_int < row_pos2+40 and pixel_row_int > row_pos2 and pixel_column_int < column_pos2 + 80 and 
			pixel_column_int > column_pos2) then
				if wina='0' then
				colorAddress <= color_green;
				else
					colorAddress <= color_white;
				end if;
			elsif(pixel_row_int < bullet2_row+10 and pixel_row_int > bullet2_row-10 and 
				pixel_column_int<bullet2_col+10 and pixel_column_int>bullet2_col-10  ) then
					colorAddress <= color_green; 
				--------------------------------------------------------------------------------------------	
			elsif (pixel_row_int < row_pos1+40 and pixel_row_int > row_pos1 and 
			pixel_column_int<column_pos1 +80 and pixel_column_int>column_pos1) then
				if winb='0' then
					colorAddress <= color_red;
				else
					colorAddress <= color_white;
				end if;
			elsif (pixel_row_int < bullet1_row+10 and pixel_row_int > bullet1_row-10 and 
			pixel_column_int<bullet1_col+10 and pixel_column_int>bullet1_col-10) then
				colorAddress <= color_red;
			else 
				colorAddress <= color_white;
			end if;
			
		end if;
		
	end process pixelDraw;	

--------------------------------------------------------------------------------------------


end architecture behavioral;		