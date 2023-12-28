library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  -- Prefer NUMERIC_STD over STD_LOGIC_ARITH and STD_LOGIC_UNSIGNED

entity start_signal is
    port ( 
        clk: in std_logic;
        rst: in std_logic;
        start: out std_logic
    );
end entity start_signal;

architecture behavioral of start_signal is
     -- Use 'unsigned' instead of 'std_logic_vector' for arithmetic operations
begin
    clock_process : process(clk, rst)
	 variable clock_counter: std_logic_vector(1 downto 0); 
    begin
        if rst = '0' then  -- Assuming active-low reset
            clock_counter := std_logic_vector(to_unsigned(0,clock_counter'length));
            start <= '0';  -- Reset the start signal as well
        elsif rising_edge(clk) then
            clock_counter := std_logic_vector(unsigned(clock_counter) + to_unsigned(1,clock_counter'length));  -- Simplified increment of unsigned type
            if clock_counter =std_logic_vector(to_unsigned(0,clock_counter'length)) then  -- Simplified comparison
                start <= '1';
            else
                start <= '0';
            end if;
        end if;
    end process clock_process;

end architecture behavioral;
