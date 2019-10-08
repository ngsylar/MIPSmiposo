library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.tb_word_pkg.all;

entity reg_bank is
	generic (
		DATA_WIDTH: natural := 32;
		ADDRESS_WIDTH: natural := 5 );
	port (
		clk, wren: in std_logic;															-- ativa a escrita
		radd1, radd2, wadd: in std_logic_vector(ADDRESS_WIDTH-1 downto 0);	-- indices de registrador (radd para leitura e wadd para escrita)
		wdata: in std_logic_vector(DATA_WIDTH-1 downto 0);							-- dado a ser escrito em um registrador
		rdata1, rdata2: out std_logic_vector(DATA_WIDTH-1 downto 0);			-- dados a serem lidos nos referentes registradores
		reg_dout: out reg_word );
end entity reg_bank;

architecture structural of reg_bank is
	signal registrador: reg_word := (others => X"00000000");						-- declara vetor de registradores do tipo reg_word com valores iniciais iguais a zero
	signal wid_v, rid1_v, rid2_v: std_logic_vector(5 downto 0) := "000000";	-- variaveis que recebem wadd, radd1 e radd2, respectivamente, sem extensao de sinal
	signal wid, rid1, rid2: integer := 0;												-- indices de registrador sem extensao de sinal
	
	begin
	reg_dout <= registrador;
	
	wid_v(4 downto 0) <= wadd;
	wid_v(5) <= '0';
	wid <= conv_integer(wid_v);			-- wid recebe wadd como inteiro sem extensao de sinal, atraves de wid_v
	
	rid1_v(4 downto 0) <= radd1;
	rid1_v(5) <= '0';
	rid1 <= conv_integer(rid1_v);			-- rid1 recebe radd1 como inteiro sem extensao de sinal, atraves de rid1_v
	
	rid2_v(4 downto 0) <= radd2;
	rid2_v(5) <= '0';
	rid2 <= conv_integer(rid2_v);			-- rid2 recebe radd2 como inteiro sem extensao de sinal, atraves de rid2_v
	
	operate_rb: process (clk) begin
		if rising_edge(clk) then						-- durante a subida de clock
			case conv_integer(wren) is
				when 1 =>									-- se wren estiver ativado
					if (wid = 0) then
						null;									-- registrador[0] nao pode receber nenhuma escrita 
					else
						registrador(wid) <= wdata;		-- registrador[wadd] recebe wdata se wadd for diferente de zero
					end if;
				when others =>								-- se wren estiver desativado
					null;										-- registrador[wadd] nao pode receber nenhuma escrita
			end case;
			rdata1 <= registrador(rid1);		-- rdata1 recebe conteudo escrito em registrador[radd1]
			rdata2 <= registrador(rid2);		-- rdata2 recebe conteudo escrito em registrador[radd2]
		end if;
	end process;
end architecture structural;