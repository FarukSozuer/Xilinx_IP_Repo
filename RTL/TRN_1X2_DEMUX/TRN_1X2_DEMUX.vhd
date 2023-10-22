library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity TRN_1X2_DEMUX is
generic 
(
    DATA_WIDTH : integer := 16
);

Port ( 

	clk : in std_logic;
	data_out_i: out std_logic_vector(DATA_WIDTH-1 downto 0);
	data_out_q: out std_logic_vector(DATA_WIDTH-1 downto 0);
	data_in : in std_logic_vector(DATA_WIDTH-1 downto 0);
	
	i_data_ready : in std_logic;
	q_data_ready : in std_logic
);
end TRN_1X2_DEMUX;

architecture Behavioral of TRN_1X2_DEMUX is

begin
	
	P_PORT_SWTICH:process(clk) begin
		if rising_edge(clk) then								
			if ( (i_data_ready <= '1') and (q_data_ready = '0') ) then 				
					data_out_i <= data_in;				
			end if;
			
			if ( (q_data_ready <= '1') and (i_data_ready = '0') ) then			
					data_out_q <= data_in;
			end if;	
		end if;			
	end process P_PORT_SWTICH;

end Behavioral;