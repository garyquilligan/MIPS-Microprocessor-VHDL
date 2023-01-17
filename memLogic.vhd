library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memLogic is
	generic(width : positive := 32);
	port(
		addr			: in std_logic_vector(31 downto 0);
		memWrite		: in std_logic;
		outPortWrEn		: out std_logic;
		ramWrEn			: out std_logic;
		rdDataSel		: out std_logic_vector(1 downto 0)
	);
	
end memLogic;

architecture BHV of memLogic is
	
begin
	process(addr,memWrite)
	begin
	rdDataSel <= "11";
	if(memWrite = '0') then
		outPortWrEn <= '0';
		ramWrEn <= '0';
		if(addr >= x"00000000" and addr <= x"000003FF") then
			rdDataSel <= "10";
		elsif(addr = x"0000FFF8") then
			rdDataSel <= "00";
		elsif(addr = x"0000FFFC") then
			rdDataSel <= "01";
		end if;
	else
		if(addr >= x"00000000" and addr <= x"000003FF") then
			ramWrEn <= '1';
			outPortWrEn <= '0';
		elsif(addr = x"0000FFFC") then
			outPortWrEn <= '1';
			ramWrEn <= '0';
		end if;
	end if;
	end process;
end BHV;