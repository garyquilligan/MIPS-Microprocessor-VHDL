library ieee;
use ieee.std_logic_1164.all;

entity mux_4x1 is
  generic(width : positive := 32);
  port(
    in0    : in  std_logic_vector(width - 1 downto 0);
    in1    : in  std_logic_vector(width - 1 downto 0);
	in2    : in  std_logic_vector(width - 1 downto 0);
	in3	   : in  std_logic_vector(width - 1 downto 0);
    sel    : in  std_logic_vector(1 downto 0);
    output : out  std_logic_vector(width - 1 downto 0)
	);
end mux_4x1;

architecture STR of mux_4x1 is
	signal mux1_out, mux2_out : std_logic_vector(width - 1 downto 0);
begin
	U_MUX1 : entity work.mux_2x1
	generic map(width => width)
	port map(
		in1 => in0,
		in2 => in1,
		sel => sel(0),
		output => mux1_out
	);
	U_MUX2 : entity work.mux_2x1
	generic map(width => width)
	port map(
		in1 => in2,
		in2 => in3,
		sel => sel(0),
		output => mux2_out
	);
	
	U_MUX3 : entity work.mux_2x1
	generic map(width => width)
	port map(
		in1 => mux1_out,
		in2 => mux2_out,
		sel => sel(1),
		output => output
	);
	
	
end STR;