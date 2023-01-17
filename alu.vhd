library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is 
	generic(width : positive := 32);
	port(
		input1 			: in std_logic_vector(width - 1 downto 0);
		input2 			: in std_logic_vector(width - 1 downto 0);
		shiftAmount 	: in std_logic_vector(4 downto 0);
		opSel			: in std_logic_vector(4 downto 0);
		branchTaken 	: out std_logic;
		result			: out std_logic_vector(width - 1 downto 0);
		resultHi		: out std_logic_vector(width - 1 downto 0)
	);
	
end alu;

architecture BHV of alu is

begin
process(input1,input2,opSel, shiftAmount)
	variable temp : unsigned(width-1 downto 0);
	variable signTemp : signed(width-1 downto 0);
	variable twoTemp : unsigned(2*width-1 downto 0);
	variable signTwoTemp : signed(2*width-1 downto 0);
	variable shiftUn : unsigned(4 downto 0);
	variable extendInput1 : unsigned(2*width-1 downto 0);
	begin
		result <= (others => '0');
		resultHi <= (others => '0');
		branchTaken <= '0';
		if(opSel = "00000") then
			temp := unsigned(input1) + unsigned(input2);
			result <= std_logic_vector(temp);
		elsif(opSel = "00001") then
			temp := unsigned(input1) - unsigned(input2);
			result <= std_logic_vector(temp);
		elsif(opSel = "00010") then
			signTwoTemp := signed(input1)* signed(input2);
			resultHi <= std_logic_vector(signTwoTemp(2*width-1 downto width));
			result <= std_logic_vector(signTwoTemp(width-1 downto 0));
		elsif(opSel = "00011") then
			twoTemp := unsigned(input1)* unsigned(input2);
			resultHi <= std_logic_vector(twoTemp(2*width-1 downto width));
			result <= std_logic_vector(twoTemp(width-1 downto 0));
		elsif(opSel = "00100") then
			result <= input1 and input2;
		elsif(opSel = "00101") then
			result <= input1 or input2;
		elsif(opSel = "00110") then
			result <= input1 xor input2;
		elsif(opSel = "00111") then
			shiftUN := unsigned(shiftAmount);
			temp := SHIFT_RIGHT(unsigned(input2),to_integer(shiftUN));
			result <= std_logic_vector(temp(width-1 downto 0));
		elsif(opSel = "01000") then
			shiftUN := unsigned(shiftAmount);
			temp := SHIFT_LEFT(unsigned(input2),to_integer(shiftUN));
			result <= std_logic_vector(temp(width-1 downto 0));
		elsif(opSel = "01001") then
			shiftUN := unsigned(shiftAmount);
			signTemp := SHIFT_RIGHT(signed(input2), to_integer(shiftUN));
			result <= std_logic_vector(signTemp(width-1 downto 0));
		elsif(opSel = "01010") then
			if(signed(input1) < signed(input2)) then
				result <= x"00000001";
			else
				result <= x"00000000";
			end if;
		elsif(opSel = "01011") then
			if(unsigned(input1) < unsigned(input2)) then
				result <= x"00000001";
			else
				result <= x"00000000";
			end if;
		elsif(opSel = "01100") then --jr
			result <= input1;
		
		elsif(opSel = "01101") then
			if(input1 = input2)then
				branchTaken <= '1';
			else
				branchTaken <= '0';
			end if;
		elsif(opSel = "01110") then
			if(input1 /= input2)then
				branchTaken <= '1';
			else
				branchTaken <= '0';
			end if;
			
		elsif(opSel = "01111") then
			if(signed(input1) <= to_signed(0,width))then
				branchTaken <= '1';
			else
				branchTaken <= '0';
			end if;
		
		elsif(opSel = "10000") then
			if(signed(input1) > to_signed(0,width))then
				branchTaken <= '1';
			else
				branchTaken <= '0';
			end if;
		elsif(opSel = "10001") then
			if(signed(input1) < to_signed(0,width))then
				branchTaken <= '1';
			else
				branchTaken <= '0';
			end if;
			
		elsif(opSel = "10010") then
			if(signed(input1) >= to_signed(0,width))then
				branchTaken <= '1';
			else
				branchTaken <= '0';
			end if;
		
		end if;
	end process;
end BHV;