library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--red bullet
entity bullet1 is
	port(
			clk, rst_n, start,shoot			: in std_logic;
			tank1_x, tank1_y,tank2_x,tank2_y		: in integer;
			bullet_x, bullet_y	: out integer;
			win: out std_logic;
			score: out std_logic_vector(3 downto 0)
		);
end entity bullet1;

architecture behavioral of bullet1 is

--signal tank1_x_int, tank1_y_int : integer;
signal bullet_x_int, bullet_y_int, n_bullet_x_int, n_bullet_y_int: integer;
--signal eflag, n_eflag : std_logic;


type state is (IDLE, LOAD, APPEAR, HIT, FINISH,WINA);
signal c_state, n_state : state;
signal exist,n_exist : std_logic;
signal cnt,n_cnt: integer;
begin
bullet_x<=bullet_x_int;
bullet_y<=bullet_y_int;
--------------------------------------------------------------------------------------------
	--tank1_x_int <= to_integer(unsigned(tank1_x));
	--tank1_y_int <= to_integer(unsigned(tank1_y));
--------------------------------------------------------------------------------------------
	process(clk, rst_n) is
	begin
		if (rst_n = '0') then
			c_state <= IDLE;
			--eflag <= '0';
			bullet_x_int <= -10;
			bullet_y_int <= -10;
			exist<='0';
			cnt<=0;
			--win<='0';
			
		elsif (rising_edge(clk)) then
			c_state <= n_state; 
			--eflag <= n_eflag;
			bullet_x_int <= n_bullet_x_int;
			bullet_y_int <= n_bullet_y_int;
			exist<=n_exist;
			cnt<=n_cnt;
		end if;
	end process;
--------------------------------------------------------------------------------------------
	process(c_state,bullet_x_int,bullet_y_int,shoot,start,exist,cnt,tank1_y,tank1_x,tank2_y,tank2_x) is
	begin
	
	n_state <= c_state;
	--n_eflag <= eflag;
	n_bullet_x_int <= bullet_x_int;
	n_bullet_y_int <= bullet_y_int;
	n_exist<=exist;
	n_cnt<=cnt;
	

	case c_state is
		when IDLE =>
		if start='1' then
			if cnt=3 then
				n_state<=WINA;		
			elsif exist='0' then
				if(shoot = '1')then
					n_exist<='1';
					n_state <= LOAD;		
				end if;
			elsif exist='1' then
				n_state<=APPEAR;
			end if;
		end if;
		win<='0';
		when LOAD =>
			n_bullet_y_int <= tank1_y+43;
			n_bullet_x_int<= tank1_x+40;
			n_exist<='1';
			n_state <= APPEAR;
		win<='0';			
		when APPEAR =>
			n_bullet_y_int <= bullet_y_int + 20;
			n_exist<='1';
			if (bullet_y_int + 10 >= tank2_y-40) then
				if (bullet_x_int + 10 >= tank2_x) and (bullet_x_int - 10 <=  tank2_x + 80)  then
					n_state<=HIT;
				elsif (bullet_y_int>=480) then
					n_state<=FINISH;
				else 
					n_state<=IDLE;
				end if;
			else
				n_state<=IDLE;
			end if;
		win<='0';
		when FINISH=>
			n_bullet_x_int <= -10;
			n_bullet_y_int <= -10;
			n_exist<='0';
			--score<='0';
			n_state<=IDLE;
			win<='0';
		when HIT=>
			n_bullet_x_int <= -10;
			n_bullet_y_int <= -10;
			n_exist<='0';
			n_cnt<=cnt+1;
			n_state<=IDLE;
			win<='0';
		when WINA=>
			win<='1';
		when others=>
			n_bullet_x_int <= -10;
			n_bullet_y_int <= -10;
			n_exist<='0';
			--score<='0';
			n_cnt<=0;
			n_state<=IDLE;
			win<='0';
	end case;

	end process;
	--e<=exist;
	score<=std_logic_vector(to_unsigned(cnt,4));
end architecture;