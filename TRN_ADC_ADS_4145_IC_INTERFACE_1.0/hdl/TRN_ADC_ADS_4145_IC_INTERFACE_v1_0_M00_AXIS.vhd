library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TRN_ADC_ADS_4145_IC_INTERFACE_v1_0_M00_AXIS is
    generic
    (
        C_M_AXIS_TDATA_WIDTH	: integer	:= 32
    );
    port
    (
        adc_data        : in std_logic_vector(13 downto 0);
        data_vld        : in std_logic;
        M_AXIS_ACLK	    : in std_logic;
        M_AXIS_ARESETN  : in std_logic;
        M_AXIS_TVALID   : out std_logic;
        M_AXIS_TDATA    : out std_logic_vector(C_M_AXIS_TDATA_WIDTH - 1 downto 0);
        M_AXIS_TSTRB    : out std_logic_vector((C_M_AXIS_TDATA_WIDTH / 8) - 1 downto 0);
        M_AXIS_TLAST    : out std_logic;
        M_AXIS_TREADY   : in std_logic
    );
end TRN_ADC_ADS_4145_IC_INTERFACE_v1_0_M00_AXIS;

architecture implementation of TRN_ADC_ADS_4145_IC_INTERFACE_v1_0_M00_AXIS is

    signal stream_data_out      : std_logic_vector(C_M_AXIS_TDATA_WIDTH - 1 downto 0);
	signal adc_data_signed 		: signed(13 downto 0);
    signal axis_tvalid          : std_logic;

begin

    M_AXIS_TVALID   <= axis_tvalid;
    M_AXIS_TDATA    <= stream_data_out;
    M_AXIS_TLAST    <= '0';
    M_AXIS_TSTRB    <= (others => '1');
	adc_data_signed	<= signed(adc_data);

    P_STREAM_OUT: process(M_AXIS_ACLK) begin
        if rising_edge(M_AXIS_ACLK) then
            if (M_AXIS_ARESETN = '0') then
                axis_tvalid         <= '0';
                stream_data_out     <= (others => '0');
            else
                axis_tvalid         <= data_vld;
				stream_data_out 	<= std_logic_vector(resize(adc_data_signed, stream_data_out'length));
            end if;
        end if;
    end process P_STREAM_OUT;

end implementation;



