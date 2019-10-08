library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity sign_extend is
	port (
		instruction : in std_logic_vector(31 downto 0);
		se_out1 : out std_logic_vector(31 downto 0);
		se_out2 : out std_logic_vector(31 downto 0));
end entity;

architecture sign_extend_arch of sign_extend is
	signal immediate : std_logic_vector(31 downto 0) := X"00000000";
	signal shamt : std_logic_vector(31 downto 0) := X"00000000";

begin
	shamt(4 downto 0) <= instruction(10 downto 6);
	se_out1 <= shamt;

	immediate(15 downto 0) <= instruction(15 downto 0);
	se_out2 <= immediate;
end architecture;