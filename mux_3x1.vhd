library ieee;
use ieee.std_logic_1164.all;

entity mux_3x1 is
  generic(width : positive := 32);
  port(
    in0    : in  std_logic_vector(width - 1 downto 0);
    in1    : in  std_logic_vector(width - 1 downto 0);
	in2    : in  std_logic_vector(width - 1 downto 0);
    sel    : in  std_logic_vector(1 downto 0);
    output : out  std_logic_vector(width - 1 downto 0)
	);
end mux_3x1;

architecture STR of mux_3x1 is
	signal mux_out : std_logic_vector(width - 1 downto 0);
begin
	U_MUX1 : entity work.mux_2x1
	generic map(width => width)
	port map(
		in1 => in0,
		in2 => in1,
		sel => sel(0),
		output => mux_out
	);
	U_MUX2 : entity work.mux_2x1
	generic map(width => width)
	port map(
		in1 => mux_out,
		in2 => in2,
		sel => sel(1),
		output => output
	);
	
end STR;