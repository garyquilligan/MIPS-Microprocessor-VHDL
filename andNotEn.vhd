library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity andNotEN is
	port(
		input1 : in std_logic;
		input2 : in std_logic;
		output : out std_logic
	);
	
end andNotEN;

architecture BHV of andNotEn is


begin
	output <= input1 and not input2;

end BHV;