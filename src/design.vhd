----------------------------------------------------------------------------------
-- Project Name: Project for Logic Circuit Design
-- Authors: Luca Pozzato, Andrea Rossi
-- Year: 2023/2024
----------------------------------------------------------------------------------

library IEEE;   
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity project_reti_logiche is
    port (
            i_clk : in std_logic;
            i_rst : in std_logic;
            i_start : in std_logic;
            i_add : in std_logic_vector(15 downto 0);
            i_k   : in std_logic_vector(9 downto 0);
            
            o_done : out std_logic;
            
            o_mem_addr : out std_logic_vector(15 downto 0);
            i_mem_data : in  std_logic_vector(7 downto 0);
            o_mem_data : out std_logic_vector(7 downto 0);
            o_mem_we   : out std_logic;
            o_mem_en   : out std_logic
    );
end project_reti_logiche;

architecture project_arch of project_reti_logiche is
    type state_type is (RST_STATE, DONE_STATE, WAIT_STATE, INIT_STATE, READ_STATE, WRITE_MEM_STATE, WRITE_CRED_STATE);

    signal k: std_logic_vector(9 downto 0);
    signal addr: std_logic_vector(15 downto 0);
    signal data, cred: std_logic_vector(7 downto 0); 
    signal next_state, current_state: state_type;

    begin
    -- change state process
        state_reg: process(i_clk, i_rst)
        begin
            if i_rst = '1' then
                current_state <= RST_STATE;
                -- rising_edge needs to be last elsif
            elsif rising_edge(i_clk) then
                current_state <= next_state;
            end if;
        end process;

    -- lambda
        lambda: process(current_state, i_clk)
            variable temp_addr: SIGNED(15 downto 0);
            variable temp_k: SIGNED(9 downto 0);
            variable temp_cred: SIGNED(7 downto 0);
        -- possibilmente inizializzare segnali -> evitare latch
        begin
            case current_state is
                when RST_STATE =>
                    if i_rst = '0' then 
                        next_state <= WAIT_STATE;
                    else
                        next_state <= RST_STATE;
                    end if;
                    
                when WAIT_STATE =>
                    if i_start = '1' then
                        k <= i_k;
                        addr <= i_add;
                        cred <= "00011111";
                        next_state <= INIT_STATE;
                    else 
                        next_state <= WAIT_STATE;
                    end if;
                    
                when INIT_STATE =>
                    if k = "0000000000" then
                        next_state <= DONE_STATE;
                    else
                        next_state <= READ_STATE;
                        
                    end if;

                when READ_STATE =>
                    temp_cred := SIGNED(cred);

                    if i_add = addr then
                        if SIGNED(i_mem_data) = 0 then
                            data <= (others => '0');
                            cred <= (others => '0');
                        end if;
                    else
                        if SIGNED(i_mem_data) = 0 then
                            if temp_cred > 0 then
                                cred <= std_logic_vector(temp_cred - 1);
                            else 
                                cred <= (others => '0');
                            end if;
                        else
                            data <= i_mem_data;
                            cred <= "00011111";
                        end if;
                    end if;
                            
                    temp_k := SIGNED(k) - 1;
                    k <= std_logic_vector(temp_k);

                    next_state <= WRITE_MEM_STATE;
                
                when WRITE_MEM_STATE =>
                -- scrivo 
                    temp_addr := SIGNED(addr) + 1;
                    addr <= std_logic_vector(temp_addr);
                    next_state <= WRITE_CRED_STATE;
                
                when WRITE_CRED_STATE =>
                -- scrivo cred
                    temp_addr := SIGNED(addr) + 1;
                    addr <= std_logic_vector(temp_addr);
                    next_state <= INIT_STATE;

                when DONE_STATE =>
                    if i_start = '0' then
                        next_state <= WAIT_STATE;
                    else
                        next_state <= DONE_STATE;
                    end if;

                end case;
        end process;

    -- delta
    delta: process(current_state, i_clk)
    begin
        o_done <= '0';            
        o_mem_addr <= (others => '0');
        o_mem_data <= (others => '0');
        o_mem_we <= '0';
        o_mem_en <= '0';

        case current_state is
            when RST_STATE =>
                
            when WAIT_STATE =>
            
            when INIT_STATE =>
                if SIGNED(k) = 0 then
                    o_done <= '1';
                else 
                    o_mem_addr <= addr;
                    o_mem_data <= data;
                    o_mem_en <= '1';
                end if;
            
            when READ_STATE =>
                o_mem_addr <= addr;
                o_mem_data <= data;
                o_mem_en <= '1';
                o_mem_we <= '1';
            
            when WRITE_MEM_STATE =>
                o_mem_addr <= addr;
                o_mem_data <= cred;
                o_mem_en <= '1';
                o_mem_we <= '1';

            when WRITE_CRED_STATE =>
                
            when DONE_STATE =>
                o_done <= '1';

        end case;
    end process;
        
end project_arch;