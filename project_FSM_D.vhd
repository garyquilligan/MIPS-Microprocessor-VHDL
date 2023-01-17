library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity project_FSM_D is
	generic(width : positive := 32);
	port(
		clk : in std_logic;
		switches : in std_logic_vector(9 downto 0);
		rst : in std_logic;
		button : in std_logic;
		outport : out std_logic_vector(width - 1 downto 0)
	);
	
end project_FSM_D;


architecture STR of project_FSM_D is
	
	signal branchTaken, pcPlusEnable : std_logic;
	signal opCode, fiveDown		: std_logic_vector(5 downto 0);
	signal PCWrite, IorD, MemWrite, IRWrite, JumpAndLink, isSigned, ALUSrcA, RegWrite, RegDst : std_logic;
	signal PCSource, ALUOp, ALUSrcB, MemToReg : std_logic_vector(1 downto 0);
	
begin

	U_project_controller : entity work.project_controller
	port map(
		clk 		=> clk,
		rst 		=> rst,
		opCode 		=> opCode,
		branchTaken => branchTaken,
		pcPlusEnable => pcPlusEnable,
		PCWrite 	=> PCWrite,
		IorD 		=> IorD,
		MemWrite 	=> MemWrite,
		MemToReg 	=> MemToReg,
		IRWrite 	=> IRWrite,
		JumpAndLink => JumpAndLink,
		isSigned 	=> isSigned,
		PCSource 	=> PCSource,
		ALUOp 		=> ALUOp,
		ALUSrcB 	=> ALUSrcB,
		ALUSrcA 	=> ALUSrcA,
		RegWrite 	=> RegWrite,
		fiveDown    => fiveDown,
		RegDst 		=> RegDst
	);
	
	U_project_datapath : entity work.project_datapath
	generic map(width => width)
	port map(
		clk			=> clk,
		rst			=> rst,
		PCWrite 	=> PCWrite,
		Button		=> button,
		Switches	=> switches,
		pcPlusEnable => pcPlusEnable,
		outport		=> outport,
		IorD		=> IorD,
		MemWrite	=> MemWrite,
		MemToReg	=> MemToReg,
		IRWrite		=> IRWrite,
		JumpAndLink	=> JumpAndLink,
		isSigned	=> isSigned,
		PCSource	=> PCSource,
		ALUOp		=> ALUOp,
		ALUSrcB		=> ALUSrcB,
		ALUSrcA		=> ALUSrcA,
		RegWrite	=> RegWrite,
		RegDst		=> RegDst,
		OpCode		=> opCode,
		fiveDown	=> fiveDown,
		branchTaken	=> branchTaken
	);

end STR;