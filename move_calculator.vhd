library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity move_calculator is
    port ( clk,en,rst,offense,start : in  std_logic;
                      player_choice : in  std_logic_vector (2 downto 0);
                          game_over : out std_logic; -- let game_flow know if game is over
                       p_h_r, c_h_r : out std_logic_vector(7 downto 0);
                       p_s_r, c_s_r : out std_logic_vector(7 downto 0);
                       p_l_r, c_l_r : out std_logic_vector(7 downto 0)); 
end move_calculator;

architecture Behavioral of move_calculator is

    type state is (idle, player_jab, player_jab_setup, player_jab_calculate, player_jab_update, player_dive, player_dive_setup, player_dive_calculate, player_dive_update, player_special, player_special_setup, player_special_calculate, player_special_update, player_health_potion, player_health_potion_setup, player_health_potion_calculate, player_health_potion_update, player_strength_potion, player_strength_potion_setup, player_strength_potion_calculate, player_strength_potion_update, player_luck_potion, player_luck_potion_setup, player_luck_potion_calculate, player_luck_potion_update, player_block, player_block_setup, player_block_calculate, player_block_update, player_dodge, player_dodge_setup, player_dodge_calculate, player_dodge_update, player_counter, player_counter_setup, player_counter_calculate, player_counter_update, restart_game, finish);
    signal curr : state := idle;
    
    signal player_stats : std_logic_vector(23 downto 0) := "000000000000000001100011";
    signal computer_stats : std_logic_vector(23 downto 0) := "000000000000000001100011";
    
    signal seed : std_logic_vector(7 downto 0) := "10101010";
    

