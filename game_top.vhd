library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity game_top is
    Port (  clk : in  std_logic;
            btn : in  std_logic_vector(1 downto 0);
             sw : in  std_logic_vector(2 downto 0);
            --ssd : out std_logic_vector(19 downto 0);
          
            CS  	: out STD_LOGIC;
            SDIN	: out STD_LOGIC;
            SCLK	: out STD_LOGIC;
            DC	    : out STD_LOGIC;
            RES  	: out STD_LOGIC;
            VBAT	: out STD_LOGIC;
            VDD 	: out STD_LOGIC);
end game_top;

architecture Structural of game_top is
    component clock_div is 
        Port (clk : in  std_logic;
              div : out std_logic);
    end component;
    component clock_div1 is 
        Port (clk : in  std_logic;
              div : out std_logic);
    end component;
    component debounce is 
        Port ( clk : in  std_logic;
               btn : in  std_logic;
              dbnc : out std_logic);
    end component;
    component game_flow is 
        Port ( clk,en,rst,btn,game_over,ready : in  std_logic;
                                      setting : in  std_logic_vector(2 downto 0);
                                 go,off,pause : out std_logic);
    end component;
    component move_calculator is 
        Port (        clk,en,rst,offense,start : in  std_logic;
                                 player_choice : in  std_logic_vector (2 downto 0);
                                     game_over : out std_logic; -- let game_flow know if game is over
                                  p_h_r, c_h_r : out std_logic_vector(7 downto 0);
                                  p_s_r, c_s_r : out std_logic_vector(7 downto 0);
                                  p_l_r, c_l_r : out std_logic_vector(7 downto 0)); 
    
    end component;
    component cooldown_counter is
        Port ( clk, en, start : in std_logic;
                        ready : out std_logic
                --seven_seg_out : out std_logic_vector(19 downto 0)
                );
    end component;
    
    component PmodOLEDCtrl is
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
            DC		: out STD_LOGIC;
            RES  	: out STD_LOGIC;
            VBAT	: out STD_LOGIC;
            VDD 	: out STD_LOGIC);
    end component;
    
    signal div_res : std_logic;
    signal div_res1 : std_logic;
    signal debounce_res : std_logic;
    signal debounce_res1 : std_logic;
    signal is_offense : std_logic;
    signal game_over_signal: std_logic;
    signal go_signal: std_logic;
    signal cooldown_start : std_logic;
    signal cooldown_finished : std_logic;
    signal player_move : std_logic_vector(2 downto 0);
    signal p_h_r_signal : std_logic_vector(7 downto 0);
    signal c_h_r_signal : std_logic_vector(7 downto 0);
    signal p_s_r_signal : std_logic_vector(7 downto 0);
    signal c_s_r_signal : std_logic_vector(7 downto 0);
    signal p_l_r_signal : std_logic_vector(7 downto 0);
    signal c_l_r_signal : std_logic_vector(7 downto 0);
    
begin              

    u1 : clock_div port map ( 
        clk => clk,
        div => div_res);

    u2 : clock_div1 port map (
        clk => clk,
        div => div_res1);
        
    u3 : debounce port map (
        clk => clk,
        btn => btn(0),
        dbnc => debounce_res);
        
    u4 : debounce port map (
        clk => clk,
        btn => btn(1),
        dbnc => debounce_res1);
              
    u5 : game_flow port map (
        clk => clk,
        en => div_res1,
        rst => debounce_res1,
        btn => debounce_res,
        ready => cooldown_finished,
        game_over => game_over_signal,
        go => go_signal,
        setting => sw,
        pause => cooldown_start,
        off => is_offense);
    
    u6 : move_calculator port map (
        clk => clk,
        en => div_res,
        rst => debounce_res1,
        offense => is_offense,
        start => go_signal,
        player_choice => sw,
        p_h_r => p_h_r_signal,
        c_h_r => c_h_r_signal,
        p_s_r => p_s_r_signal,
        c_s_r => c_s_r_signal,
        p_l_r => p_l_r_signal,
        c_l_r => c_l_r_signal,
        game_over => game_over_signal);
        
    u8 : cooldown_counter port map (
        clk => clk,
        en => div_res1,
        start => cooldown_start,
        ready => cooldown_finished
        --seven_seg_out => ssd
        );
        
        
    PmodOLED : PmodOLEDCtrl port map ( 
        CLK => clk,
        RST => debounce_res1,
        
        player_health_oled => p_h_r_signal,
        computer_health_oled => c_h_r_signal,
        player_strength_oled => p_s_r_signal,
        computer_strength_oled => c_s_r_signal,
        player_luck_oled => p_l_r_signal,
        computer_luck_oled => c_l_r_signal,
    
        CS => CS,
        SDIN => SDIN,
        SCLK => SCLK,
        DC => DC,
        RES => RES,
        VBAT => VBAT,
        VDD => VDD);
            
end Structural;