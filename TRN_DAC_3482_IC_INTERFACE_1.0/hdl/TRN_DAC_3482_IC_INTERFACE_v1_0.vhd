library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TRN_DAC_3482_IC_INTERFACE_v1_0 is
generic
(
	C_S00_AXI_DATA_WIDTH	: integer	:= 32;
    C_S00_AXI_ADDR_WIDTH	: integer	:= 6;
    C_S00_AXIS_TDATA_WIDTH	: integer	:= 16; --16
    C_S01_AXIS_TDATA_WIDTH	: integer	:= 16  --16
);
port
(
    -- Users to add ports here
    dat_frm_dvc     : out std_logic_vector(31 downto 0);    -- Q(15 downto 0) & I(15 downto 0)
    fsync_frm_dvc   : out std_logic_vector(1 downto 0);
    -- User ports ends
    s00_axi_aclk    : in std_logic;
    s00_axi_aresetn : in std_logic;
    s00_axi_awaddr  : in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
    s00_axi_awprot  : in std_logic_vector(2 downto 0);
    s00_axi_awvalid : in std_logic;
    s00_axi_awready : out std_logic;
    s00_axi_wdata   : in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
    s00_axi_wstrb   : in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
    s00_axi_wvalid  : in std_logic;
    s00_axi_wready  : out std_logic;
    s00_axi_bresp   : out std_logic_vector(1 downto 0);
    s00_axi_bvalid  : out std_logic;
    s00_axi_bready  : in std_logic;
    s00_axi_araddr  : in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
    s00_axi_arprot  : in std_logic_vector(2 downto 0);
    s00_axi_arvalid : in std_logic;
    s00_axi_arready : out std_logic;
    s00_axi_rdata   : out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
    s00_axi_rresp   : out std_logic_vector(1 downto 0);
    s00_axi_rvalid  : out std_logic;
    s00_axi_rready  : in std_logic;

    -- Ports of Axi Slave Bus Interface S00_AXIS
    s00_axis_aclk       : in std_logic;
    s00_axis_aresetn    : in std_logic;
    s00_axis_tready     : out std_logic;
    s00_axis_tdata      : in std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0);
    s00_axis_tstrb      : in std_logic_vector((C_S00_AXIS_TDATA_WIDTH/8)-1 downto 0);
    s00_axis_tlast      : in std_logic;
    s00_axis_tvalid     : in std_logic;
    
    -- Ports of Axi Slave Bus Interface S01_AXIS
    s01_axis_aclk       : in std_logic;
    s01_axis_aresetn    : in std_logic;
    s01_axis_tready     : out std_logic;
    s01_axis_tdata      : in std_logic_vector(C_S01_AXIS_TDATA_WIDTH-1 downto 0);
    s01_axis_tstrb      : in std_logic_vector((C_S01_AXIS_TDATA_WIDTH/8)-1 downto 0);
    s01_axis_tlast      : in std_logic;
    s01_axis_tvalid     : in std_logic
);
end TRN_DAC_3482_IC_INTERFACE_v1_0;


