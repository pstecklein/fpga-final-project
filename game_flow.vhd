library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity game_flow is
    port ( clk,en,rst,btn,game_over,ready : in  std_logic;
                                  setting : in  std_logic_vector(2 downto 0);
                             off,go,pause : out std_logic);
end game_flow;

architecture fsm of game_flow is

    type state is (idle, new_move, player_move, player_wait, player_result, player_cooldown, computer_move, computer_wait, computer_result, computer_cooldown, finish);
    signal curr : state := idle;
    

begin

    process(clk)
    begin
        if rising_edge(clk) then
    
            -- restart game
            if rst = '1' then
                pause <= '1';
                curr <= idle;
                
            elsif en = '1' then
                case curr is
    
                    when idle =>
                        pause <= '0';
                        go <= '0';
                        curr <= new_move;
                        
                    when new_move =>
                        curr <= player_move;
                    
                    when player_move =>
                        off <= '1';
                        if btn = '1' then
                            if setting(0) = '1' or setting(1) = '1' or setting(2) = '1' then
                                go <= '1';
                                curr <= player_wait;
                            end if;
                        end if;
                        
                    when player_wait =>
                        go <= '0';
                        pause <= '1';
                        curr <= player_result;
                        
                    when player_result =>
                        pause <= '0';
                        if game_over = '1' then
                            curr <= finish;
                        else
                            curr <= player_cooldown;
                        end if;
                        
                    when player_cooldown =>
                        if ready = '1' then
                            curr <= computer_move;
                        end if;
                    
                    when computer_move =>
                        off <= '0';
                        if btn = '1' then
                            if setting(0) = '1' or setting(1) = '1' or setting(2) = '1' then
                                go <= '1';
                                curr <= computer_wait;
                            end if;
                        end if;
                        
                    when computer_wait =>
                        go <= '0';
                        pause <= '1';
                        curr <= computer_result;
                        
                    when computer_result =>
                        pause <= '0';
                        if game_over = '1' then
                            curr <= finish;
                        else
                            curr <= computer_cooldown;
                        end if;
                        
                    when computer_cooldown =>
                        if ready = '1' then
                            curr <= new_move;
                        end if;
                    
                    when finish =>
                        pause <= '1';
                        curr <= idle;
                    
                    when others =>
                        curr <= idle;
    
                end case;
            end if;
    
        end if;
    end process;

end fsm;
