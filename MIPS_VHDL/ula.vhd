library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ula is
	generic (DATA_WIDTH : natural := 32);
	port (
		input1, input2: in std_logic_vector(DATA_WIDTH-1 downto 0);			-- inputs, entradas a serem operadas
		operation: in std_logic_vector(3 downto 0);								-- operacao a ser realizada
		output: out std_logic_vector(DATA_WIDTH-1 downto 0);					-- resultado da operacao
		zero: out std_logic );															-- zero retorna 1 caso o resultado seja igual a 0
end ula;
	
architecture behavioral of ula is
	signal in1, in2, ni2: std_logic_vector(31 downto 0);						-- entradas
	signal a32, add, sub: std_logic_vector(31 downto 0);						-- variaveis para operacao de soma, subtracao e carry, passagem de resultados para as saidas
	signal sllin, srlin, srain: bit_vector(31 downto 0);						-- shifts
	
	begin
	-- entrada
	in1 <= input1;										-- in1 recebe input1
	in2 <= input2;										-- in2 recebe input2
	ni2 <= not input2 + '1';						-- ni2 eh o complemento de 2 do input 2
	
	-- operacoes aritmeticas
	add <= in1 + in2;									-- soma
	sub <= in1 + ni2;									-- subtracao em complemento de dois
	
	-- shifts
	sllin <= to_bitvector(in2) sll conv_integer(in1);		-- shift left logic de 'input2' bits em input1
	srlin <= to_bitvector(in2) srl conv_integer(in1);		-- shift right logic de 'input2' bits em input1
	srain <= to_bitvector(in2) sra conv_integer(in1);		-- shift right arithmetic de 'input2' bits em input1
	
	-- saida
	output <= a32;					-- a32 eh o resultado a ser passado para output
	
	proc_zero: process (a32) begin
		if (a32 = X"00000000") then zero <= '1';		-- se o resultado obtido em a32 for igual a 0, a saida 0 recebe 1
		else zero <= '0'; end if;
	end process;
	
	-- sensitive case, a saida muda com a mudanca de operation, input1 ou input2
	proc_ula: process (operation, in1, in2, add, sub, sllin, srlin, srain) begin
		case operation is
			when "0000" => a32 <= in1 and in2;							-- and
			when "0001" => a32 <= in1 or in2;							-- or
			when "0010" => a32 <= add;										-- add
			when "0011" => a32 <= sub;										-- sub
			when "0100" => a32 <= (0 => sub(31), others => '0');	-- slt
			when "0101" => a32 <= in1 nor in2;							-- nor
			when "0110" => a32 <= in1 xor in2;							-- xor
			when "0111" => a32 <= to_stdlogicvector(sllin);			-- sll
			when "1000" => a32 <= to_stdlogicvector(srlin);			-- srl
			when "1001" => a32 <= to_stdlogicvector(srain);			-- sra
			when others => a32 <= (others => '0');
		end case;
	end process;
end architecture behavioral;