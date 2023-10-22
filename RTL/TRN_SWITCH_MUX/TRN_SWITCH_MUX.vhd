library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity TRN_SWITCH_MUX is
    generic (
        DATA_WIDTH : integer := 32
    );
    Port ( 
        clk : in std_logic;
        data_in_ld : in std_logic_vector(DATA_WIDTH-1 downto 0);
        data_in_hs : in std_logic_vector(DATA_WIDTH-1 downto 0);
        sw_status : in std_logic;
        data_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
        --out_resetn : out std_logic
    );
end TRN_SWITCH_MUX;

architecture Behavioral of TRN_SWITCH_MUX is
    signal data_out_temp_ld : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal data_out_temp_hs : std_logic_vector(DATA_WIDTH-1 downto 0);
begin
    P_PORT_SWTICH: process(clk) begin
        if rising_edge(clk) then
            if (sw_status = '0') then -- Low delay filter
                data_out_temp_ld <= data_in_ld; -- assuming filter_1 is your first FIR filter
                data_out_temp_hs <= (others => '0');
                --out_resetn <= '1';
         
            else  -- High sensitivity filter
                data_out_temp_hs <= data_in_hs; -- assuming filter_2 is your second FIR filter
                data_out_temp_ld <= (others => '0');
                --out_resetn <= '1';
            end if;
        end if;
    end process P_PORT_SWTICH;
    
    data_out <= data_out_temp_ld when sw_status = '0' else data_out_temp_hs;
    
end Behavioral;