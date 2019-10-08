library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity jump_sll2 is
	port (
		instruction : in std_logic_vector(31 downto 0);
		pc_four : in std_logic_vector(31 downto 0);
		jump_address : out std_logic_vector(31 downto 0));
end jump_sll2;

architecture jsll_arch of jump_sll2 is
	signal address : std_logic_vector(27 downto 0) := "0000000000000000000000000000";

begin
	address(27 downto 2) <= instruction(25 downto 0);
	jump_address(27 downto 0) <= address;
	jump_address(31 downto 28) <= pc_four(31 downto 28);
end jsll_arch;