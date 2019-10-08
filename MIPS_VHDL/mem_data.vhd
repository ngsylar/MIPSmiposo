library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.tb_word_pkg.all;

entity mem_data is
	generic (
		DATA_WIDTH: natural := 32;
		ADDRESS_WIDTH: natural := 7 );
	port (
		clk, wren, rren: in std_logic;
		memin, wdata: in std_logic_vector(DATA_WIDTH-1 downto 0);
		rdata: out std_logic_vector(DATA_WIDTH-1 downto 0);
		data_dout: out data_word );
end mem_data;
-- enttradas e saidas comentadas em mips.vhd

architecture data_seg of mem_data is
	signal word: data_word := (
		X"00000001",
		X"00000002",
		X"00000003",
		X"00000004",
		X"00000005",
		others => X"00000000" );
	signal address: std_logic_vector(ADDRESS_WIDTH-1 downto 0) := "0000000";

	begin
	data_dout <= word;					-- data_dout recebe um vetor com todos os registradores
	address <= memin(8 downto 2);		-- endereco de registrador

	escreve: process (clk) begin
		if rising_edge(clk) then
			case conv_integer(wren) is								-- se escrita estiver ativa
				when 1 =>
					word(conv_integer(address)) <= wdata;		-- registrador(address) recebe um resgitrador
				when others =>
					null;
			end case;

			case conv_integer(rren) is								-- se leitura estiver ativa
				when 1 =>
					rdata <= word(conv_integer(address));		-- saida recebe registrador(adress)
				when others =>
					null;
			end case;
		end if;
	end process;
end data_seg;