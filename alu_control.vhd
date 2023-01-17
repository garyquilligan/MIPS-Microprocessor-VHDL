library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_control is

	port(
		fiveDown	: in std_logic_vector(5 downto 0);
		ALUOp		: in std_logic_vector(1 downto 0);
		opCode		: in std_logic_vector(5 downto 0);
		weirdBranch	: in std_logic_vector(4 downto 0);
		opSel		: out std_logic_vector(4 downto 0);
		ALU_LO_HI	: out std_logic_vector(1 downto 0);
		HI_en		: out std_logic;
		LO_en		: out std_logic
	);
	
end alu_control;

architecture BHV of alu_control is


begin
	process(fiveDown,ALUOp,opCode,weirdBranch)
	begin
		ALU_LO_HI <= "00";
		HI_en <= '0';
		LO_en <= '0';
		opSel <= "01100";
		if(ALUOp = "00")then
			opSel <= "00000";
		elsif(ALUOp = "01")then
			if(opCode = "000100")then
				opSel <= "01101";
			elsif(opCode = "000101") then
				opSel <= "01110";
			elsif(opCode = "000110") then
				opSel <= "01111";
			elsif(opCode = "000111") then
				opSel <= "10000";
			elsif(opCode = "000001") then
				if(weirdBranch = "00001")then
					opSel <= "10010";
				elsif(weirdBranch = "00000")then
					opSel <= "10001";
				end if;
			end if;
		elsif(ALUOp = "10")then
			if(fiveDown = "010000")then
				ALU_LO_HI <= "10";
			elsif(fiveDown = "010010")then
				ALU_LO_HI <= "01";
			elsif(fiveDown = "100001")then
				opSel <= "00000";
			elsif(fiveDown = "100011")then
				opSel <= "00001";
			elsif(fiveDown = "011000")then
				opSel <= "00010";
				HI_en <= '1';
				LO_en <= '1';
			elsif(fiveDown = "011001")then
				opSel <= "00011";
				HI_en <= '1';
				LO_en <= '1';
			elsif(fiveDown = "100100")then
				opSel <= "00100";
			elsif(fiveDown = "100101")then
				opSel <= "00101";
			elsif(fiveDown = "100110")then
				opSel <= "00110";
			elsif(fiveDown = "000010")then
				opSel <= "00111";
			elsif(fiveDown = "000000")then
				opSel <= "01000";
			elsif(fiveDown = "000011")then
				opSel <= "01001";
			elsif(fiveDown = "101010")then
				opSel <= "01010";
			elsif(fiveDown = "101011")then
				opSel <= "01011";
			elsif(fiveDown = "001000")then
				
			end if;
		elsif(ALUOp = "11")then
			if(opCode = "001001")then
				opSel <= "00000";
			elsif(opCode = "001100")then
				opSel <= "00100";
			elsif(opCode = "010000")then
				opSel <= "00001";
			elsif(opCode = "001101")then
				opSel <= "00101";
			elsif(opCode = "001110")then
				opSel <= "00110";
			elsif(opCode = "001010")then
				opSel <= "01010";
			elsif(opCode = "001011")then
				opSel <= "01011";
			end if;
		end if;
	end process;

end BHV;