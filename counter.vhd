library IEEE;
use IEEE.std_logic_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter is
	port(
		bcd	: out std_logic_vector(3 downto 0);
		clk	: in std_logic;
		reset	: in std_logic
	);
end;

architecture arch of counter is
	signal b	: std_logic_vector(3 downto 0) := "0000";
	
begin

bcd <= b;

process(clk)
begin
	if(reset = '1') then
		b <= "0000";
	elsif(falling_edge(clk)) then
		b <= b+1;
	end if;
end process;

end arch;