library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control is
	port(
		instruction: in std_logic_vector(31 downto 0);
		RegDst: out std_logic;
		JR: out std_logic;
		Jump: out std_logic;
		ALUOp: out std_logic_vector(1 downto 0);
		Branch: out std_logic;
		MemRead: out std_logic;
		MemtoReg: out std_logic;
		BNE: out std_logic;
		MemWrite: out std_logic;
		ALUSrc: out std_logic;
		RegWrite: out std_logic;
		JAL: out std_logic);
end entity;	

architecture architecture_control of control is
	signal opcode: std_logic_vector(5 downto 0);
	signal funct: std_logic_vector(5 downto 0);

begin
	opcode <= instruction(31 downto 26);
	funct <= instruction(5 downto 0);

	process(opcode, funct)
	begin
		-- JR
		if (opcode = "000000") then
			case funct is
			when "001000" =>
				RegDst <= '0';
				JR <= '1';
				Jump <= '1';
				ALUOp <= "00";
				Branch <= '0';
				MemRead <= '0';
				MemtoReg <= '0';
				BNE <= '0';
				MemWrite <= '0';
				ALUSrc <= '0';
				RegWrite <= '0';
				JAL <= '0';

		-- R-TYPE
			when others =>
				RegDst <= '1';
				JR <= '0';
				Jump <= '0';
				ALUOp <= "00";
				Branch <= '0';
				MemRead <= '0';
				MemtoReg <= '0';
				BNE <= '0';
				MemWrite <= '0';
				ALUSrc <= '0';
				RegWrite <= '1';
				JAL <= '0';
			end case;
		
		-- JUMP
		elsif (opcode = "000010") then
			RegDst <= '0';
			JR <= '0';
			Jump <= '1';
			ALUOp <= "00";
			Branch <= '0';
			MemRead <= '0';
			MemtoReg <= '0';
			BNE <= '0';
			MemWrite <= '0';
			ALUSrc <= '0';
			RegWrite <= '0';
			JAL <= '0';

		-- JAL
		elsif (opcode = "000011") then
			RegDst <= '0';
			JR <= '0';
			Jump <= '1';
			ALUOp <= "00";
			Branch <= '0';
			MemRead <= '0';
			MemtoReg <= '0';
			BNE <= '0';
			MemWrite <= '0';
			ALUSrc <= '0';
			RegWrite <= '1';
			JAL <= '1';

		-- LW
		elsif (opcode = "100011") then
			RegDst <= '0';
			JR <= '0';
			Jump <= '0';
			ALUOp <= "10";
			Branch <= '0';
			MemRead <= '1';
			MemtoReg <= '1';
			BNE <= '0';
			MemWrite <= '0';
			ALUSrc <= '1';
			RegWrite <= '1';
			JAL <= '0';
			
		-- SW
		elsif (opcode = "101011") then
			RegDst <= '0';
			JR <= '0';
			Jump <= '0';
			ALUOp <= "10";
			Branch <= '0';
			MemRead <= '0';
			MemtoReg <= '0';
			BNE <= '0';
			MemWrite <= '1';
			ALUSrc <= '1';
			RegWrite <= '0';
			JAL <= '0';
 
		-- BEQ
		elsif (opcode = "000100") then
			RegDst <= '0';
			JR <= '0';
			Jump <= '0';
			ALUOp <= "11";
			Branch <= '1';
			MemRead <= '0';
			MemtoReg <= '0';
			BNE <= '0';
			MemWrite <= '0';
			ALUSrc <= '0';
			RegWrite <= '0';
			JAL <= '0';

		-- BNE
		elsif (opcode = "000101") then
			RegDst <= '0';
			JR <= '0';
			Jump <= '0';
			ALUOp <= "11";
			Branch <= '0';
			MemRead <= '0';
			MemtoReg <= '0';
			BNE <= '1';
			MemWrite <= '0';
			ALUSrc <= '0';
			RegWrite <= '0';
			JAL <= '0';

		-- ADDI
		elsif (opcode = "001000") then
			RegDst <= '0';
			JR <= '0';
			Jump <= '0';
			ALUOp <= "01";
			Branch <= '0';
			MemRead <= '0';
			MemtoReg <= '0';
			BNE <= '0';
			MemWrite <= '0';
			ALUSrc <= '1';
			RegWrite <= '1';
			JAL <= '0';

		-- ANDI
		elsif (opcode = "001100") then
			RegDst <= '0';
			JR <= '0';
			Jump <= '0';
			ALUOp <= "01";
			Branch <= '0';
			MemRead <= '0';
			MemtoReg <= '0';
			BNE <= '0';
			MemWrite <= '0';
			ALUSrc <= '1';
			RegWrite <= '1';
			JAL <= '0';

		-- ORI
		elsif (opcode = "001101") then
			RegDst <= '0';
			JR <= '0';
			Jump <= '0';
			ALUOp <= "01";
			Branch <= '0';
			MemRead <= '0';
			MemtoReg <= '0';
			BNE <= '0';
			MemWrite <= '0';
			ALUSrc <= '1';
			RegWrite <= '1';
			JAL <= '0';

		-- XORI
		elsif (opcode = "001110") then
			RegDst <= '0';
			JR <= '0';
			Jump <= '0';
			ALUOp <= "01";
			Branch <= '0';
			MemRead <= '0';
			MemtoReg <= '0';
			BNE <= '0';
			MemWrite <= '0';
			ALUSrc <= '1';
			RegWrite <= '1';
			JAL <= '0';

		-- SLTI
		elsif (opcode = "001010") then
			RegDst <= '0';
			JR <= '0';
			Jump <= '0';
			ALUOp <= "01";
			Branch <= '0';
			MemRead <= '0';
			MemtoReg <= '0';
			BNE <= '0';
			MemWrite <= '0';
			ALUSrc <= '1';
			RegWrite <= '1';
			JAL <= '0';
		end if;
	end process;
end architecture;