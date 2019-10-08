library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package tb_word_pkg is
	type reg_word is array (31 downto 0) of std_logic_vector(31 downto 0);
	type data_word is array (0 to 127) of std_logic_vector(31 downto 0);
end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tb_word_pkg.all;

entity mips is
	generic(
		DATA_WIDTH: natural := 32;
		ADDRESS_WIDTH: natural := 7);
	port (
		mips_reset: in std_logic;
		mips_clk: in std_logic;
		rb_clock: in std_logic;
		md_clock: in std_logic;
		din: in std_logic_vector(13 downto 0);
		dout: out std_logic_vector(31 downto 0) );
end entity;

architecture mips_arch of mips is
	signal clk: std_logic := '0';
	signal dtype: std_logic_vector(1 downto 0) := "00";
	signal dreg: std_logic_vector(4 downto 0) := "00000";
	signal dmem: std_logic_vector(6 downto 0) := "0000000";

	-- Unidade de Controle
	component control is
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
		JAL: out std_logic );
	end component;
	signal RegDst: std_logic := '0';
	signal JR: std_logic := '0';
	signal Jump: std_logic := '0';
	signal ULAop: std_logic_vector(1 downto 0) := "00";
	signal Branch: std_logic := '0';
	signal MemRead: std_logic := '0';
	signal MemtoReg: std_logic := '0';
	signal BNE: std_logic := '0';
	signal MemWrite: std_logic := '0';
	signal ALUSrc: std_logic := '0';
	signal RegWrite: std_logic := '0';
	signal JAL: std_logic := '0';


	-- PC
	component pc is
	port (
		clock : in std_logic;
		reset : in std_logic;
		entra : in std_logic_vector(DATA_WIDTH-1 downto 0);
		sai : out std_logic_vector(DATA_WIDTH-1 downto 0));
	end component;
	signal pc_out: std_logic_vector(DATA_WIDTH-1 downto 0) := X"00000000";


	-- Memoria de Instrucoes
	component mem_inst is
	port (
		pc: in std_logic_vector(DATA_WIDTH-1 downto 0);
		instruction: out std_logic_vector(DATA_WIDTH-1 downto 0));
	end component;
	signal instruction: std_logic_vector(DATA_WIDTH-1 downto 0) := X"00000000";


	-- Memoria de Dados
	component mem_data is
	port (
		clk, wren, rren: in std_logic;
		memin, wdata: in std_logic_vector(DATA_WIDTH-1 downto 0);
		rdata: out std_logic_vector(DATA_WIDTH-1 downto 0);
		data_dout: out data_word );
	end component;
	signal md_out: std_logic_vector(DATA_WIDTH-1 downto 0) := X"00000000";
	signal data_dout: data_word;


	-- Banco de Registradores
	component reg_bank is
	port (
		clk, wren: in std_logic;
		radd1, radd2, wadd: in std_logic_vector(4 downto 0);
		wdata: in std_logic_vector(DATA_WIDTH-1 downto 0);
		rdata1, rdata2: out std_logic_vector(DATA_WIDTH-1 downto 0);
		reg_dout: out reg_word );
	end component;
	signal rb_data1: std_logic_vector(DATA_WIDTH-1 downto 0) := X"00000000";
	signal rb_data2: std_logic_vector(DATA_WIDTH-1 downto 0) := X"00000000";
	signal reg_dout: reg_word;


	-- ULA
	component ula is
	port (
		input1, input2: in std_logic_vector(DATA_WIDTH-1 downto 0);
		operation: in std_logic_vector(3 downto 0);
		output: out std_logic_vector(DATA_WIDTH-1 downto 0);
		zero: out std_logic );
	end component;
	signal ULA_result: std_logic_vector(DATA_WIDTH-1 downto 0) := X"00000000";
	signal ula_zero: std_logic := '0';


	-- Controle da ULA
	component ula_control is
	port (
		instruction: in std_logic_vector(31 downto 0);
		opula: in std_logic_vector(1 downto 0);
		operation: out std_logic_vector(3 downto 0);
		shamt: out std_logic );
	end component;
	signal ulac_oper: std_logic_vector(3 downto 0) := "0000";
	signal ulac_shamt: std_logic := '0';


	-- Jump Address Shift Left 2
	component jump_sll2 is
	port (
		instruction : in std_logic_vector(31 downto 0);
		pc_four : in std_logic_vector(31 downto 0);
		jump_address : out std_logic_vector(31 downto 0));
	end component;
	signal jump_address: std_logic_vector(31 downto 0) := X"00000000";


	-- Somador 32 bits
	component adder is
	port (
		input1: in std_logic_vector(31 downto 0);
		input2: in std_logic_vector(31 downto 0);
		sumout: out std_logic_vector(31 downto 0));
	end component;
	signal pc_four: std_logic_vector(31 downto 0);
	signal four: std_logic_vector(31 downto 0) := X"00000004";
	signal pc_branch: std_logic_vector(31 downto 0) := X"00000000";
	signal se_out2_sll2: std_logic_vector(31 downto 0) := X"00000000";


	-- Multiplexador 2x1 32 bits
	component mux2x1 is
	port (
		control : in std_logic;
		input1 : in std_logic_vector(31 downto 0);
		input2 : in std_logic_vector(31 downto 0);
		mux_out : out std_logic_vector(31 downto 0));
	end component;
	signal jal_mux: std_logic_vector(31 downto 0) := X"00000000";
	signal jr_mux: std_logic_vector(31 downto 0) := X"00000000";
	signal jump_mux: std_logic_vector(31 downto 0) := X"00000000";
	signal branch_mux: std_logic_vector(31 downto 0) := X"00000000";
	signal b_comb: std_logic := '0';
	signal MemtoReg_mux: std_logic_vector(31 downto 0) := X"00000000";
	signal shamt_mux: std_logic_vector(31 downto 0) := X"00000000";
	signal ALUSrc_mux: std_logic_vector(31 downto 0) := X"00000000";


	-- Multiplexador 2x1 5 bits
	component mux2x1_5bit is
	port (
		jal: in std_logic;
		control : in std_logic;
		instruction : in std_logic_vector(31 downto 0);
		mux_out : out std_logic_vector(4 downto 0));
	end component;
	signal mux5_out: std_logic_vector(4 downto 0) := "00000";


	-- Extensao de Sinal
	component sign_extend is
	port (
		instruction : in std_logic_vector(31 downto 0);
		se_out1 : out std_logic_vector(31 downto 0);
		se_out2 : out std_logic_vector(31 downto 0));
	end component;
	signal se_out1: std_logic_vector(31 downto 0) := X"00000000";
	signal se_out2: std_logic_vector(31 downto 0) := X"00000000";


