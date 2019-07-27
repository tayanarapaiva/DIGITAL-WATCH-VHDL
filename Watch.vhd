library IEEE;
use IEEE.std_logic_1164.ALL;

entity Watch is
	port(
		CLOCK_50	: in std_logic;
		 
		PS2_CLK : in std_logic;
		PS2_DAT: in std_logic;
		
		GPIO_0		: out std_logic_vector(0 downto 0);
		KEY		: in std_logic_vector(3 downto 0);
		SW			: in std_logic_vector(9 downto 0);
		LEDR		: out std_logic_vector(9 downto 0);
		LEDG		: out std_logic_vector(7 downto 0);
		HEX0 		: out std_logic_vector(6 downto 0);
		HEX1	 	: out std_logic_vector(6 downto 0);
		HEX2 		: out std_logic_vector(6 downto 0);
		HEX3 		: out std_logic_vector(6 downto 0)
	);
end;

architecture Arch of Watch is

	
			component bcd_7seg_decoder is
				port (
					BCD	: in std_logic_vector(3 downto 0);
					HEX 	: out std_logic_vector(6 downto 0)
				);
			end component;
			
			component counter is
				port(
					bcd	: out std_logic_vector(3 downto 0);
					clk	: in std_logic;
					reset	: in std_logic
				);
			end component;
			
			
			component clk_divider is
				generic(
					multiplier 	: integer
				);
				port(
					clk_in 		: in std_logic;
					clk_out		: out std_logic
				);
			end component;
			
			component Clock is
				port(
					clk: in std_logic;
					a0,a1,a2,a3 : out std_logic_vector(3 downto 0)
				);
			end component;
			 
			component Cronometer is
				port(
					clk: in std_logic;
					a0,a1,a2,a3 : out std_logic_vector(3 downto 0);
					reset	: in std_logic
				);
			end component;
			
			component teclado is
				port(
					PS2_CLK : in std_logic;
					PS2_DAT: in std_logic;
					ps2_code: out std_logic_vector(7 downto 0);
					has_data: out std_logic
				);
			end component;
			
			component key_decoder is
				port(
					code : in std_logic_vector(7 downto 0);
					seletor : out std_logic_vector(1 downto 0);
					crono_reset : out std_logic;
					clock_fast : out std_logic;
					alarm_fast : out std_logic
				);
			end component;
			
			component alarm is
				port(
					ac0,ac1,ac2,ac3 : in std_logic_vector(3 downto 0);
					ad0,ad1,ad2,ad3 : out std_logic_vector(3 downto 0);
					clk	: in std_logic;
					buzzer	: out std_logic
				);
			end component;
			
			component pulse is
				port(
					clk	: in std_logic;
					pulse_in	: in std_logic;
					pulse_out: out std_logic
				);
			end component;
			
	signal a0,a1,a2,a3 : std_logic_vector(3 downto 0);
	signal ac0,ac1,ac2,ac3 : std_logic_vector(3 downto 0);
	signal aw0,aw1,aw2,aw3 : std_logic_vector(3 downto 0);
	signal ad0,ad1,ad2,ad3 : std_logic_vector(3 downto 0);
	signal reset0,reset1,reset2,reset3,aux: std_logic;
	signal clk_1,clk_10, clk_r,clk_a : std_logic;
	
	signal crono_reset,clock_fast,alarm_fast : std_logic;
		
	signal seletor : std_logic_vector(1 downto 0);
	
	signal ps2_data : std_logic_vector(7 downto 0);
	signal has_data : std_logic;
	
	signal buzzer_in,buzzer_out : std_logic;
	
begin

	tel : teclado
		port map(
			PS2_CLK,
			PS2_DAT,
			ps2_data,
			has_data
		);
	
	decod : key_decoder 
		port map(
			ps2_data,
			seletor,
			crono_reset,
			clock_fast,
			alarm_fast
		);
		

LEDR(1 downto 0) <= seletor;

	rel : Clock
		port map(
			clk_r,
			ac0,ac1,ac2,ac3
		);
		
	clk_r <= 
		clk_10 when clock_fast = '1' else clk_1;
	
	crono : Cronometer
		port map(
			clk_10,
			aw0,aw1,aw2,aw3,
			crono_reset
		);
		
	alarme : alarm
		port map(
			ac0,ac1,ac2,ac3,
			ad0,ad1,ad2,ad3,
			clk_a,
			buzzer_in
		);
		
	p : pulse
		port map(
			clk_1,
			buzzer_in,
			buzzer_out
		);
		
	LEDR(9) <= buzzer_out;
	GPIO_0(0) <= buzzer_out;
		
	clk_a <= 
		clk_10 when alarm_fast = '1' else '0';
	
	a0 <=
		ac0 when seletor = "00" else
		aw0 when seletor = "01" else
		ad0 when seletor = "10";
	
	a1 <=
		ac1 when seletor = "00" else
		aw1 when seletor = "01" else
		ad1 when seletor = "10";
		
	a2 <=
		ac2 when seletor = "00" else
		aw2 when seletor = "01" else
		ad2 when seletor = "10";
		
	a3 <=
		ac3 when seletor = "00" else
		aw3 when seletor = "01" else
		ad3 when seletor = "10";
		

		
clk_gen1 : clk_divider
	generic map(250000_00)
	port map(
		CLOCK_50,
		clk_1
	);
	
clk_gen10 : clk_divider
	generic map(250000)
	port map(
		CLOCK_50,
		clk_10
	);

hex_display0 : bcd_7seg_decoder
	port map(
		a0,
		HEX0
	);
	
hex_display1 : bcd_7seg_decoder
	port map(
		a1,
		HEX1
	);
	
hex_display2 : bcd_7seg_decoder
	port map(
		a2,
		HEX2
	);
	
hex_display3 : bcd_7seg_decoder
	port map(
		a3,
		HEX3
	);

end;