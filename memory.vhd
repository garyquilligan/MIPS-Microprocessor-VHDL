library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
	generic(width : positive := 32);
	port(
		clk				: in std_logic;
		rst				: in std_logic;
		addr			: in std_logic_vector(width - 1 downto 0);
		memWrite		: in std_logic;
		switchData		: in std_logic_vector(width - 1 downto 0);
		wrData			: in std_logic_vector(width - 1 downto 0);
		inport0En		: in std_logic;
		inport1En		: in std_logic;
		outPortOut		: out std_logic_vector(width - 1 downto 0);
		rdData			: out std_logic_vector(width - 1 downto 0)
	);
	
end memory;

architecture STR of memory is
	constant selWidth : positive := 2;
	signal logicSel, selRegSel : std_logic_vector(1 downto 0);
	signal outPortEn, wrEn : std_logic;
	signal inPort0Out, inPort1Out, ramOut : std_logic_vector(width - 1 downto 0);
	signal inportRst : std_logic := '0';
	signal keepEnOn : std_logic := '1';
begin
	U_Inport0 : entity work.reg
	generic map(width => width)
	port map(
		input  => switchData,
		clk    => clk,
		rst    => inportRst,
		enable => inport0En,
		output => inPort0Out
	);
	
	U_Inport1 : entity work.reg
	generic map(width => width)
	port map(
		input  => switchData,
		clk    => clk,
		rst    => inportRst,
		enable => inport1En,
		output => inPort1Out
	);
	
	U_Outport : entity work.reg
	generic map(width => width)
	port map(
		input  => wrData,
		clk    => clk,
		rst    => rst,
		enable => outPortEn,
		output => outPortOut
	);
	
	U_SelReg : entity work.reg
	generic map(width => selWidth)
	port map(
		input  => logicSel,
		clk    => clk,
		rst    => rst,
		enable => keepEnOn,
		output => selRegSel
	);
	
	U_MemLogic : entity work.memLogic
	generic map(width => width)
	port map(
		addr			=> addr,
		memWrite		=> memWrite,
		outPortWrEn		=> outPortEn,
		ramWrEn			=> wrEn,
		rdDataSel		=> logicSel
	);
	
	U_RAM : entity work.TestCase1_ram
	port map(
		address		=> addr(9 downto 2),
		clock		=> clk,
		data		=> wrData,
		wren		=> wrEn,
		q			=> ramOut
	);
	
	U_Mux_3x1 : entity work.mux_3x1
	port map(
		in0    => inPort0Out,
		in1    => inPort1Out,
		in2    => ramOut,
		sel    => selRegSel,
		output => rdData
	);


end STR;