-- Greg Stitt
-- University of Florida

library ieee;
use ieee.std_logic_1164.all;

entity mux_2x1 is
  generic(width : positive := 32);
  port(
    in1    : in  std_logic_vector(width - 1 downto 0);
    in2    : in  std_logic_vector(width - 1 downto 0);
    sel    : in  std_logic;
    output : out std_logic_vector(width - 1 downto 0)
	);
end mux_2x1;

-- Concurrent statement examples. Concurrent statements are not part of a
-- process and are executed anytime one of their inputs changes.



architecture CASE_STATEMENT of mux_2x1 is
begin

  -- same guideline as before, make sure all inputs are in the sensitivy list

  process(in1, in2, sel)
  begin
    -- case statement is similar to the if, but only one case can be true.
    case sel is
      when '0'    =>
        output <= in1;
      when '1' =>
        output <= in2;
	  when others => null;
	  
    end case;

-- I sometimes do this also. The "null" for the others clause just specifies
-- that nothing should be done if sel isn't '0' or '1'. For synthesis, this
-- works fine because only '0' and '1' have a meaning.
-- case sel is
-- when '0' =>
-- output <= in1;
-- when '1' =>
-- output <= in2;
-- when others =>
-- null;
-- end case;
  end process;
end CASE_STATEMENT;
