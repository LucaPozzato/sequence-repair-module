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
    type state_type is (RST_STATE, DONE_STATE, WAIT_STATE, INIT_STATE, WAIT_FOR_MEM_STATE, WAIT_FOR_MEM_STATE_2,  READ_STATE, WRITE_MEM_STATE, WRITE_CRED_STATE);

    signal k: std_logic_vector(9 downto 0);
    signal addr: std_logic_vector(15 downto 0);
    signal data, cred: std_logic_vector(7 downto 0); 
    signal current_state: state_type;

    begin
        design: process(i_clk, i_rst)
        variable temp_addr: UNSIGNED(15 downto 0);
        variable temp_k: UNSIGNED(9 downto 0);
        variable temp_data: UNSIGNED(7 downto 0);

        begin
            if i_rst = '1' then
                --state
                current_state <= RST_STATE;
                --lambda
                addr <= (others => '0');
                cred <= (others => '0');
                k <= (others => '0');
                data <= (others => '0');
                --delta
                o_done <= '0';            
                o_mem_addr <= (others => '0');
                o_mem_data <= (others => '0');
                o_mem_we <= '0';
                o_mem_en <= '0';

            elsif rising_edge(i_clk) then
                --lambda
                addr <= (others => '0');
                cred <= (others => '0');
                k <= (others => '0');
                data <= (others => '0');
                --delta
                o_done <= '0';            
                o_mem_addr <= (others => '0');
                o_mem_data <= (others => '0');
                o_mem_we <= '0';
                o_mem_en <= '0';

                case current_state is
                    when RST_STATE =>
                        if i_rst = '0' then 
                            current_state <= WAIT_STATE;
                        else
                            current_state <= RST_STATE;
                        end if;

                    when WAIT_STATE =>
                        if i_start = '1' then
                            k <= i_k;
                            addr <= i_add;
                            cred <= "00011111";
                            current_state <= INIT_STATE;
                        else 
                            current_state <= WAIT_STATE;
                        end if;
                    
                    when INIT_STATE =>
                        if k = "0000000000" then
                            --lambda
                            current_state <= DONE_STATE;
                            --delta
                            o_done <= '1';
                        else
                            --lambda
                            temp_data := UNSIGNED(data);
                            data <= std_logic_vector(temp_data);
                            temp_addr := UNSIGNED(addr);
                            temp_k := UNSIGNED(k);
                            temp_data := UNSIGNED(cred);
                            addr <= std_logic_vector(temp_addr);
                            k <= std_logic_vector(temp_k);
                            cred <= std_logic_vector(temp_data);
                            current_state <= WAIT_FOR_MEM_STATE;
                            --delta
                            o_mem_addr <= addr;
                            o_mem_data <= data;
                            o_mem_en <= '1';
                        end if;
                    
                    when WAIT_FOR_MEM_STATE =>
                        --lambda
                        temp_data := UNSIGNED(data);
                        data <= std_logic_vector(temp_data);
                        temp_addr := UNSIGNED(addr);
                        temp_k := UNSIGNED(k);
                        temp_data := UNSIGNED(cred);
                        addr <= std_logic_vector(temp_addr);
                        k <= std_logic_vector(temp_k);
                        cred <= std_logic_vector(temp_data);
                        current_state <= WAIT_FOR_MEM_STATE_2;
                        --delta
                        o_mem_addr <= addr;
                        o_mem_data <= data;
                        o_mem_en <= '1';

                    when WAIT_FOR_MEM_STATE_2 =>
                        --lambda
                        temp_data := UNSIGNED(data);
                        data <= std_logic_vector(temp_data);
                        temp_addr := UNSIGNED(addr);
                        temp_k := UNSIGNED(k);
                        temp_data := UNSIGNED(cred);
                        addr <= std_logic_vector(temp_addr);
                        k <= std_logic_vector(temp_k);
                        cred <= std_logic_vector(temp_data);
                        current_state <= READ_STATE;
                        --delta
                        o_mem_addr <= addr;
                        o_mem_data <= data;
                        o_mem_en <= '1';

                    when READ_STATE =>
                        --lambda
                        temp_addr := UNSIGNED(addr);
                        addr <= std_logic_vector(addr);
                        
                        if i_add = addr then
                            if UNSIGNED(i_mem_data) /= 0 then
                                data <= i_mem_data;
                                cred <= "00011111";
                            end if;
                        else
                            if UNSIGNED(i_mem_data) = 0 then
                                temp_data := UNSIGNED(data);
                                data <= std_logic_vector(temp_data);
                                temp_data := UNSIGNED(cred);
                                if temp_data > 0 then
                                    cred <= std_logic_vector(temp_data - 1);
                                end if;
                            else
                                data <= i_mem_data;
                                cred <= "00011111";
                            end if;
                        end if;
                        
                        temp_k := UNSIGNED(k) - 1;
                        k <= std_logic_vector(temp_k);
                        
                        current_state <= WRITE_MEM_STATE;
                        --delta
                        o_mem_addr <= addr;
                        o_mem_data <= data;
                        o_mem_en <= '1';
                        o_mem_we <= '1';

                    when WRITE_MEM_STATE =>
                        --lambda
                        temp_addr := UNSIGNED(addr) + 1;
                        addr <= std_logic_vector(temp_addr);
                        temp_data := UNSIGNED(data);
                        data <= std_logic_vector(temp_data);
                        temp_k := UNSIGNED(k);
                        k <= std_logic_vector(temp_k);
                        temp_data := UNSIGNED(cred);
                        cred <= std_logic_vector(temp_data);
                        current_state <= WRITE_CRED_STATE;
                        --delta
                        o_mem_addr <= addr;
                        o_mem_data <= data;
                        o_mem_en <= '1';
                        o_mem_we <= '1';

                    when WRITE_CRED_STATE =>
                        --lambda
                        temp_addr := UNSIGNED(addr) + 1;
                        addr <= std_logic_vector(temp_addr);
                        temp_data := UNSIGNED(data);
                        data <= std_logic_vector(temp_data);
                        temp_k := UNSIGNED(k);
                        k <= std_logic_vector(temp_k);
                        temp_data := UNSIGNED(cred);
                        cred <= std_logic_vector(temp_data);
                        current_state <= INIT_STATE;
                        --delta
                        o_mem_addr <= addr;
                        o_mem_data <= cred;
                        o_mem_en <= '1';
                        o_mem_we <= '1';

                    when DONE_STATE =>
                        --lambda
                        if i_start = '0' then
                            current_state <= WAIT_STATE;
                        else
                            current_state <= DONE_STATE;
                        end if;
                        --delta
                        o_done <= '1';

                    when others =>
                        current_state <= RST_STATE;

                end case;

            end if;

        end process;
end project_arch;