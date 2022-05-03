library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_div1 is
Port ( CLK : in  std_logic;
       div : out std_logic := '0');
end clock_div1;

architecture Behavioral of clock_div1 is
signal counter: std_logic_vector(6 downto 0) := (others => '0');
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            counter <= std_logic_vector(unsigned(counter)+1);
            if (counter="1111100") then
                div <= '1';
                counter <= "0000000";
            else
                div <= '0';
            end if;
        end if;
    end process;

end Behavioral;