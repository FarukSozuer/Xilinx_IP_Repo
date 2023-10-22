library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TRN_CHNNL_CMBNR_v1_0_M00_AXIS is
generic
(
    -- Users to add parameters here

    -- User parameters ends
    -- Do not modify the parameters beyond this line
    C_M_AXIS_TDATA_WIDTH    : integer := 32
);
port
(
    -- Users to add ports here
    stream_data_out : in std_logic_vector(C_M_AXIS_TDATA_WIDTH - 1 downto 0);
    -- User ports ends
    -- Do not modify the ports beyond this line
    M_AXIS_ACLK     : in std_logic;
    M_AXIS_ARESETN  : in std_logic;
    M_AXIS_TVALID   : out std_logic;
    M_AXIS_TDATA    : out std_logic_vector(C_M_AXIS_TDATA_WIDTH - 1 downto 0);
    M_AXIS_TSTRB    : out std_logic_vector((C_M_AXIS_TDATA_WIDTH / 8) - 1 downto 0);
    M_AXIS_TLAST    : out std_logic;
    M_AXIS_TREADY   : in std_logic
);
end TRN_CHNNL_CMBNR_v1_0_M00_AXIS;

architecture implementation of TRN_CHNNL_CMBNR_v1_0_M00_AXIS is

begin

    PROC_STREAM_OUT: process(M_AXIS_ACLK) begin
        if rising_edge(M_AXIS_ACLK) then
            if (M_AXIS_ARESETN = '0') then
                M_AXIS_TVALID   <= '0';
                M_AXIS_TDATA    <= (others => '0');
                M_AXIS_TLAST    <= '0';
                M_AXIS_TSTRB    <= (others => '0');
            else
                if (M_AXIS_TREADY = '1') then
                    M_AXIS_TVALID   <= '1';
                    M_AXIS_TDATA    <= stream_data_out;
                    M_AXIS_TLAST    <= '0';
                    M_AXIS_TSTRB    <= (others => '1');
                else
                    M_AXIS_TVALID   <= '0';
                    M_AXIS_TDATA    <= (others => '0');
                    M_AXIS_TLAST    <= '0';
                    M_AXIS_TSTRB    <= (others => '0');
                end if;
            end if;
        end if;
    end process PROC_STREAM_OUT;

end implementation;
