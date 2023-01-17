library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signExtend is
	port(
		input 		: in std_logic_vector(15 downto 0);
		isSigned 	: in std_logic;
		output		: out std_logic_vector(31 downto 0)
	);
end signExtend;

architecture BHV of signExtend is


begin

	process(input,isSigned)
		variable temp : signed(15 downto 0);
	begin
		if(isSigned = '1')then
			temp := signed(input);
			output <= std_logic_vector(resize(temp,32));
		else
			output <= std_logic_vector(resize(unsigned(input),32));
		end if;
	end process;


end BHV;