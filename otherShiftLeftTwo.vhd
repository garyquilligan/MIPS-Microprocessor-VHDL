library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity otherShiftLeftTwo is
	port(
		input 		: in std_logic_vector(25 downto 0);
		output		: out std_logic_vector(27 downto 0)
	);
end otherShiftLeftTwo;

architecture BHV of otherShiftLeftTwo is

begin

	process(input)
		variable temp : std_logic_vector(27 downto 0);
	begin
		temp := std_logic_vector(RESIZE(unsigned(input),28));
		output <= std_logic_vector(SHIFT_LEFT(unsigned(temp),2));
	end process;

end BHV;