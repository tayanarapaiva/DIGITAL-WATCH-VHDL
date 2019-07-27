--protocolo PS2
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity teclado is
	port(
		PS2_CLK : in std_logic;
		PS2_DAT: in std_logic;
		ps2_code: out std_logic_vector(7 downto 0);
		has_data: out std_logic
	);
end teclado;

architecture arch of teclado is
	signal grab_count : integer range 0 to 30;
	signal incoming_data : std_logic_vector(9 downto 0) := (others => '0');	
	signal data : std_logic_vector(7 downto 0) := (others => '0');	
	
	signal raw_code : std_logic_vector(7 downto 0) := (others => '0');	
begin


ps2_code <= raw_code;
	

process(ps2_clk)
begin
	if(grab_count = 11) then
		if (incoming_data(7 downto 0) = x"F0") then
			has_data <= '1';
		else
			raw_code <= incoming_data(7 downto 0);
			has_data <= '0';
		end if;
		
		grab_count <= 0;
	elsif(falling_edge(ps2_clk)) then
		incoming_data(8 downto 0) <= incoming_data(9 downto 1);
		incoming_data(9) <= PS2_DAT;
		grab_count <= grab_count+1;
	end if;
end process;
end arch;
