LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY game_tb IS
-- Testbench has no ports
END ENTITY game_tb;

ARCHITECTURE behavior OF game_tb IS 
	COMPONENT start_signal
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		start : OUT std_logic
	);
	END COMPONENT;
    -- Component Declarations
    COMPONENT tank1
        PORT(
            clk : IN std_logic;
            rst_n : IN std_logic;
            start : IN std_logic;
            shot : IN std_logic;
            spd : IN integer;
            tank_x : OUT integer;
            tank_y : OUT integer
        );
    END COMPONENT;

    COMPONENT tank2
        PORT(
			clk : IN std_logic;
            rst_n : IN std_logic;
            start : IN std_logic;
            shot : IN std_logic;
            spd : IN integer;
            tank_x : OUT integer;
            tank_y : OUT integer
        );
    END COMPONENT;

    COMPONENT bullet1
        PORT(
			clk, rst_n, start,shoot			: in std_logic;
			tank1_x, tank1_y,tank2_x,tank2_y		: in integer;
			bullet_x, bullet_y	: out integer;
			win: out std_logic;
			score: out std_logic_vector(3 downto 0)
        );
    END COMPONENT;

    COMPONENT bullet2
        PORT(
			clk, rst_n, start,shoot			: in std_logic;
			tank1_x, tank1_y,tank2_x,tank2_y		: in integer;
			bullet_x, bullet_y	: out integer;
			win: out std_logic;
			score: out std_logic_vector(3 downto 0)
        );
    END COMPONENT;

    -- Internal signals for interfacing with the components
    SIGNAL clk, rst_n, start, shota,shotb : std_logic := '0';
    SIGNAL spda,spdb : integer := 0;
    SIGNAL tank1_x, tank1_y, tank2_x, tank2_y : integer;
    SIGNAL bullet1_x, bullet1_y, bullet2_x, bullet2_y : integer;
    SIGNAL win1, win2 : std_logic;
    SIGNAL score1, score2 : std_logic_vector(3 downto 0);

    -- Clock period definition
    CONSTANT clk_period : TIME := 10 ns; -- Example clock period

BEGIN 
uut_start_signal: start_signal PORT MAP (
	clk => clk,
	rst => rst_n,
	start => start
);
   -- Instantiate tank1
uut_tank1: tank1 PORT MAP (
    clk => clk,
    rst_n => rst_n,
    start => start,
    shot => shota,
    spd => spda,
    tank_x => tank1_x,
    tank_y => tank1_y
);

-- Instantiate tank2
uut_tank2: tank2 PORT MAP (
    clk => clk,
    rst_n => rst_n,
    start => start,
    shot => shotb,
    spd => spdb,
    tank_x => tank2_x,
    tank_y => tank2_y
);

-- Instantiate bullet1
uut_bullet1: bullet1 PORT MAP (
    clk => clk,
    rst_n => rst_n,
    start => start,
    shoot => shota,
    tank1_x => tank1_x,
    tank1_y => tank1_y,
    tank2_x => tank2_x,
    tank2_y => tank2_y,
    bullet_x => bullet1_x,
    bullet_y => bullet1_y,
    win => win1,
    score => score1
);

-- Instantiate bullet2
uut_bullet2: bullet2 PORT MAP (
    clk => clk,
    rst_n => rst_n,
    start => start,
    shoot => shotb,
    tank1_x => tank1_x,
    tank1_y => tank1_y,
    tank2_x => tank2_x,
    tank2_y => tank2_y,
    bullet_x => bullet2_x,
    bullet_y => bullet2_y,
    win => win2,
    score => score2
);


    -- Clock process
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period/2;
        clk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS clk_process;

    -- Test stimulus process
    stim_proc: PROCESS
    BEGIN
        -- Initialize Inputs
        rst_n <= '0';
        WAIT FOR 100 ns;  -- Reset period
        rst_n <= '1';
        spda<=4;
        spdb<=4;
        shota<='1';
        shotb<='1';
        -- Add further stimulus here
        WAIT; -- Will wait forever
    END PROCESS stim_proc;


END ARCHITECTURE behavior;
