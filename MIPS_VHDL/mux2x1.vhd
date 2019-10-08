library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity mux2x1 is
	port (
		control : in std_logic;
		input1 : in std_logic_vector(31 downto 0);
		input2 : in std_logic_vector(31 downto 0);
		mux_out : out std_logic_vector(31 downto 0));
end entity;

architecture mux2x1_arch of mux2x1 is
begin
	process (control, input1, input2) begin
		if (control = '0') then
			mux_out <= input1;
		elsif (control = '1') then
			mux_out <= input2;
		end if;
	end process;
end architecture;