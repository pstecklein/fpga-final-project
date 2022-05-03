library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debounce is
    Port ( clk : in  std_logic;
           btn : in  std_logic;
          dbnc : out std_logic);
end debounce;

architecture Behavioral of debounce is
signal shift_reg: std_logic_vector(1 downto 0) := (others => '0');
signal counter: std_logic_vector(21 downto 0) := (others => '0');
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            shift_reg(1) <= shift_reg(0);
            if (btn='1') then
                shift_reg(0) <= '1';
                if (counter="1001100010010110011111") then
                    dbnc <= '1';
                elsif (shift_reg(1)='1') then
                    counter <= std_logic_vector(unsigned(counter)+1);
                end if;
            else
                shift_reg(0) <= '0';
                dbnc <= '0';
                counter <= "0000000000000000000000";
            end if;
        end if;
    end process;

end Behavioral;