library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_div is
Port ( CLK : in  std_logic;
       div : out std_logic := '0');
end clock_div;

architecture Behavioral of clock_div is
signal counter: std_logic_vector(4 downto 0) := (others => '0');
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            counter <= std_logic_vector(unsigned(counter)+1);
            if (counter="11000") then
                div <= '1';
                counter <= "00000";
            else
                div <= '0';
            end if;
        end if;
    end process;

end Behavioral;