library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TRN_DAC_3482_IC_INTERFACE_v1_0_S00_AXIS is
	generic (
		C_S_AXIS_TDATA_WIDTH	: integer	:= 16 --16
	);
	port (
        -- Users to add ports here
        data        : out std_logic_vector(C_S_AXIS_TDATA_WIDTH - 1 downto 0);
        ready       : in std_logic;
        -- User ports ends
		-- AXI4Stream sink: Clock
		S_AXIS_ACLK	: in std_logic;
		-- AXI4Stream sink: Reset
		S_AXIS_ARESETN	: in std_logic;
		-- Ready to accept data in
		S_AXIS_TREADY	: out std_logic;
		-- Data in
		S_AXIS_TDATA	: in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
		-- Byte qualifier
		S_AXIS_TSTRB	: in std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
		-- Indicates boundary of last packet
		S_AXIS_TLAST	: in std_logic;
		-- Data is in valid
		S_AXIS_TVALID	: in std_logic
	);
end TRN_DAC_3482_IC_INTERFACE_v1_0_S00_AXIS;


architecture arch_imp of TRN_DAC_3482_IC_INTERFACE_v1_0_S00_AXIS is

    signal axis_tready	: std_logic;
    signal trans_occur  : std_logic;

begin
    -- I/O Connections assignments
    S_AXIS_TREADY	<= axis_tready;

    axis_tready     <= ready;
    trans_occur     <= S_AXIS_TVALID and axis_tready;

    P_DATA_OUT: process(S_AXIS_ACLK) begin
        if rising_edge(S_AXIS_ACLK) then
            if (S_AXIS_ARESETN = '0') then
                data        <= (others => '0');
            else
                if (trans_occur = '1') then
                    data <=  S_AXIS_TDATA;
                else
                    data        <= (others => '0');
                end if;
            end if;
        end if;
    end process P_DATA_OUT;

end arch_imp;
