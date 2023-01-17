library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity project_datapath is
	generic(width : positive := 32);
	port(
		clk			: in std_logic;
		rst			: in std_logic;
		PCWrite 	: in std_logic;
		Button		: in std_logic;
		Switches	: in std_logic_vector(9 downto 0);
		outport		: out std_logic_vector(width - 1 downto 0);
		IorD		: in std_logic;
		MemWrite	: in std_logic;
		MemToReg	: in std_logic_vector(1 downto 0);
		IRWrite		: in std_logic;
		JumpAndLink	: in std_logic;
		isSigned	: in std_logic;
		PCSource	: in std_logic_vector(1 downto 0);
		ALUOp		: in std_logic_vector(1 downto 0);
		ALUSrcB		: in std_logic_vector(1 downto 0);
		ALUSrcA		: in std_logic;
		RegWrite	: in std_logic;
		RegDst		: in std_logic;
		pcPlusEnable : in std_logic;
		OpCode		: out std_logic_vector(5 downto 0);
		fiveDown	: out std_logic_vector(5 downto 0);
		branchTaken	: out std_logic
	);

end project_datapath;


architecture STR of project_datapath is
	constant widthFour : positive := 5;
	constant widthForLOHI : positive := 2;
	signal four : std_logic_vector(31 downto 0) := x"00000004";
	signal inport, PCaddr, progCounter, ALUOut, memOptionOut, wrData,memOut,ALUMuxOut, memDataRegOut : std_logic_vector(width - 1 downto 0);
	signal memToRegOut,readData1,readData2, signExtended, slTwoA, regAOut, srcA, srcB, concatOut : std_logic_vector(width - 1 downto 0);
	signal result, resultHi, LO_out, HI_out : std_logic_vector(width - 1 downto 0);
	signal rs, rt, rd, regDstMuxOut : std_logic_vector(4 downto 0);
	signal opSel : std_logic_vector(4 downto 0);
	signal offset	  : std_logic_vector(15 downto 0);
	signal instr_index : std_logic_vector(25 downto 0);
	signal keepEnOn : std_logic := '1';
	signal HI_en, LO_en : std_logic;
	signal ALU_LO_HI : std_logic_vector(1 downto 0);
	signal ALU_LO_HI_registered : std_logic_vector(1 downto 0);
	signal opIntoALCON : std_logic_vector(5 downto 0);
	signal slTwoB : std_logic_vector(27 downto 0);
	signal pcPlusFour : std_logic_vector(width - 1 downto 0);
	signal inport0, inport1 : std_logic;
	
