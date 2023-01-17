library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity conCat is
	generic(width : positive := 32);
	port(
		input 		: in std_logic_vector(27 downto 0);
		PCTopFour	: in std_logic_vector(3 downto 0);
		output		: out std_logic_vector(width - 1 downto 0)
	);
end conCat;

architecture BHV of conCat is

begin

	process(input,PCTopFour)
		variable temp : unsigned(width - 1 downto 0);
	begin
		temp := unsigned(PCTopFour) & unsigned(input);
		output <= std_logic_vector(temp);
	end process;

end BHV;