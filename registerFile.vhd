library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity registerFile is
	generic(width : positive := 32);
	port(
		clk				: in std_logic;
		rst				: in std_logic;
		regWrite		: in std_logic;
		jumpAndLink		: in std_logic;
		readReg1		: in std_logic_vector(4 downto 0);
		readReg2		: in std_logic_vector(4 downto 0);
		writeRegister	: in std_logic_vector(4 downto 0);
		writeData		: in std_logic_vector(width - 1 downto 0);
		readData1		: out std_logic_vector(width - 1 downto 0);
		readData2		: out std_logic_vector(width - 1 downto 0)
	);
end registerFile;

architecture BHV of registerFile is

	type reg_Array is array(0 to width - 1) of std_logic_vector(width - 1 downto 0);
	signal regs : reg_Array;
	
begin

	process(clk,rst)
	begin
		if(rst = '1')then
			for i in regs'range loop
				regs(i) <= (others => '0');
			end loop;
		elsif(rising_edge(clk))then
			if(regWrite = '1')then
				if(jumpAndLink = '1')then
					regs(width - 1) <= writeData;
				else
					regs(to_integer(unsigned(writeRegister))) <= writeData;
				end if;
			end if;
		end if;
	end process;
	
	readData1 <= regs(to_integer(unsigned(readReg1)));
	readData2 <= regs(to_integer(unsigned(readReg2)));

end BHV;