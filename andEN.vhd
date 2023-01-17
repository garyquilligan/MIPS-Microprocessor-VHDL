library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity andEN is
	port(
		input1 : in std_logic;
		input2 : in std_logic;
		output : out std_logic
	);
	
end andEN;

architecture BHV of andEn is


begin
	output <= input1 and input2;

end BHV;