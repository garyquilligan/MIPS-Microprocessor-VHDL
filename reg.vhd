library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
	generic(width : positive := 32);
	port(
		input : in std_logic_vector(width-1 downto 0);
		clk   : in std_logic;
		rst   : in std_logic;
		enable : in std_logic;
		output : out std_logic_vector(width-1 downto 0)
		);
end reg;

architecture BHV of reg is
begin
	process(rst,clk)
	begin
		if(rst = '1')then
			output <= (others => '0');
		elsif(rising_edge(clk))then
			if(enable = '1')then
				output <= input;
			end if;
		end if;
	end process;
end BHV;