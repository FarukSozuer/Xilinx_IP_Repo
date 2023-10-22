library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity TRN_2X1_MUX is
generic
(
	DATA_WIDTH : integer := 30
);
Port ( 

	clk : in std_logic;
	data_in_i: in std_logic_vector(DATA_WIDTH-1 downto 0);
	data_in_q: in std_logic_vector(DATA_WIDTH-1 downto 0);
	data_out : out std_logic_vector(DATA_WIDTH-1 downto 0);
	
	i_data_ready : out std_logic;
	q_data_ready : out std_logic
);
end TRN_2X1_MUX;

architecture Behavioral of TRN_2X1_MUX is
   signal data_selection : std_logic;
begin
	
	P_PORT_SWTICH:process(clk) begin
		if rising_edge(clk) then				
			data_selection <= not data_selection;
						
			case (data_selection) is
				when '0' =>
					data_out <= data_in_i;
					i_data_ready <= '1';
					q_data_ready <= '0';
				when '1' =>
					data_out <= data_in_q;
					i_data_ready <= '0';
					q_data_ready <= '1';
			end case;
	    end if;		
	end process P_PORT_SWTICH;

end Behavioral;
