library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--green tank
entity tank2 is
	port(
			clk, rst_n, start, shot			: in std_logic;
			spd							: in integer;
			tank_x, tank_y			: out integer
		);
end entity tank2;
architecture behavioral of tank2 is

    type T_State is (IDLE, MOVE_F, MOVE_B);
		signal state,n_state : T_State;
		signal column_pos,n_column_pos: integer;
		--signal clk_cnt, move_cnt : integer;
		signal pos_flag ,n_pos_flag: std_logic;
begin

tank_y <= 440;
tank_x<=column_pos;   
statechange: process(state,start,column_pos,pos_flag,spd)
begin
    n_column_pos<=column_pos;
    n_pos_flag<=pos_flag;
    n_state<=state;

    case state is
        when IDLE =>

			if start='1' then
						if column_pos>=560 then
							  n_pos_flag <= '1';
						 elsif column_pos<=0 then
							  n_pos_flag<='0';
						 end if;
						if pos_flag='0' then
								n_state<=MOVE_F;
						  else
								n_state<=MOVE_B;
						  end if ;
			end if;
        when MOVE_F =>
             n_column_pos<=column_pos+spd*5;
				 n_state<=IDLE;

        when MOVE_B =>
             n_column_pos<=column_pos-spd*5;
				 n_state<=IDLE;
        when others =>
                n_state<=IDLE;
    end case;
end process statechange;

clock:process(clk, rst_n) is
	
begin
	if rst_n='0' then
		column_pos<=0;
		pos_flag<='0';
		 state<=IDLE;
	elsif (rising_edge(clk)) then
		 --value update
		 pos_flag<=n_pos_flag;
		 column_pos<=n_column_pos;
		 state<=n_state;
	end if;
end process clock;

end architecture behavioral;