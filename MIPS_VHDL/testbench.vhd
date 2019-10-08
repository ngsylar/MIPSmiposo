library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_word_pkg.all;

entity testbench is
end testbench;

architecture tb_arch_tb of testbench is
	-- declara o componente MIPS e cria sinais de entrada e saida para o testbench
	component mips port (
		mips_reset: in std_logic;
		mips_clk: in std_logic;
		rb_clock: in std_logic;
		md_clock: in std_logic;
		disp_pc: out std_logic_vector(31 downto 0);
		disp_inst: out std_logic_vector(31 downto 0);
		disp_reg: out reg_word;
		disp_mem: out data_word );
	end component;
	signal start: std_logic;
	signal clock: std_logic := '0';
	signal aut_clk: std_logic := '0';
	signal disp_pc: std_logic_vector(31 downto 0) := X"00000000";
	signal disp_inst: std_logic_vector(31 downto 0) := X"00000000";
	signal disp_reg: reg_word := (others => X"00000000");
	signal disp_mem: data_word := (others => X"00000000");
	
	constant clk_period: time := 20 ns;			-- define meio ciclo de clock
	constant number: natural := 37;				-- define numero de instrucoes a serem realizadas
	
begin
	uut: mips port map (
		mips_clk => clock,
		mips_reset => start,
		rb_clock => aut_clk,
		md_clock => aut_clk,
		disp_pc => disp_pc,
		disp_inst => disp_inst,
		disp_reg => disp_reg,
		disp_mem => disp_mem
	);
	
	-- inicia PC em zero (serve como reset para PC; ler descricao de PC em mips.vhd)
	start_process: process
	begin
		start <= '1';
		wait until clock = '1';
		wait for clk_period/4;
		start <= '0';
		wait;
	end process;

	-- inicia o clock principal
	the_process: process
	begin
		wait for 10 ns;
		for i in 0 to number-1 loop
			clock <= '1';
			wait for clk_period;
			clock <= '0';
			wait for clk_period;
		end loop;
		wait;
	end process;
	
	-- clock secundario automatico que funciona a partir do sinal do clock principal
	aut_clk_process: process
	begin
		wait until clock = '1';
		for i in 0 to 3 loop
			aut_clk <= '0';
			wait for clk_period/4;
			aut_clk <= '1';
			wait for clk_period/4;
		end loop;
		aut_clk <= '0';
	end process;
end;