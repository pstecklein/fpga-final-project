----------------------------------------------------------------------------------
-- Company: Digilent Inc.
-- Engineer: Ryan Kim
-- 
-- Create Date:    14:35:33 10/10/2011 
-- Module Name:    PmodOLEDCtrl - Behavioral 
-- Project Name:   PmodOLED Demo
-- Tool versions:  ISE 13.2
-- Description:    Top level controller that controls the PmodOLED blocks
--
-- Revision: 1.1
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;
entity PmodOLEDCtrl is
	Port ( 
		CLK 	: in  STD_LOGIC;
		RST 	: in  STD_LOGIC;
		player_health_oled     : in std_logic_vector(7 downto 0);
                computer_health_oled   : in std_logic_vector(7 downto 0);
                player_strength_oled   : in std_logic_vector(7 downto 0);
                computer_strength_oled : in std_logic_vector(7 downto 0);
                player_luck_oled       : in std_logic_vector(7 downto 0);
                computer_luck_oled     : in std_logic_vector(7 downto 0);
		CS  	: out STD_LOGIC;
		SDIN	: out STD_LOGIC;
		SCLK	: out STD_LOGIC;
		DC	: out STD_LOGIC;
		RES	: out STD_LOGIC;
		VBAT	: out STD_LOGIC;
		VDD	: out STD_LOGIC);
end PmodOLEDCtrl;

architecture Behavioral of PmodOLEDCtrl is

component OledInit is
Port (          CLK 	: in  STD_LOGIC;
		RST 	: in  STD_LOGIC;
		EN	: in  STD_LOGIC;
		CS  	: out STD_LOGIC;
		SDO	: out STD_LOGIC;
		SCLK	: out STD_LOGIC;
		DC	: out STD_LOGIC;
		RES	: out STD_LOGIC;
		VBAT	: out STD_LOGIC;
		VDD	: out STD_LOGIC;
		FIN     : out STD_LOGIC);
end component;

component OledEx is
    Port ( CLK 	: in  STD_LOGIC;
		RST 	: in STD_LOGIC;
		player_health0, player_health1, computer_health0, computer_health1: in std_logic_vector(7 downto 0);
		player_strength0, player_strength1, computer_strength0, computer_strength1: in std_logic_vector(7 downto 0);
		player_luck0, player_luck1, computer_luck0, computer_luck1: in std_logic_vector(7 downto 0);
		EN	: in  STD_LOGIC;
		CS  	: out STD_LOGIC;
		SDO	: out STD_LOGIC;
		SCLK	: out STD_LOGIC;
		DC	: out STD_LOGIC;
		FIN     : out STD_LOGIC);
end component;

type states is (Idle,OledInitialize,OledExample,Done);

signal current_state : states := Idle;

signal init_en				: STD_LOGIC := '0';
signal init_done			: STD_LOGIC;
signal init_cs				: STD_LOGIC;
signal init_sdo			        : STD_LOGIC;
signal init_sclk			: STD_LOGIC;
signal init_dc				: STD_LOGIC;

signal example_en			: STD_LOGIC := '0';
signal example_cs			: STD_LOGIC;
signal example_sdo		        : STD_LOGIC;
signal example_sclk		        : STD_LOGIC;
signal example_dc			: STD_LOGIC;
signal example_done		        : STD_LOGIC;

signal player_health0, player_health1, computer_health0, computer_health1: std_logic_vector(7 downto 0);
signal player_strength0, player_strength1, computer_strength0, computer_strength1: std_logic_vector(7 downto 0);
signal player_luck0, player_luck1, computer_luck0, computer_luck1: std_logic_vector(7 downto 0);

begin

        player_health0 <= std_logic_vector((unsigned(player_health_oled) / 10) + 48);
	player_health1 <= std_logic_vector((unsigned(player_health_oled) mod 10) + 48);
	computer_health0 <= std_logic_vector((unsigned(computer_health_oled) / 10) + 48);
	computer_health1 <= std_logic_vector((unsigned(computer_health_oled) mod 10) + 48);

	player_strength0 <= std_logic_vector((unsigned(player_strength_oled) / 10) + 48);
	player_strength1 <= std_logic_vector((unsigned(player_strength_oled) mod 10) + 48);
	computer_strength0 <= std_logic_vector((unsigned(computer_strength_oled) / 10) + 48);
	computer_strength1 <= std_logic_vector((unsigned(computer_strength_oled) mod 10) + 48);

	player_luck0 <= std_logic_vector((unsigned(player_luck_oled) / 10) + 48);
	player_luck1 <= std_logic_vector((unsigned(player_luck_oled) mod 10) + 48);
	computer_luck0 <= std_logic_vector((unsigned(computer_luck_oled) / 10) + 48);
	computer_luck1 <= std_logic_vector((unsigned(computer_luck_oled) mod 10) + 48);
    
	Init: OledInit port map(CLK, RST, init_en, init_cs, init_sdo, init_sclk, init_dc, RES, VBAT, VDD, init_done);
	Example: OledEx Port map(CLK, RST, player_health0, player_health1, computer_health0, computer_health1, player_strength0, player_strength1, computer_strength0, computer_strength1, player_luck0, player_luck1, computer_luck0, computer_luck1, example_en, example_cs, example_sdo, example_sclk, example_dc, example_done);
	
	--MUXes to indicate which outputs are routed out depending on which block is enabled
	CS <= init_cs when (current_state = OledInitialize) else
			example_cs;
	SDIN <= init_sdo when (current_state = OledInitialize) else
			example_sdo;
	SCLK <= init_sclk when (current_state = OledInitialize) else
			example_sclk;
	DC <= init_dc when (current_state = OledInitialize) else
			example_dc;
	--END output MUXes
	
	--MUXes that enable blocks when in the proper states
	init_en <= '1' when (current_state = OledInitialize) else
					'0';
	example_en <= '1' when (current_state = OledExample) else
					'0';
	--END enable MUXes
	

	process(CLK)
	begin
		if(rising_edge(CLK)) then
			if(RST = '1') then
				current_state <= Idle;
			else
				case(current_state) is
					when Idle =>
						current_state <= OledInitialize;
					--Go through the initialization sequence
					when OledInitialize =>
						if(init_done = '1') then
							current_state <= OledExample;
						end if;
					--Do example and Do nothing when finished
					when OledExample =>
						if(example_done = '1') then
							current_state <= Done;
						end if;
					--Do Nothing
					when Done =>
						current_state <= Done;
					when others =>
						current_state <= Idle;
				end case;
			end if;
		end if;
	end process;
	
	
end Behavioral;
