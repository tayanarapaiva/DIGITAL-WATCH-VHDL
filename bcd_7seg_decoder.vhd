--converte um número binário (de 4 bits - 0 a 9) para um vector que vai ser aplicado nos 7 segmentos
library ieee;
use ieee.std_logic_1164.all;
 
entity bcd_7seg_decoder is
port(BCD: in std_logic_vector (3 downto 0);
     HEX: out std_logic_vector (6 downto 0));
end bcd_7seg_decoder;
 
architecture arq of bcd_7seg_decoder is
begin
    process(BCD)
    begin  
        case BCD is
            when "0000" => HEX <= NOT "1111110";
            when "0001" => HEX <= NOT "0110000";
            when "0010" => HEX <= NOT "1101101";
            when "0011" => HEX <= NOT "1111001";
            when "0100" => HEX <= NOT "0110011";
            when "0101" => HEX <= NOT "1011011";
            when "0110" => HEX <= NOT "1011111";
            when "0111" => HEX <= NOT "1110000";
            when "1000" => HEX <= NOT "1111111";
            when "1001" => HEX <= NOT "1110011";
            when others => HEX <= NOT "0000000";
        end case;
    end process;
end arq;


