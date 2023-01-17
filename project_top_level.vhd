library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity project_top_level is
	port(
		clk 	 : in  std_logic;
		rst 	 : in  std_logic;
        switch   : in  std_logic_vector(9 downto 0);
        button   : in  std_logic;
        led0     : out std_logic_vector(6 downto 0);
        led0_dp  : out std_logic;
        led1     : out std_logic_vector(6 downto 0);
        led1_dp  : out std_logic;
        led2     : out std_logic_vector(6 downto 0);
        led2_dp  : out std_logic;
        led3     : out std_logic_vector(6 downto 0);
        led3_dp  : out std_logic;
        led4     : out std_logic_vector(6 downto 0);
        led4_dp  : out std_logic;
        led5     : out std_logic_vector(6 downto 0);
        led5_dp  : out std_logic
	);
	
end project_top_level;

architecture STR of project_top_level is

	constant width : positive := 32;
	signal outportOut : std_logic_vector(width - 1 downto 0);
	signal notRST : std_logic := not rst;
	signal notbutton : std_logic := not button;
begin

	U_project_fsm_d : entity work.project_FSM_D
	generic map(width => width)
	port map(
		clk 		=> clk,
		switches 	=> switch,
		rst 		=> notRST,
		button 		=> notbutton,
		outport 	=> outportOut
	);
	
	U_LED5 : entity work.decoder7seg
	port map(
		input => outportOut(23 downto 20),
		output => led5
	);
	
	U_LED4 : entity work.decoder7seg
	port map(
		input => outportOut(19 downto 16),
		output => led4
	);
	
	U_LED3 : entity work.decoder7seg
	port map(
		input => outportOut(15 downto 12),
		output => led3
	);
	
	U_LED2 : entity work.decoder7seg
	port map(
		input => outportOut(11 downto 8),
		output => led2
	);
	
	U_LED1 : entity work.decoder7seg
	port map(
		input => outportOut(7 downto 4),
		output => led1
	);
	
	U_LED0 : entity work.decoder7seg
	port map(
		input => outportOut(3 downto 0),
		output => led0
	);

end STR;