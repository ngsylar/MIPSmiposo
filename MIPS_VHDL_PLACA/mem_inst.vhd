library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity mem_inst is
	generic (
		DATA_WIDTH: natural := 32;
		ADDRESS_WIDTH: natural := 7 );
	port (
		pc: in std_logic_vector(DATA_WIDTH-1 downto 0);
		instruction: out std_logic_vector(DATA_WIDTH-1 downto 0) );
end mem_inst;

architecture mi_arch of mem_inst is
	type word_array is array (0 to (2**ADDRESS_WIDTH-1)) of std_logic_vector(31 downto 0);
	signal address: std_logic_vector(ADDRESS_WIDTH-1 downto 0);

	signal word: word_array := (
		X"2008000f",
		X"20090025",
		X"01095020",
		X"01095020",
		X"01095020",
		X"01095020",
		X"01285822",
		X"01286024",
		X"01286825",
		X"01287027",
		X"01287826",
		X"00089100",
		X"000e9842",
		X"000ea043",
		X"353500ff",
		X"393600ff",
		X"313600ff",
		X"29160014",
		X"29150001",
		X"20152000",
		X"8eb60000",
		X"8eb70004",
		X"aeac0008",
		X"0128802a",
		X"16000005",
		X"0109882a",
		X"16200003",
		X"0c000021",
		X"08000023",
		X"00000020",
		X"12200004",
		X"00000020",
		X"0800001b",
		X"03e00008",
		X"00000020",
		X"08000023",
		others => X"00000000");
	
	begin
	address <= pc(8 downto 2);
	instruction <= word(conv_integer(address));
end mi_arch;