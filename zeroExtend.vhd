library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity zeroExtend is
	port(
		input : in std_logic_vector(9 downto 0);
		output : out std_logic_vector(31 downto 0)
	);
end zeroExtend;

architecture BHV of zeroExtend is
begin
	output <= std_logic_vector(resize(unsigned(input),32));
end BHV;