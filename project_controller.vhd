library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity project_controller is
	port(
		clk : in std_logic;
		rst : in std_logic;
		opCode : in std_logic_vector(5 downto 0);
		branchTaken : in std_logic;
		fiveDown	: in std_logic_vector(5 downto 0);
		PCWrite : out std_logic;
		IorD : out std_logic;
		MemWrite : out std_logic;
		MemToReg : out std_logic_vector(1 downto 0);
		IRWrite : out std_logic;
		JumpAndLink : out std_logic;
		pcPlusEnable : out std_logic;
		isSigned : out std_logic;
		PCSource : out std_logic_vector(1 downto 0);
		ALUOp : out std_logic_vector(1 downto 0);
		ALUSrcB : out std_logic_vector(1 downto 0);
		ALUSrcA : out std_logic;
		RegWrite : out std_logic;
		RegDst : out std_logic
	);
end project_controller;


architecture BHV of project_controller is

	type state_type is (START,INSTFETCH,DELAY,INSTDECODE,REXECUTE,RCOMPLETE,JUMP,BCOMPLETE,ADDCOMP,IEXECUTE,ICOMPLETE,SAVERET,JCOMPLETE,STOREMEMACC,LOADMEMACC,LOADCOMPLETE,LDELAY);
	signal state, next_state : state_type;
	

begin

	process(rst,clk)
	begin
		if(rst = '1')then
			state <= START;
		elsif(rising_edge(clk))then
			state <= next_state;
		end if;
	end process;
	
	process(opCode,branchTaken,state,fiveDown)
	begin
	
		MemWrite <= '0';
		ALUSrcA <= '0';
		ALUSrcB <= "01";
		IorD <= '0';
		IRWrite <= '0';
		RegWrite <= '0';
		PCWrite <= '0';
		PCSource <= "00";
		MemToReg <= "00";
		pcPlusEnable <= '0';
		JumpAndLink <= '0';
		isSigned <= '1';
		RegDst <= '1';
		ALUOp <= "00";
		
		case state is
			when START =>
				next_state <= INSTFETCH;
			when INSTFETCH =>
				MemWrite <= '0';
				ALUSrcA <= '0';
				IorD <= '0';
				ALUSrcB <= "01";
				ALUOp <= "00";
				PCWrite <= '1';
				PCSource <= "00";
				pcPlusEnable <= '1';
				next_state <= DELAY;
			when DELAY =>
				IRWrite <= '1';
				next_state <= INSTDECODE;
			when INSTDECODE =>
				ALUSrcA <= '0';
				ALUSrcB <= "11";
				ALUOp <= "00";
				isSigned <= '1';
				if(opCode = "000000")then --r-type
					next_state <= REXECUTE;
				elsif(opCode = "000010" or opCode = "000011")then --j-type
					next_state <= JUMP;
				elsif(opCode < "001000")then --b-type
					next_state <= BCOMPLETE;
				elsif(opCode <= "010000")then --i-type
					next_state <= IEXECUTE;
				else -- memory
					next_state <= ADDCOMP;
				end if;
			when REXECUTE =>
				ALUOp <= "10";
				ALUSrcA <= '1';
				ALUSrcB <= "00";
				if(fiveDown = "001000")then --jump register
					PCSource <= "00";
					PCWrite <= '1';
					next_state <= INSTFETCH;
				end if;
				next_state <= RCOMPLETE;
			when RCOMPLETE =>
				MemToReg <= "00";
				RegDst <= '1';
				RegWrite <= '1';
				next_state <= INSTFETCH;
			when IEXECUTE =>
				ALUOp <= "11";
				ALUSrcA <= '1';
				ALUSrcB <= "10";
				if(opCode = "001100" or opCode = "001101" or opCode = "001110")then
					isSigned <= '0';
				else
					isSigned <= '1';
				end if;
				next_state <= ICOMPLETE;
			when ICOMPLETE =>
				MemToReg <= "00";
				RegDst <= '0';
				RegWrite <= '1';
				next_state <= INSTFETCH;
			when BCOMPLETE =>
				ALUOp <= "01";
				ALUSrcA <= '1';
				ALUSrcB <= "00";
				PCSource <= "01";
				if(branchTaken = '1')then
					PCWrite <= '1';
				end if;
				next_state <= INSTFETCH;
			when JUMP =>
				if(opCode = "000011")then
					ALUSrcA <= '0';
					ALUSrcB <= "01";
					ALUOp <= "00";
					next_state <= SAVERET;
				else
					next_state <= JCOMPLETE;
				end if;
			when SAVERET =>
				MemToReg <= "10";
				JumpAndLink <= '1';
				RegWrite <= '1';
				next_state <= JCOMPLETE;
			when JCOMPLETE =>
				PCSource <= "10";
				PCWrite <= '1';
				next_state <= INSTFETCH;
			when ADDCOMP =>
				ALUOp <= "00";
				ALUSrcA <= '1';
				ALUSrcB <= "10";
				isSigned <= '0';
				if(opCode = "101011")then
					next_state <= STOREMEMACC;
				else
					next_state <= LOADMEMACC;
				end if;
			when STOREMEMACC =>
				IorD <= '1';
				MemWrite <= '1';
				next_state <= INSTFETCH;
			when LOADMEMACC =>
				IorD <= '1';
				MemWrite <= '0';
				next_state <= LDELAY;
			when LDELAY =>
				next_state <= LOADCOMPLETE;
			when LOADCOMPLETE => 
				MemToReg <= "01";
				RegDst <= '0';
				RegWrite <= '1';
				next_state <= INSTFETCH;
			end case;	
	end process;
end BHV;