begin

    p_h_r <= player_stats(7 downto 0);
    c_h_r <= computer_stats(7 downto 0);
    p_s_r <= player_stats(15 downto 8);
    c_s_r <= computer_stats(15 downto 8);
    p_l_r <= player_stats(23 downto 16);
    c_l_r <= computer_stats(23 downto 16);

    process(clk)
    begin
        if rising_edge(clk) then
            seed <= std_logic_vector((unsigned(seed) + 1));
            if rst = '1' then
               seed <= "10101010";
               game_over <= '1';
               curr <= restart_game;
            elsif en = '1' then
                    case curr is
    
                        when idle =>
                            game_over <= '0';
                            if start = '1' then
                                if player_choice(0) = '1' or player_choice(1) = '1' or player_choice(2) = '1' then
                                    if offense = '1' then
                                        if player_choice = "001" then      -- jab
                                            curr <= player_jab;
                                        elsif player_choice = "010" then   -- dive
                                            curr <= player_dive;
                                        elsif player_choice = "011" then   -- special
                                            curr <= player_special;
                                        elsif player_choice = "100" then   -- health
                                            curr <= player_health_potion;
                                        elsif player_choice = "101" then   -- strength
                                            curr <= player_strength_potion;
                                        else -- luck
                                            curr <= player_luck_potion;
                                        end if;
                                    else
                                        if player_choice = "001" then    -- block
                                            curr <= player_block;
                                        elsif player_choice = "010" then -- dodge
                                            curr <= player_dodge;
                                        else                             -- counter
                                            curr <= player_counter;
                                        end if;
                                    end if;
                                else
                                    curr <= idle;
                                end if;
                            end if;
                        
                        when player_jab =>
                            curr <= player_jab_setup;
                            
                        when player_jab_setup =>
                            curr <= player_jab_calculate;
                            
                        when player_jab_calculate =>
                            if unsigned(player_stats(15 downto 8)) > 2 then
                                if (unsigned(computer_stats(7 downto 0)) <= 8) then
                                    game_over <= '1';
                                    curr <= restart_game;
                                else
                                    computer_stats(7 downto 0) <= std_logic_vector(unsigned(computer_stats(7 downto 0))-8);
                                    curr <= player_jab_update;
                                end if;
                            elsif unsigned(player_stats(15 downto 8)) > 0 then
                                if (unsigned(computer_stats(7 downto 0)) <= 6) then
                                    game_over <= '1';
                                    curr <= restart_game;
                                else
                                    computer_stats(7 downto 0) <= std_logic_vector(unsigned(computer_stats(7 downto 0))-6);
                                    curr <= player_jab_update;
                                end if;
                            else
                                if (unsigned(computer_stats(7 downto 0)) <= 4) then
                                    game_over <= '1';
                                    curr <= restart_game;
                                else
                                    computer_stats(7 downto 0) <= std_logic_vector(unsigned(computer_stats(7 downto 0))-4);
                                    curr <= player_jab_update;
                                end if;
                            end if;
                        
                        when player_jab_update =>
                            curr <= finish;
                            
                         when player_dive =>
                            curr <= player_dive_setup;
                            
                        when player_dive_setup =>
                            curr <= player_dive_calculate;
                            
                        when player_dive_calculate =>
                            if seed(0) = '1' then
                                if unsigned(player_stats(15 downto 8)) > 2 then
                                    if (unsigned(computer_stats(7 downto 0)) <= 16) then
                                        game_over <= '1';
                                        curr <= restart_game;
                                    else
                                        computer_stats(7 downto 0) <= std_logic_vector(unsigned(computer_stats(7 downto 0))-16);
                                        curr <= player_dive_update;
                                    end if;
                                elsif unsigned(player_stats(15 downto 8)) > 0 then
                                    if (unsigned(computer_stats(7 downto 0)) <= 12) then
                                        game_over <= '1';
                                        curr <= restart_game;
                                    else
                                        computer_stats(7 downto 0) <= std_logic_vector(unsigned(computer_stats(7 downto 0))-12);
                                        curr <= player_dive_update;
                                    end if;
                                else
                                    if (unsigned(computer_stats(7 downto 0)) <= 8) then
                                        game_over <= '1';
                                        curr <= restart_game;
                                    else
                                        computer_stats(7 downto 0) <= std_logic_vector(unsigned(computer_stats(7 downto 0))-8);
                                        curr <= player_dive_update;
                                    end if;
                                end if;
                            else
                                curr <= player_dive_update;
                            end if;
                        
                        when player_dive_update =>
                            curr <= finish;
                            
                        when player_special =>
                            curr <= player_special_setup;
                            
                        when player_special_setup =>
                            curr <= player_special_calculate;
                            
                        when player_special_calculate =>
                            if (seed(0)='1' and seed(1)='1' and seed(2)='1') or ((unsigned(player_stats(23 downto 16)) > 0) and (seed(0)='1' and seed(1)='1')) or ((unsigned(player_stats(23 downto 16)) > 2) and (seed(0)='1')) then
                                if unsigned(player_stats(15 downto 8)) > 2 then
                                    if (unsigned(computer_stats(7 downto 0)) <= 48) then
                                        game_over <= '1';
                                        curr <= restart_game;
                                    else
                                        computer_stats(7 downto 0) <= std_logic_vector(unsigned(computer_stats(7 downto 0))-48);
                                        curr <= player_special_update;
                                    end if;
                                elsif unsigned(player_stats(15 downto 8)) > 0 then
                                    if (unsigned(computer_stats(7 downto 0)) <= 32) then
                                        game_over <= '1';
                                        curr <= restart_game;
                                    else
                                        computer_stats(7 downto 0) <= std_logic_vector(unsigned(computer_stats(7 downto 0))-32);
                                        curr <= player_special_update;
                                    end if;
                                else
                                    if (unsigned(computer_stats(7 downto 0)) <= 16) then
                                        game_over <= '1';
                                        curr <= restart_game;
                                    else
                                        computer_stats(7 downto 0) <= std_logic_vector(unsigned(computer_stats(7 downto 0))-16);
                                        curr <= player_special_update;
                                    end if;
                                end if;
                            else
                                if (unsigned(player_stats(7 downto 0)) <= 6) then
                                    game_over <= '1';
                                    curr <= restart_game;
                                else
                                    player_stats(7 downto 0) <= std_logic_vector(unsigned(player_stats(7 downto 0))-6);
                                    curr <= player_special_update;
                                end if;
                            end if;
                        
                        when player_special_update =>
                            curr <= finish;
                            
                        when player_health_potion =>
                            curr <= player_health_potion_setup;
                            
                        when player_health_potion_setup =>
                            curr <= player_health_potion_calculate;
                            
                        when player_health_potion_calculate =>
                            if ((unsigned(player_stats(7 downto 0)) + 8) >= 99) then
                                player_stats(7 downto 0) <= "01100011";
                            else
                                player_stats(7 downto 0) <= std_logic_vector(unsigned(player_stats(7 downto 0))+8);
                            end if;
                            curr <= player_health_potion_update;
                        
                        when player_health_potion_update =>
                            curr <= finish;
                            
                        when player_strength_potion =>
                            curr <= player_strength_potion_setup;
                            
                        when player_strength_potion_setup =>
                            curr <= player_strength_potion_calculate;
                            
                        when player_strength_potion_calculate =>
                            if unsigned(player_stats(15 downto 8)) < 255 then
                                player_stats(15 downto 8) <= std_logic_vector(unsigned(player_stats(15 downto 8))+1);
                            end if;
                            curr <= player_strength_potion_update;
                        
                        when player_strength_potion_update =>
                            curr <= finish;
                            
                         when player_luck_potion =>
                            curr <= player_luck_potion_setup;
                            
                        when player_luck_potion_setup =>
                            curr <= player_luck_potion_calculate;
                            
                        when player_luck_potion_calculate =>
                            if unsigned(player_stats(23 downto 16)) < 255 then
                                player_stats(23 downto 16) <= std_logic_vector(unsigned(player_stats(23 downto 16))+1);
                            end if;
                            curr <= player_luck_potion_update;
                        
                        when player_luck_potion_update =>
                            curr <= finish;
                            
                        when player_block =>
                            curr <= player_block_setup;
                            
                        when player_block_setup =>
                            curr <= player_block_calculate;
                            
                        when player_block_calculate =>
                            if unsigned(computer_stats(15 downto 8)) > 0 then
                                if (unsigned(player_stats(7 downto 0)) <= 6) then
                                    game_over <= '1';
                                    curr <= restart_game;
                                else
                                    player_stats(7 downto 0) <= std_logic_vector(unsigned(player_stats(7 downto 0))-6);
                                    curr <= player_block_update;
                                end if;
                            else
                                if (unsigned(player_stats(7 downto 0)) <= 4) then
                                    game_over <= '1';
                                    curr <= restart_game;
                                else
                                    player_stats(7 downto 0) <= std_logic_vector(unsigned(player_stats(7 downto 0))-4);
                                    curr <= player_block_update;
                                end if;
                            end if;
                        
                        when player_block_update =>
                            curr <= finish;
                        
                        when player_dodge =>
                            curr <= player_dodge_setup;
                            
                        when player_dodge_setup =>
                            curr <= player_dodge_calculate;
                            
                        when player_dodge_calculate =>
                            if unsigned(computer_stats(15 downto 8)) > 0 then
                                if (unsigned(player_stats(7 downto 0)) <= 12) then
                                    game_over <= '1';
                                    curr <= restart_game;
                                else
                                    player_stats(7 downto 0) <= std_logic_vector(unsigned(player_stats(7 downto 0))-12);
                                    curr <= player_dodge_update;
                                end if;
                            else
                                if (unsigned(player_stats(7 downto 0)) <= 8) then
                                    game_over <= '1';
                                    curr <= restart_game;
                                else
                                    player_stats(7 downto 0) <= std_logic_vector(unsigned(player_stats(7 downto 0))-8);
                                    curr <= player_dodge_update;
                                end if;
                            end if;
                        
                        when player_dodge_update =>
                            curr <= finish;
                            
                        when player_counter =>
                            curr <= player_counter_setup;
                            
                        when player_counter_setup =>
                            curr <= player_counter_calculate;
                            
                        when player_counter_calculate =>
                            if unsigned(computer_stats(15 downto 8)) > 0 then
                                if (unsigned(player_stats(7 downto 0)) <= 32) then
                                    game_over <= '1';
                                    curr <= restart_game;
                                else
                                    player_stats(7 downto 0) <= std_logic_vector(unsigned(player_stats(7 downto 0))-32);
                                    curr <= player_counter_update;
                                end if;
                            else
                                if (unsigned(player_stats(7 downto 0)) <= 24) then
                                    game_over <= '1';
                                    curr <= restart_game;
                                else
                                    player_stats(7 downto 0) <= std_logic_vector(unsigned(player_stats(7 downto 0))-24);
                                    curr <= player_counter_update;
                                end if;
                            end if;
                        
                        when player_counter_update =>
                            curr <= finish;
                            
                        when restart_game =>
                            player_stats(7 downto 0) <= "01100011";
                            player_stats(15 downto 8) <= "00000000";
                            player_stats(23 downto 16) <= "00000000";
                            computer_stats(7 downto 0) <= "01100011";
                            computer_stats(15 downto 8) <= "00000000";
                            computer_stats(23 downto 16) <= "00000000";
                            curr <= finish;
                        
                        when finish =>
                            curr <= idle;
                    
                        when others =>
                            curr <= idle;
    
                    end case;  
            end if;
        end if;
    end process;

end Behavioral;