architecture arch_imp of TRN_DAC_3482_IC_INTERFACE_v1_0 is

    component TRN_DAC_3482_IC_INTERFACE_v1_0_S00_AXI is
    generic 
    (
	    C_S_AXI_DATA_WIDTH	: integer	:= 32;
        C_S_AXI_ADDR_WIDTH	: integer	:= 6

    );
    port
    (
        pat0            : out std_logic_vector(15 downto 0);
        pat1            : out std_logic_vector(15 downto 0);
        pat2            : out std_logic_vector(15 downto 0);
        pat3            : out std_logic_vector(15 downto 0);
        pat4            : out std_logic_vector(15 downto 0);
        pat5            : out std_logic_vector(15 downto 0);
        pat6            : out std_logic_vector(15 downto 0);
        pat7            : out std_logic_vector(15 downto 0);
        mode            : out std_logic_vector(1 downto 0);
        S_AXI_ACLK      : in std_logic;
        S_AXI_ARESETN   : in std_logic;
        S_AXI_AWADDR    : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        S_AXI_AWPROT    : in std_logic_vector(2 downto 0);
        S_AXI_AWVALID   : in std_logic;
        S_AXI_AWREADY   : out std_logic;
        S_AXI_WDATA     : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_WSTRB     : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
        S_AXI_WVALID    : in std_logic;
        S_AXI_WREADY	: out std_logic;
        S_AXI_BRESP     : out std_logic_vector(1 downto 0);
        S_AXI_BVALID	: out std_logic;
        S_AXI_BREADY	: in std_logic;
        S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
        S_AXI_ARVALID   : in std_logic;
        S_AXI_ARREADY   : out std_logic;
        S_AXI_RDATA     : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_RRESP	    : out std_logic_vector(1 downto 0);
        S_AXI_RVALID	: out std_logic;
        S_AXI_RREADY	: in std_logic
    );
    end component TRN_DAC_3482_IC_INTERFACE_v1_0_S00_AXI;
    signal cdc0_pat0    : std_logic_vector(15 downto 0);
    signal cdc1_pat0    : std_logic_vector(15 downto 0);
    signal cdc2_pat0    : std_logic_vector(15 downto 0);
    signal cdc0_pat1    : std_logic_vector(15 downto 0);
    signal cdc1_pat1    : std_logic_vector(15 downto 0);
    signal cdc2_pat1    : std_logic_vector(15 downto 0);
    signal cdc0_pat2    : std_logic_vector(15 downto 0);
    signal cdc1_pat2    : std_logic_vector(15 downto 0);
    signal cdc2_pat2    : std_logic_vector(15 downto 0);
    signal cdc0_pat3    : std_logic_vector(15 downto 0);
    signal cdc1_pat3    : std_logic_vector(15 downto 0);
    signal cdc2_pat3    : std_logic_vector(15 downto 0);
    signal cdc0_pat4    : std_logic_vector(15 downto 0);
    signal cdc1_pat4    : std_logic_vector(15 downto 0);
    signal cdc2_pat4    : std_logic_vector(15 downto 0);
    signal cdc0_pat5    : std_logic_vector(15 downto 0);
    signal cdc1_pat5    : std_logic_vector(15 downto 0);
    signal cdc2_pat5    : std_logic_vector(15 downto 0);
    signal cdc0_pat6    : std_logic_vector(15 downto 0);
    signal cdc1_pat6    : std_logic_vector(15 downto 0);
    signal cdc2_pat6    : std_logic_vector(15 downto 0);
    signal cdc0_pat7    : std_logic_vector(15 downto 0);
    signal cdc1_pat7    : std_logic_vector(15 downto 0);
    signal cdc2_pat7    : std_logic_vector(15 downto 0);
    signal cdc0_mode    : std_logic_vector(1 downto 0);
    signal cdc1_mode    : std_logic_vector(1 downto 0);
    signal cdc2_mode    : std_logic_vector(1 downto 0);

    component TRN_DAC_3482_IC_INTERFACE_v1_0_S00_AXIS is
    generic
    (
        C_S_AXIS_TDATA_WIDTH	: integer	:= 32
    );
    port
    (
        data            : out std_logic_vector(C_S_AXIS_TDATA_WIDTH - 1 downto 0);
        ready           : in std_logic;
        S_AXIS_ACLK	    : in std_logic;
        S_AXIS_ARESETN	: in std_logic;
        S_AXIS_TREADY	: out std_logic;
        S_AXIS_TDATA	: in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
        S_AXIS_TSTRB	: in std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
        S_AXIS_TLAST	: in std_logic;
        S_AXIS_TVALID	: in std_logic
    );
    end component TRN_DAC_3482_IC_INTERFACE_v1_0_S00_AXIS;
    signal stream_out_s00   : std_logic_vector(C_S00_AXIS_TDATA_WIDTH - 1 downto 0);
    signal stream_out_s01   : std_logic_vector(C_S00_AXIS_TDATA_WIDTH - 1 downto 0);
    signal ready            : std_logic;

    type st_test is
    (
        PAT_01,
        PAT_23,
        PAT_45,
        PAT_67
    );
    signal test_mode_st     : st_test;
    signal test_mode_out    : std_logic_vector(31 downto 0);
    signal test_mode_fsync  : std_logic_vector(1 downto 0);

