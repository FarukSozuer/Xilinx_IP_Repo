library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TRN_CHNNL_CMBNR_v1_0_S00_AXIS is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- AXI4Stream sink: Data Width
		C_S_AXIS_TDATA_WIDTH	: integer	:= 32
	);
	port (
		-- Users to add ports here
        stream_data_in  : out std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
		-- User ports ends
		-- Do not modify the ports beyond this line
		S_AXIS_ACLK	: in std_logic;
		S_AXIS_ARESETN	: in std_logic;
		S_AXIS_TREADY	: out std_logic;
		S_AXIS_TDATA	: in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
		S_AXIS_TSTRB	: in std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
		S_AXIS_TLAST	: in std_logic;
		S_AXIS_TVALID	: in std_logic
	);
end TRN_CHNNL_CMBNR_v1_0_S00_AXIS;

architecture arch_imp of TRN_CHNNL_CMBNR_v1_0_S00_AXIS is

begin

    PROC_STREAM_OUT: process(S_AXIS_ACLK) begin
        if rising_edge(S_AXIS_ACLK) then
            if (S_AXIS_ARESETN = '0') then
                S_AXIS_TREADY   <= '0';
                stream_data_in  <= (others => '0');
            else
                S_AXIS_TREADY   <= '1';
                if (S_AXIS_TVALID = '1') then
                    stream_data_in  <= S_AXIS_TDATA;
                else
                    stream_data_in  <= (others => '0');
                end if;
            end if;
        end if;
    end process PROC_STREAM_OUT;

end arch_imp;
