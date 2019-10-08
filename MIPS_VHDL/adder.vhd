library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity adder is
	generic (WSIZE: natural := 32);
	port (
		input1: in std_logic_vector(WSIZE-1 downto 0);
		input2: in std_logic_vector(WSIZE-1 downto 0);
		sumout: out std_logic_vector(WSIZE-1 downto 0));
end entity;

architecture adder_arch of adder is
begin
	sumout <= input1 + input2;
end architecture;