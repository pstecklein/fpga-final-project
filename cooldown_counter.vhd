library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cooldown_counter is
    Port ( clk, en, start : in  std_logic;
                    ready : out std_logic;
            seven_seg_out : out std_logic_vector(19 downto 0));
end cooldown_counter;

architecture Behavioral of cooldown_counter is

    signal count : std_logic_vector(19 downto 0) := (others => '0');

begin

    seven_seg_out <= count;

    process(clk)
    begin
        if rising_edge(clk) then
            if en = '1' then
                if count = "11110100001000111111" then
                    if start = '1' then
                        count <= "00000000000000000000";
                        ready <= '0';
                    else
                        ready <= '1';
                    end if;
                else
                    count <= std_logic_vector(unsigned(count)+1);
                    ready <= '0';
                end if;
            end if;
        end if;
    end process;


end Behavioral;
