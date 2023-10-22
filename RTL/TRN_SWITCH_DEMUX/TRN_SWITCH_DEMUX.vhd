library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity TRN_SWITCH_DEMUX is
generic 
(
    DATA_WIDTH : integer := 16
);

Port ( 

	clk : in std_logic;
	data_out: out std_logic_vector(DATA_WIDTH-1 downto 0);
	data_in_1 : in std_logic_vector(DATA_WIDTH-1 downto 0);
	data_in_2 : in std_logic_vector(DATA_WIDTH-1 downto 0);
	hs_filter_valid: out std_logic;
	sw_status : in std_logic
);
end TRN_SWITCH_DEMUX;

architecture Behavioral of TRN_SWITCH_DEMUX is

begin
	
	P_PORT_SWTICH:process(clk) begin
		if rising_edge(clk) then								
			if sw_status = '0' then
				data_out <= data_in_1;
				hs_filter_valid <= '0';
			elsif sw_status = '1' then		
				data_out <= data_in_2;
				hs_filter_valid <= '1';
			end if;
		end if;			
	end process P_PORT_SWTICH;

end Behavioral;