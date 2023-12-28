LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
--use WORK.decoder.all;
entity ps2 is
	port( 	start,keyboard_clk, keyboard_data, clock_50MHz ,
			reset : in std_logic;--, read : in std_logic;
			--scan_code : out std_logic_vector( 7 downto 0 );
			--scan_readyo : out std_logic;
			--hist3 : out std_logic_vector(7 downto 0);
			--hist2 : out std_logic_vector(7 downto 0);
			--hist1 : out std_logic_vector(7 downto 0);
			--hist0 : out std_logic_vector(7 downto 0);
			outa: out integer;
			shota:out std_logic;
			outb: out integer;
			shotb:out std_logic
			--ledout1: out std_logic_vector(6 downto 0);
			--ledout2: out std_logic_vector(6 downto 0)
		);
end entity ps2;


architecture structural of ps2 is

component keyboard IS
	PORT( 	keyboard_clk, keyboard_data, clock_50MHz ,
			reset, read : IN STD_LOGIC;
			scan_code : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			scan_ready : OUT STD_LOGIC);
end component keyboard;

component oneshot is
port(
	pulse_out : out std_logic;
	trigger_in : in std_logic; 
	clk: in std_logic );
end component oneshot;

signal scan2 : std_logic;
signal scan_code2 : std_logic_vector( 7 downto 0 );
signal outas,outas_n:  integer;
signal outbs,outbs_n:  integer;
signal n_shotas,n_shotbs: std_logic;
signal history3 : std_logic_vector(7 downto 0);
signal history2 : std_logic_vector(7 downto 0);
signal history1 : std_logic_vector(7 downto 0);
signal history0 : std_logic_vector(7 downto 0);
signal flag,n_flag: std_logic;
signal read : std_logic;	

begin
-- show the current keyboard input 
--led1: leddcd port map ( data_in => scan_code2(3 downto 0), segments_out => ledout1);
--led2: leddcd port map ( data_in => scan_code2(7 downto 4), segments_out => ledout2);
u1: keyboard port map(	
				keyboard_clk => keyboard_clk,
				keyboard_data => keyboard_data,
				clock_50MHz => clock_50MHz,
				reset => reset,
				read => read,
				scan_code => scan_code2,
				scan_ready => scan2
			);

pulser: oneshot port map(
   pulse_out => read,
   trigger_in => scan2,
   clk => clock_50MHz
			);

--scan_readyo <= scan2;
--scan_code <= scan_code2;

--hist0<=history0;
--hist1<=history1;
--hist2<=history2;
--hist3<=history3;

a1 : process(scan2,outas_n,outbs_n,n_shotas,n_shotbs)
begin
	if(rising_edge(scan2)) then
		history3 <= history2;
		history2 <= history1;
		history1 <= history0;
		history0 <= scan_code2;
	end if;
	--outas<=outas_n;
	--outbs<=outbs_n;
end process a1;


-- process to examine the keyboard
check1:process(history0,clock_50MHz,reset) 
begin
--if start='1' then
	--outas_n<=outas;
	--outbs_n<=outbs;
	if reset='0' then
		n_shotas<='0';
		n_shotbs<='0';
		outas_n<=0;
		outbs_n<=0;
	elsif rising_edge(clock_50MHz) then
		--outas<="000"; --default
		--outbs_n<="000";
		case history0 is 
			when X"41" =>
			--if history2=X"41" then
				outas_n<=1; --speed1
			--end if;
			when X"49" =>
			--if history2=X"49"then
				outas_n<=2;--speed2
			--end if;
			when X"4A"=>
			--if history2=X"4A" then
				outas_n<=3;--speed3
			--end if;
			when X"59"=>
			--if history2=X"59" and history3= X"59" then
				n_shotas<='1';--shot
			--end if;
			when X"1A" =>
			--if history2=X"1A"  then
				outbs_n<=1; --speed1
			--end if;
			when X"22" =>
			--if history2=X"22"  then
				outbs_n<=2;--speed2
			--end if;
			when X"21"=>
			--if history2=X"21"  then
				outbs_n<=3;--speed3
			--end if;
			when X"12"=>
			--if history2=X"12" and history3= X"12"  then
				n_shotbs<='1';--shot
			when others=>	
					n_shotas<='0';
					n_shotbs<='0';
				--outas_n<=0; --default
				--outbs_n<=0;
		end case;
	end if;
end process check1;


outa<=outas_n;
outb<=outbs_n;
shota<=n_shotas;
shotb<=n_shotbs;
end architecture structural;