begin

    TRN_DAC_3482_IC_INTERFACE_v1_0_S00_AXI_inst : TRN_DAC_3482_IC_INTERFACE_v1_0_S00_AXI
    generic map
    (
        C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
        C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
    )
    port map
    (
        pat0            => cdc0_pat0,
        pat1            => cdc0_pat1,
        pat2            => cdc0_pat2,
        pat3            => cdc0_pat3,
        pat4            => cdc0_pat4,
        pat5            => cdc0_pat5,
        pat6            => cdc0_pat6,
        pat7            => cdc0_pat7,
        mode            => cdc0_mode,
        S_AXI_ACLK	    => s00_axi_aclk,
        S_AXI_ARESETN	=> s00_axi_aresetn,
        S_AXI_AWADDR	=> s00_axi_awaddr,
        S_AXI_AWPROT	=> s00_axi_awprot,
        S_AXI_AWVALID	=> s00_axi_awvalid,
        S_AXI_AWREADY	=> s00_axi_awready,
        S_AXI_WDATA	    => s00_axi_wdata,
        S_AXI_WSTRB	    => s00_axi_wstrb,
        S_AXI_WVALID	=> s00_axi_wvalid,
        S_AXI_WREADY	=> s00_axi_wready,
        S_AXI_BRESP	    => s00_axi_bresp,
        S_AXI_BVALID	=> s00_axi_bvalid,
        S_AXI_BREADY	=> s00_axi_bready,
        S_AXI_ARADDR	=> s00_axi_araddr,
        S_AXI_ARPROT	=> s00_axi_arprot,
        S_AXI_ARVALID	=> s00_axi_arvalid,
        S_AXI_ARREADY	=> s00_axi_arready,
        S_AXI_RDATA	    => s00_axi_rdata,
        S_AXI_RRESP	    => s00_axi_rresp,
        S_AXI_RVALID	=> s00_axi_rvalid,
        S_AXI_RREADY	=> s00_axi_rready
    );

    TRN_DAC_3482_IC_INTERFACE_v1_0_S00_AXIS_inst : TRN_DAC_3482_IC_INTERFACE_v1_0_S00_AXIS
    generic map
    (
        C_S_AXIS_TDATA_WIDTH	=> C_S00_AXIS_TDATA_WIDTH
    )
    port map
    (
        data            => stream_out_s00,
        ready           => ready,
        S_AXIS_ACLK	    => s00_axis_aclk,
        S_AXIS_ARESETN	=> s00_axis_aresetn,
        S_AXIS_TREADY	=> s00_axis_tready,
        S_AXIS_TDATA	=> s00_axis_tdata,
        S_AXIS_TSTRB	=> s00_axis_tstrb,
        S_AXIS_TLAST	=> s00_axis_tlast,
        S_AXIS_TVALID	=> s00_axis_tvalid
    );
    
    TRN_DAC_3482_IC_INTERFACE_v1_0_S01_AXIS_inst : TRN_DAC_3482_IC_INTERFACE_v1_0_S00_AXIS
    generic map
    (
        C_S_AXIS_TDATA_WIDTH	=> C_S01_AXIS_TDATA_WIDTH
    )
    port map
    (
        data            => stream_out_s01,
        ready           => ready,
        S_AXIS_ACLK	    => s01_axis_aclk,
        S_AXIS_ARESETN	=> s01_axis_aresetn,
        S_AXIS_TREADY	=> s01_axis_tready,
        S_AXIS_TDATA	=> s01_axis_tdata,
        S_AXIS_TSTRB	=> s01_axis_tstrb,
        S_AXIS_TLAST	=> s01_axis_tlast,
        S_AXIS_TVALID	=> s01_axis_tvalid
    );
    ready   <= '1' when (cdc2_mode = "10") else '0';

    -- Add user logic here
    P_DRIVE: process(s00_axis_aclk) begin
        if rising_edge(s00_axis_aclk) then
            if (s00_axis_aresetn = '0') then
                dat_frm_dvc     <= (others => '0');
                fsync_frm_dvc   <= (others => '0');
                cdc1_mode       <= (others => '0');
                cdc2_mode       <= (others => '0');
                cdc1_pat0       <= (others => '0');
                cdc2_pat0       <= (others => '0');
                cdc1_pat1       <= (others => '0');
                cdc2_pat1       <= (others => '0');
                cdc1_pat2       <= (others => '0');
                cdc2_pat2       <= (others => '0');
                cdc1_pat3       <= (others => '0');
                cdc2_pat3       <= (others => '0');
                cdc1_pat4       <= (others => '0');
                cdc2_pat4       <= (others => '0');
                cdc1_pat5       <= (others => '0');
                cdc2_pat5       <= (others => '0');
                cdc1_pat6       <= (others => '0');
                cdc2_pat6       <= (others => '0');
                cdc1_pat7       <= (others => '0');
                cdc2_pat7       <= (others => '0');
            else
                cdc1_mode   <= cdc0_mode;
                cdc2_mode   <= cdc1_mode;
                cdc1_pat0   <= cdc0_pat0;
                cdc2_pat0   <= cdc1_pat0;
                cdc1_pat1   <= cdc0_pat1;
                cdc2_pat1   <= cdc1_pat1;
                cdc1_pat2   <= cdc0_pat2;
                cdc2_pat2   <= cdc1_pat2;
                cdc1_pat3   <= cdc0_pat3;
                cdc2_pat3   <= cdc1_pat3;
                cdc1_pat4   <= cdc0_pat4;
                cdc2_pat4   <= cdc1_pat4;
                cdc1_pat5   <= cdc0_pat5;
                cdc2_pat5   <= cdc1_pat5;
                cdc1_pat6   <= cdc0_pat6;
                cdc2_pat6   <= cdc1_pat6;
                cdc1_pat7   <= cdc0_pat7;
                cdc2_pat7   <= cdc1_pat7;

                case (cdc2_mode) is
                    when "00" =>
                        dat_frm_dvc     <= (others => '0');
                        fsync_frm_dvc   <= (others => '0');
                    when "01" =>
                        dat_frm_dvc     <= test_mode_out;
                        fsync_frm_dvc   <= test_mode_fsync;
                    when "10" =>
                        dat_frm_dvc     <= stream_out_s01 & stream_out_s00;
                        fsync_frm_dvc   <= "01";
                    when "11" =>
                        dat_frm_dvc     <= (others => '0');
                        fsync_frm_dvc   <= "00";
                    when others =>
                        dat_frm_dvc     <= (others => '0');
                        fsync_frm_dvc   <= (others => '0');
                end case;
            end if;
        end if;
    end process P_DRIVE;

    P_TEST_MODE: process(s00_axis_aclk) begin
        if rising_edge(s00_axis_aclk) then
            if (s00_axis_aresetn = '0') then
                test_mode_out   <= (others => '0');
                test_mode_fsync <= (others => '0');
                test_mode_st    <= PAT_01;
            else
                case (test_mode_st) is
                    when PAT_01 =>
                        test_mode_out   <= cdc2_pat1 & cdc2_pat0;
                        test_mode_fsync <= "11";
                        test_mode_st    <= PAT_23;
                    when PAT_23 =>
                        test_mode_out   <= cdc2_pat3 & cdc2_pat2;
                        test_mode_fsync <= "11";
                        test_mode_st    <= PAT_45;
                    when PAT_45 =>
                        test_mode_out   <= cdc2_pat5 & cdc2_pat4;
                        test_mode_fsync <= "00";
                        test_mode_st    <= PAT_67;
                    when PAT_67 =>
                        test_mode_out   <= cdc2_pat7 & cdc2_pat6;
                        test_mode_fsync <= "00";
                        test_mode_st    <= PAT_01;
                    when others =>
                        test_mode_out   <= (others => '0');
                        test_mode_fsync <= (others => '0');
                        test_mode_st    <= PAT_01;
                end case;
            end if;
        end if;
    end process P_TEST_MODE;
    -- User logic ends

end arch_imp;
