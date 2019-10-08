library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity mux2x1_5bit is
	port (
		jal: in std_logic;
		control : in std_logic;
		instruction : in std_logic_vector(31 downto 0);
		mux_out : out std_logic_vector(4 downto 0));
end entity;

architecture mux5bit_arch of mux2x1_5bit is
	signal rt : std_logic_vector(4 downto 0);
	signal rd : std_logic_vector(4 downto 0);

begin
	rt <= instruction(20 downto 16);
	rd <= instruction(15 downto 11);
	
	process (control, rt, rd, jal) begin
		if (jal = '1') then
			mux_out <= "11111";
		elsif (control = '0') then
			mux_out <= rt;
		elsif (control = '1') then
			mux_out <= rd;
		end if;
	end process;
end architecture;