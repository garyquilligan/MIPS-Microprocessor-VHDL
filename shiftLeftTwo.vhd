library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shiftLeftTwo is
	generic(width : positive := 32);
	port(
		input 		: in std_logic_vector(width - 1 downto 0);
		output		: out std_logic_vector(width - 1 downto 0)
	);
end shiftLeftTwo;

architecture BHV of shiftLeftTwo is

begin

	output <= std_logic_vector(SHIFT_LEFT(unsigned(input),2));

end BHV;