begin
	clk <= mips_clk;
	
	-- Unidade de Controle
	control_map: control port map (
		instruction => instruction,
		RegDst => RegDst,
		JR => JR,
		Jump => Jump,
		ALUOp => ULAop,
		Branch => Branch,
		MemRead => MemRead,
		MemtoReg => MemtoReg,
		BNE => BNE,
		MemWrite => MemWrite,
		ALUSrc => ALUSrc,
		RegWrite => RegWrite,
		JAL => JAL
	);

	-- PC
	pc_map: pc port map (
		clock => clk,
		reset => mips_reset,
		entra => jump_mux,
		sai => pc_out
	);

	-- Memoria de Instrucoes
	mi_map: mem_inst port map (
		pc => pc_out,
		instruction => instruction
	);

	-- Memoria de Dados
	md_map: mem_data port map (
		clk => md_clock,
		wren => MemWrite,
		rren => MemRead,
		memin => ULA_result,
		wdata => rb_data2,
		rdata => md_out,
		data_dout => data_dout
	);

	-- Banco de Registradores
	rb_map: reg_bank port map (
		clk => rb_clock,
		wren => RegWrite,
		radd1 => instruction(25 downto 21),
		radd2 => instruction(20 downto 16),
		wadd => mux5_out,
		wdata => jal_mux,
		rdata1 => rb_data1,
		rdata2 => rb_data2,
		reg_dout => reg_dout
	);

	-- ULA
	ula_map: ula port map (
		input1 => shamt_mux,
		input2 => ALUSrc_mux,
		operation => ulac_oper,
		output => ULA_result,
		zero => ula_zero
	);

	-- Controle da ULA
	ulac_map: ula_control port map (
		instruction => instruction,
		opula => ULAop,
		operation => ulac_oper,
		shamt => ulac_shamt
	);

	-- Jump Shift Left 2
	jsl2_map: jump_sll2 port map (
		instruction => instruction,
		pc_four => pc_four,
		jump_address => jump_address
	);

	-- Somador PC+4
	pc_adder: adder port map (
		input1 => pc_out,
		input2 => four,
		sumout => pc_four
	);

	-- Somador de Desvio Condicional
	se_out2_sll2(31 downto 2) <= se_out2(29 downto 0);
	branch_adder: adder port map (
		input1 => pc_four,
		input2 => se_out2_sll2,
		sumout => pc_branch
	);

	-- Multiplexador para Jal
	jal_mux_map: mux2x1 port map (
		control => JAL,
		input1 => MemtoReg_mux,
		input2 => pc_four,
		mux_out => jal_mux
	);

	-- Multiplexador para Jr
	jr_mux_map: mux2x1 port map (
		control => JR,
		input1 => jump_address,
		input2 => rb_data1,
		mux_out => jr_mux
	);

	-- Multiplexador para Jumps em geral
	jump_mux_map: mux2x1 port map (
		control => Jump,
		input1 => branch_mux,
		input2 => jr_mux,
		mux_out => jump_mux
	);

	-- Multiplexador para Desvio Condicional
	b_comb <= (Branch and ula_zero) or (BNE and (not ula_zero));
	branch_mux_map: mux2x1 port map (
		control => b_comb,
		input1 => pc_four,
		input2 => pc_branch,
		mux_out => branch_mux
	);

	-- Multiplexador para LW
	MemtoReg_mux_map: mux2x1 port map (
		control => MemtoReg,
		input1 => ULA_result,
		input2 => md_out,
		mux_out => MemtoReg_mux
	);

	-- Multiplexador para Shifts
	shamt_mux_map: mux2x1 port map (
		control => ulac_shamt,
		input1 => rb_data1,
		input2 => se_out1,
		mux_out => shamt_mux
	);

	-- Multiplexador para entrada da ULA
	ALUSrc_mux_map: mux2x1 port map (
		control => ALUSrc,
		input1 => rb_data2,
		input2 => se_out2,
		mux_out => ALUSrc_mux
	);

	-- Multiplexador de 5 bits
	mux5_map: mux2x1_5bit port map (
		jal => JAL,
		control => RegDst,
		instruction => instruction,
		mux_out => mux5_out
	);

	-- Extensão de Sinal
	se_map: sign_extend port map (
		instruction => instruction,
		se_out1 => se_out1,
		se_out2 => se_out2
	);
	
	dtype <= din(1 downto 0);
	dreg <= din(6 downto 2);
	dmem <= din(13 downto 7);
	
	dout_process: process (dtype, dreg, dmem, pc_out) begin
		case dtype is
			when "00" => dout <= pc_out;
			when "01" => dout <= instruction;
			when "10" => dout <= reg_dout(to_integer(unsigned(dreg)));
			when "11" => dout <= data_dout(to_integer(unsigned(dmem)));
			when others => null;
		end case;
	end process;
	
end architecture;