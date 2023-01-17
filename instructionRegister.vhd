library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity instructionRegister is
	generic(width : positive := 32);
	port(
		clk		: in std_logic;
		rst		: in std_logic;
		IRWrite : in std_logic;
		input 	: in std_logic_vector(width - 1 downto 0);
		OPcode	: out std_logic_vector(5 downto 0);
		rs		: out std_logic_vector(4 downto 0);
		rt		: out std_logic_vector(4 downto 0);
		rd		: out std_logic_vector(4 downto 0);
		offset	: out std_logic_vector(15 downto 0);
		twoFive	: out std_logic_vector(25 downto 0)
	);
end instructionRegister;

architecture BHV of instructionRegister is 

begin

	process(clk,rst)
	begin
	if(rst = '1') then
		OPcode <= (others => '0');	
		rs <= (others => '0');	
		rt <= (others => '0');		
		rd <= (others => '0');		
		offset <= (others => '0');	
		twoFive <= (others => '0');	
	elsif(rising_edge(clk)) then
		if(IRWrite = '1') then
			OPcode <= input(31 downto 26);	
			rs <= input(25 downto 21);	
			rt <= input(20 downto 16);		
			rd <= input(15 downto 11);		
			offset <= input(15 downto 0);	
			twoFive <= input(25 downto 0);
		end if;
	end if;
	end process;
end BHV;