library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity pc is
	generic (ADDRESS_WIDTH: natural := 32);
	port (
		clock : in std_logic;
		reset : in std_logic;
		entra : in std_logic_vector(ADDRESS_WIDTH-1 downto 0);
		sai : out std_logic_vector(ADDRESS_WIDTH-1 downto 0)
	);
end pc;

architecture pc_arch of pc is
	signal registrador : std_logic_vector(ADDRESS_WIDTH-1 downto 0) := X"00000000";

begin
	sai <= registrador;

	process (clock, reset) begin
		if (reset = '1') then
			registrador <= X"00000000";
		elsif (rising_edge(clock)) then
			registrador <= entra;
		end if;
	end process;
end pc_arch;