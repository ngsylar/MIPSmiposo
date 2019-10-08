library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_control is
	port (
		instruction: in std_logic_vector(31 downto 0);
		opula: in std_logic_vector(1 downto 0);
		operation: out std_logic_vector(3 downto 0);
		shamt: out std_logic);
end ula_control;

architecture ulac of ula_control is
	signal opfunc: std_logic_vector(5 downto 0);
	signal ulaoper: std_logic_vector(3 downto 0);

begin
	opula_def: process (instruction, opula) begin
		case opula is
			when "00" => opfunc <= instruction(5 downto 0);
			when others => opfunc <= instruction(31 downto 26);
		end case;
	end process;

	ulaoper(3)<=((not(opfunc(5)) and not(opfunc(3)) and opfunc(1)));
	ulaoper(2)<=((opfunc(2) and opfunc(1)) or (not(opula(1)) and not(opfunc(5)) and not(opfunc(3)) and not(opfunc(1))) or (not(opula(1)) and opfunc(3) and opfunc(1)));
	ulaoper(1)<=((not(opfunc(2)) and not(opfunc(1))) or (opfunc(2) and opfunc(1) and not(opfunc(0))) or (opfunc(5) and not(opfunc(3)) and opfunc(1) and not(opfunc(0))) or (opula(1)));
	ulaoper(0)<=((not(opfunc(5)) and not(opfunc(3)) and not(opfunc(1))) or (not(opula(1)) and opfunc(0)) or (opfunc(5) and not(opfunc(3)) and not(opfunc(2)) and opfunc(1) and not(opfunc(0))));

	shamt <= ulaoper(3) xor (ulaoper(2) and (ulaoper(1) and ulaoper(0)));
	operation <= ulaoper;
end;