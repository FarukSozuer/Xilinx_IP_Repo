library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity TRN_ATNTR_AXI is
port
(
    rstn            : in std_logic;                         -- Synchronous Active High Reset
    clk             : in std_logic;                         -- Clock

	 -- Input Ports
    s_axis0_data_tdata : in std_logic_vector(31 downto 0);
	s_axis0_data_tvalid : in std_logic;
	s_axis0_data_tuser : in std_logic_vector(5 downto 0);      -- Power Reduction Value
	
    -- Output Ports 
    m_axis_data_tdata : out std_logic_vector(15 downto 0);
	m_axis_data_tready :in std_logic;
	m_axis_data_tuser : out std_logic;
	m_axis_data_tvalid : out std_logic
);

end entity TRN_ATNTR_AXI;

architecture Behavioral of TRN_ATNTR_AXI is

    signal data_in_wider    : std_logic_vector(25 downto 0);
    signal data_in_reduced  : std_logic_vector(19 downto 0);
    signal data_out_temp    : std_logic_vector(19 downto 0);

begin

    --data_in_reduced <= data_in(29 downto 10); 
    --data_in_wider   <= data_in_reduced(19) & data_in_reduced(19) & data_in_reduced(19) & data_in_reduced(19) & data_in_reduced(19) & data_in_reduced(19) & data_in_reduced;
    --data_out        <= data_out_temp(15 downto 0);
	
	data_in_reduced 	<= s_axis0_data_tdata(29 downto 10); 
    data_in_wider   	<= data_in_reduced(19) & data_in_reduced(19) & data_in_reduced(19) & data_in_reduced(19) & data_in_reduced(19) & data_in_reduced(19) & data_in_reduced;
    m_axis_data_tdata   <= data_out_temp(15 downto 0);

    P_PWR_RDCTN: process(clk) begin
        if rising_edge(clk) then
            if (rstn = '0') then
               data_out_temp   <= (others => '0');
            else
				if (s_axis0_data_tvalid = '1') then
					case (s_axis0_data_tuser) is
					when "000000" =>
						data_out_temp   <= data_in_reduced;

					when "000001" =>
						data_out_temp   <= std_logic_vector
						(
							(signed(data_in_wider(20 downto 01))) + 
							(signed(data_in_reduced(19 downto 02))) + 
							(signed(data_in_reduced(19 downto 03))) +
							(signed(data_in_reduced(19 downto 06))) +
							(signed(data_in_reduced(19 downto 11))) +
							(signed(data_in_reduced(19 downto 13)))
						);

					when "000010" =>
						data_out_temp   <= std_logic_vector
						(
							(signed(data_in_wider(20 downto 01))) + 
							(signed(data_in_reduced(19 downto 02))) + 
							(signed(data_in_reduced(19 downto 05))) +
							(signed(data_in_reduced(19 downto 07))) +
							(signed(data_in_reduced(19 downto 08))) +
							(signed(data_in_reduced(19 downto 10))) +
							(signed(data_in_reduced(19 downto 12))) +
							(signed(data_in_reduced(19 downto 13)))
						);

					when "000011" =>
						data_out_temp   <= std_logic_vector
						(
							(signed(data_in_wider(20 downto 01))) +
							(signed(data_in_reduced(19 downto 03))) +
							(signed(data_in_reduced(19 downto 04))) +
							(signed(data_in_reduced(19 downto 06))) +
							(signed(data_in_reduced(19 downto 08))) +
							(signed(data_in_reduced(19 downto 11))) +
							(signed(data_in_reduced(19 downto 12))) +
							(signed(data_in_reduced(19 downto 13))) +
							(signed(data_in_reduced(19 downto 15)))
						);

					when "000100" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(20 downto 01)) +
							signed(data_in_reduced(19 downto 03)) +
							signed(data_in_reduced(19 downto 08)) +
							signed(data_in_reduced(19 downto 09)) +
							signed(data_in_reduced(19 downto 14)) +
							signed(data_in_reduced(19 downto 15))
						);

					when "000101" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(20 downto 01)) +
							signed(data_in_reduced(19 downto 05)) +
							signed(data_in_reduced(19 downto 06)) +
							signed(data_in_reduced(19 downto 07)) +
							signed(data_in_reduced(19 downto 08)) +
							signed(data_in_reduced(19 downto 09)) +
							signed(data_in_reduced(19 downto 10)) +
							signed(data_in_reduced(19 downto 11)) +
							signed(data_in_reduced(19 downto 12)) +
							signed(data_in_reduced(19 downto 14))
						);

					when "000110" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(20 downto 01)) +
							signed(data_in_reduced(19 downto 10)) +
							signed(data_in_reduced(19 downto 13)) +
							signed(data_in_reduced(19 downto 14))
						);

					when "000111" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(21 downto 02)) +
							signed(data_in_reduced(19 downto 03)) +
							signed(data_in_reduced(19 downto 04)) +
							signed(data_in_reduced(19 downto 07)) +
							signed(data_in_reduced(19 downto 10)) +
							signed(data_in_reduced(19 downto 12)) +
							signed(data_in_reduced(19 downto 13))
						);

					when "001000" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(21 downto 02)) +
							signed(data_in_reduced(19 downto 03)) +
							signed(data_in_reduced(19 downto 06)) +
							signed(data_in_reduced(19 downto 08)) +
							signed(data_in_reduced(19 downto 09)) +
							signed(data_in_reduced(19 downto 10)) +
							signed(data_in_reduced(19 downto 11)) +
							signed(data_in_reduced(19 downto 13)) +
							signed(data_in_reduced(19 downto 15))
						);

					when "001001" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(21 downto 02)) +
							signed(data_in_reduced(19 downto 04)) +
							signed(data_in_reduced(19 downto 05)) +
							signed(data_in_reduced(19 downto 07)) +
							signed(data_in_reduced(19 downto 09)) +
							signed(data_in_reduced(19 downto 10)) +
							signed(data_in_reduced(19 downto 12)) +
							signed(data_in_reduced(19 downto 14))
						);

					when "001010" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(21 downto 02)) +
							signed(data_in_reduced(19 downto 04)) +
							signed(data_in_reduced(19 downto 09)) +
							signed(data_in_reduced(19 downto 10)) +
							signed(data_in_reduced(19 downto 11)) +
							signed(data_in_reduced(19 downto 12)) +
							signed(data_in_reduced(19 downto 14))
						);

					when "001011" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(21 downto 02)) +
							signed(data_in_reduced(19 downto 05)) +
							signed(data_in_reduced(19 downto 11)) +
							signed(data_in_reduced(19 downto 14)) +
							signed(data_in_reduced(19 downto 15))
						);

					when "001100" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(21 downto 02)) +
							signed(data_in_reduced(19 downto 10)) +
							signed(data_in_reduced(19 downto 13)) +
							signed(data_in_reduced(19 downto 14))
						);

					when "001101" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(22 downto 03)) +
							signed(data_in_reduced(19 downto 04)) +
							signed(data_in_reduced(19 downto 05)) +
							signed(data_in_reduced(19 downto 08)) +
							signed(data_in_reduced(19 downto 10)) +
							signed(data_in_reduced(19 downto 13)) +
							signed(data_in_reduced(19 downto 14)) +
							signed(data_in_reduced(19 downto 15))
						);

					when "001110" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(22 downto 03)) +
							signed(data_in_reduced(19 downto 04)) +
							signed(data_in_reduced(19 downto 07)) +
							signed(data_in_reduced(19 downto 08)) +
							signed(data_in_reduced(19 downto 12)) +
							signed(data_in_reduced(19 downto 14))
						);

					when "001111" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(22 downto 03)) +
							signed(data_in_reduced(19 downto 05)) +
							signed(data_in_reduced(19 downto 06)) +
							signed(data_in_reduced(19 downto 08)) +
							signed(data_in_reduced(19 downto 09)) +
							signed(data_in_reduced(19 downto 14)) +
							signed(data_in_reduced(19 downto 15))
						);

					when "010000" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(22 downto 03)) +
							signed(data_in_reduced(19 downto 05)) +
							signed(data_in_reduced(19 downto 09)) +
							signed(data_in_reduced(19 downto 12)) +
							signed(data_in_reduced(19 downto 15))
						);

					when "010001" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(22 downto 03)) +
							signed(data_in_reduced(19 downto 06)) +
							signed(data_in_reduced(19 downto 11)) +
							signed(data_in_reduced(19 downto 13))
						);

					when "010010" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(22 downto 03)) +
							signed(data_in_reduced(19 downto 11)) +
							signed(data_in_reduced(19 downto 12)) +
							signed(data_in_reduced(19 downto 13)) +
							signed(data_in_reduced(19 downto 15))
						);

					when "010011" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(23 downto 04)) +
							signed(data_in_reduced(19 downto 05)) +
							signed(data_in_reduced(19 downto 06)) +
							signed(data_in_reduced(19 downto 09)) +
							signed(data_in_reduced(19 downto 11)) +
							signed(data_in_reduced(19 downto 12)) +
							signed(data_in_reduced(19 downto 13))
						);

					when "010100" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(23 downto 04)) +
							signed(data_in_reduced(19 downto 05)) +
							signed(data_in_reduced(19 downto 08)) +
							signed(data_in_reduced(19 downto 09)) +
							signed(data_in_reduced(19 downto 12)) +
							signed(data_in_reduced(19 downto 13))
						);

					when "010101" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(23 downto 04)) +
							signed(data_in_reduced(19 downto 06)) +
							signed(data_in_reduced(19 downto 07)) +
							signed(data_in_reduced(19 downto 09)) +
							signed(data_in_reduced(19 downto 10)) +
							signed(data_in_reduced(19 downto 11))
						);

					when "010110" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(23 downto 04)) +
							signed(data_in_reduced(19 downto 06)) +
							signed(data_in_reduced(19 downto 10)) +
							signed(data_in_reduced(19 downto 12)) +
							signed(data_in_reduced(19 downto 13))
						);

					when "010111" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(23 downto 04)) +
							signed(data_in_reduced(19 downto 07)) +
							signed(data_in_reduced(19 downto 12)) +
							signed(data_in_reduced(19 downto 13)) +
							signed(data_in_reduced(19 downto 14)) +
							signed(data_in_reduced(19 downto 15))
						);

					when "011000" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(23 downto 04)) +
							signed(data_in_reduced(19 downto 11)) +
							signed(data_in_reduced(19 downto 14)) +
							signed(data_in_reduced(19 downto 15))
						);

					when "011001" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(24 downto 05)) +
							signed(data_in_reduced(19 downto 06)) +
							signed(data_in_reduced(19 downto 07)) +
							signed(data_in_reduced(19 downto 10)) +
							signed(data_in_reduced(19 downto 11)) +
							signed(data_in_reduced(19 downto 14))
						);

					when "011010" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(24 downto 05)) +
							signed(data_in_reduced(19 downto 06)) +
							signed(data_in_reduced(19 downto 09)) +
							signed(data_in_reduced(19 downto 10)) +
							signed(data_in_reduced(19 downto 12)) +
							signed(data_in_reduced(19 downto 14))
						);

					when "011011" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(24 downto 05)) +
							signed(data_in_reduced(19 downto 07)) +
							signed(data_in_reduced(19 downto 08)) +
							signed(data_in_reduced(19 downto 10)) +
							signed(data_in_reduced(19 downto 11)) +
							signed(data_in_reduced(19 downto 13)) +
							signed(data_in_reduced(19 downto 14)) +
							signed(data_in_reduced(19 downto 15))
						);

					when "011100" =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(24 downto 05)) +
							signed(data_in_reduced(19 downto 07)) +
							signed(data_in_reduced(19 downto 11)) +
							signed(data_in_reduced(19 downto 12))
						);

					when "011101" => --att 29db
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(24 downto 05)) +
							signed(data_in_reduced(19 downto 08)) +
							signed(data_in_reduced(19 downto 12)) +
							signed(data_in_reduced(19 downto 14))
						);

					when "011110" => -- att 30db
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(24 downto 05)) +
							signed(data_in_reduced(19 downto 12)) +
							signed(data_in_reduced(19 downto 13))
						);
						
					when "011111" => -- att 31db
					data_out_temp <= std_logic_vector
					(
						 signed(data_in_wider(25 downto 06)) +
						 signed(data_in_reduced(19 downto 07)) +
						 signed(data_in_reduced(19 downto 08)) +
						 signed(data_in_reduced(19 downto 11)) +
						 signed(data_in_reduced(19 downto 12))
					);
					
					when "100000" => -- att 32db
					data_out_temp <= std_logic_vector
					(
						 signed(data_in_wider(25 downto 06)) +
						 signed(data_in_reduced(19 downto 07)) +
						 signed(data_in_reduced(19 downto 10)) +
						 signed(data_in_reduced(19 downto 11)) +
						 signed(data_in_reduced(19 downto 13)) 
					);
					
					when "100001" => --case 33db
					data_out_temp <= std_logic_vector
					(
					   signed(data_in_wider(25 downto 06)) +		 					
					   signed(data_in_wider(19 downto 08)) +
					   signed(data_in_reduced(19 downto 09)) +
					   signed(data_in_reduced(19 downto 11)) +
					   signed(data_in_reduced(19 downto 12)) +
					   signed(data_in_reduced(19 downto 13)) 
					);

					when others =>
						data_out_temp   <= std_logic_vector
						(
							signed(data_in_wider(24 downto 05)) +
							signed(data_in_reduced(19 downto 12)) +
							signed(data_in_reduced(19 downto 13))
						);
					end case;
				end if;
			end if;
        end if;
    end process P_PWR_RDCTN;

end architecture Behavioral;