begin

	U_zeroExtend : entity work.zeroExtend
	port map(
		input  => Switches,
		output => inport
	);
	
	U_PC : entity work.reg
	generic map(width => width)
	port map(
		input  => PCaddr,
		clk    => clk,
		rst    => rst,
		enable => PCWrite,
		output => progCounter
	);
	
	U_MemOptionMux : entity work.mux_2x1
	generic map(width => width)
	port map(
		in1    => progCounter,
		in2    => ALUOut,
		sel    => IorD,
		output => memOptionOut
	);
	
	U_inport0En : entity work.andNotEn
	port map(
		input1 => Button,
		input2 => Switches(9),
		output => inport0
	);
	
	U_inport1En : entity work.andEn
	port map(
		input1 => Button,
		input2 => Switches(9),
		output => inport1
	);
	
	U_Memory : entity work.memory
	generic map(width => width)
	port map(
		clk				=> clk,
		rst				=> rst,
		addr			=> memOptionOut,
		memWrite		=> MemWrite,
		switchData		=> inport,
		wrData			=> wrData,
		inport0En		=> inport0,
		inport1En		=> inport1,
		outPortOut		=> outport,
		rdData			=> memOut
	);
	
	U_instructionRegister : entity work.instructionRegister
	generic map(width => width)
	port map(
		clk		=> clk,
		rst		=> rst,
		IRWrite => IRWrite,
		input 	=> memOut,
		OPcode	=> opIntoALCON,
		rs		=> rs,
		rt		=> rt,
		rd		=> rd,
		offset	=> offset,
		twoFive	=> instr_index
	);
	
	U_memoryDataRegister : entity work.reg
	generic map(width => width)
	port map(
		input  => memOut,
		clk    => clk,
		rst    => rst,
		enable => keepEnOn,
		output => memDataRegOut
	);
	
	U_RegDestMux : entity work.mux_2x1
	generic map(width => widthFour)
	port map(
		in1    => rt,
		in2    => rd,
		sel    => RegDst,
		output => regDstMuxOut
	);
	
	
	U_memToRegMux : entity work.mux_3x1
	generic map(width => width)
	port map(
		in0    => ALUMuxOut,
		in1    => memDataRegOut,
		in2    => pcPlusFour,
		sel    => MemToReg,
		output => memToRegOut
	);
	
	U_registerFile : entity work.registerFile
	generic map(width => width)
	port map(
		clk				=> clk,
		rst				=> rst,
		regWrite		=> RegWrite,
		jumpAndLink		=> JumpAndLink,
		readReg1		=> rs,
		readReg2		=> rt,
		writeRegister	=> regDstMuxOut,
		writeData		=> memToRegOut,
		readData1		=> readData1,
		readData2		=> readData2
	);
	
	U_signExtend : entity work.signExtend
	port map(
		input 		=> offset,
		isSigned 	=> isSigned,
		output		=> signExtended
	);
	
	U_SLTwoA : entity work.shiftLeftTwo
	generic map(width => width)
	port map(
		input 		=> signExtended,
		output		=> slTwoA
	);
	
	U_regA : entity work.reg
	generic map(width => width)
	port map(
		input  => readData1,
		clk    => clk,
		rst    => rst,
		enable => keepEnOn,
		output => regAOut
	);
	
	U_regB : entity work.reg
	generic map(width => width)
	port map(
		input  => readData2,
		clk    => clk,
		rst    => rst,
		enable => keepEnOn,
		output => wrData
	);
	
	U_ALUSrcAMux : entity work.mux_2x1
	generic map(width => width)
	port map(
		in1    => progCounter,
		in2    => regAOut,
		sel    => ALUSrcA,
		output => srcA
	);
	
	U_ALUSrcBMux : entity work.mux_4x1
	generic map(width => width)
	port map(
		in0    => wrData,
		in1    => four,
		in2    => signExtended,
		in3	   => slTwoA,
		sel    => ALUSrcB,
		output => srcB
	);
	
	U_SLTwoB : entity work.otherShiftLeftTwo
	port map(
		input 		=> instr_index,
		output		=> slTwoB
	);
	
	U_concat : entity work.conCat
	generic map(width => width)
	port map(
		input 		=> slTwoB,
		PCTopFour	=> progCounter(31 downto 28),
		output		=> concatOut
	);
	
	U_ALU : entity work.alu
	generic map(width => width)
	port map(
		input1 			=> srcA,
		input2 			=> srcB,
		shiftAmount 	=> offset(10 downto 6),
		opSel			=> opSel,
		branchTaken 	=> branchTaken,
		result			=> result,
		resultHi		=> resultHi
	);
	
	U_PCSourceMux : entity work.mux_3x1
	generic map(width => width)
	port map(
		in0    => result,
		in1    => ALUOut,
		in2    => concatOut,
		sel    => PCSource,
		output => PCaddr
	);
	
	U_ALUOutReg : entity work.reg
	generic map(width => width)
	port map(
		input  => result,
		clk    => clk,
		rst    => rst,
		enable => keepEnOn,
		output => ALUOut
	);
	
	U_LOReg : entity work.reg
	generic map(width => width)
	port map(
		input  => result,
		clk    => clk,
		rst    => rst,
		enable => LO_en,
		output => LO_out
	);
	
	U_HIReg : entity work.reg
	generic map(width => width)
	port map(
		input  => resultHi,
		clk    => clk,
		rst    => rst,
		enable => HI_en,
		output => HI_out
	);
	
	U_ALU_LO_HI_MUX : entity work.mux_3x1
	generic map(width => width)
	port map(
		in0    => ALUOut,
		in1    => LO_out,
		in2    => HI_out,
		sel    => ALU_LO_HI_registered,
		output => ALUMuxOut
	);
	
	U_ALUCONTROL : entity work.alu_control
	port map(
		fiveDown	=> offset(5 downto 0),
		ALUOp		=> ALUOp,
		opCode		=> opIntoALCON,
		weirdBranch	=> rt,
		opSel		=> opSel,
		ALU_LO_HI	=> ALU_LO_HI,
		HI_en		=> HI_en,
		LO_en		=> LO_en
	);
	
	U_ALU_LO_HI_REG : entity work.reg
	generic map(width => widthForLOHI)
	port map(
		input  => ALU_LO_HI,
		clk    => clk,
		rst    => rst,
		enable => keepEnOn,
		output => ALU_LO_HI_registered
	);
	
	U_PCPLUSFOURREG : entity work.reg
	generic map(width => width)
	port map(
		input  => result,
		clk    => clk,
		rst    => rst,
		enable => pcPlusEnable,
		output => pcPlusFour
	);
	
	
	OpCode <= opIntoALCON;
	fiveDown <= offset(5 downto 0);
	

end STR;