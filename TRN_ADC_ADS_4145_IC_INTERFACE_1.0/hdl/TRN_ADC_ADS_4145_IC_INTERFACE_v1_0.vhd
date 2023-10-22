library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TRN_ADC_ADS_4145_IC_INTERFACE_v1_0 is
generic
(
    C_M00_AXIS_TDATA_WIDTH	: integer	:= 32;
    C_M00_AXIS_START_COUNT	: integer	:= 32;
    C_S00_AXI_DATA_WIDTH	: integer	:= 32;
    C_S00_AXI_ADDR_WIDTH	: integer	:= 4
);
port
(
    adc_data            : in std_logic_vector(13 downto 0);

    -- Ports of Axi Master Bus Interface M00_AXIS
    m00_axis_aclk       : in std_logic;
    m00_axis_aresetn    : in std_logic;
    m00_axis_tvalid     : out std_logic;
    m00_axis_tdata      : out std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
    m00_axis_tstrb      : out std_logic_vector((C_M00_AXIS_TDATA_WIDTH/8)-1 downto 0);
    m00_axis_tlast      : out std_logic;
    m00_axis_tready     : in std_logic;

    -- Ports of Axi Slave Bus Interface S00_AXI
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
    s00_axi_rready  : in std_logic
);
end TRN_ADC_ADS_4145_IC_INTERFACE_v1_0;

architecture arch_imp of TRN_ADC_ADS_4145_IC_INTERFACE_v1_0 is

    -- component declaration
    component TRN_ADC_ADS_4145_IC_INTERFACE_v1_0_M00_AXIS is
    generic
    (
        C_M_AXIS_TDATA_WIDTH    : integer := 32
    );
    port
    (
        adc_data        : in std_logic_vector(13 downto 0);
        data_vld        : in std_logic;
        M_AXIS_ACLK     : in std_logic;
        M_AXIS_ARESETN  : in std_logic;
        M_AXIS_TVALID   : out std_logic;
        M_AXIS_TDATA    : out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
        M_AXIS_TSTRB    : out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
        M_AXIS_TLAST    : out std_logic;
        M_AXIS_TREADY   : in std_logic
    );
    end component TRN_ADC_ADS_4145_IC_INTERFACE_v1_0_M00_AXIS;
    signal in_dev_align     : std_logic_vector(13 downto 0);

    component TRN_ADC_ADS_4145_IC_INTERFACE_v1_0_S00_AXI is
    generic
    (
        C_S_AXI_DATA_WIDTH  : integer   := 32;
        C_S_AXI_ADDR_WIDTH  : integer   := 4
    );
    port
    (
        mode            : out std_logic;
        oute            : out std_logic;
        mvld            : in std_logic;
        S_AXI_ACLK      : in std_logic;
        S_AXI_ARESETN   : in std_logic;
        S_AXI_AWADDR    : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        S_AXI_AWPROT    : in std_logic_vector(2 downto 0);
        S_AXI_AWVALID   : in std_logic;
        S_AXI_AWREADY   : out std_logic;
        S_AXI_WDATA     : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_WSTRB     : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
        S_AXI_WVALID    : in std_logic;
        S_AXI_WREADY    : out std_logic;
        S_AXI_BRESP     : out std_logic_vector(1 downto 0);
        S_AXI_BVALID    : out std_logic;
        S_AXI_BREADY    : in std_logic;
        S_AXI_ARADDR    : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        S_AXI_ARPROT    : in std_logic_vector(2 downto 0);
        S_AXI_ARVALID   : in std_logic;
        S_AXI_ARREADY   : out std_logic;
        S_AXI_RDATA     : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_RRESP     : out std_logic_vector(1 downto 0);
        S_AXI_RVALID    : out std_logic;
        S_AXI_RREADY    : in std_logic
    );
    end component TRN_ADC_ADS_4145_IC_INTERFACE_v1_0_S00_AXI;
    signal cdc0_mode    : std_logic;
    signal cdc1_mode    : std_logic;
    signal cdc2_mode    : std_logic;
    signal cdc0_oute    : std_logic;
    signal cdc1_oute    : std_logic;
    signal cdc2_oute    : std_logic;
    signal cdc0_mvld    : std_logic;
    signal cdc1_mvld    : std_logic;
    signal cdc2_mvld    : std_logic;

begin

    -- Instantiation of Axi Bus Interface M00_AXIS
    TRN_ADC_ADS_4145_IC_INTERFACE_v1_0_M00_AXIS_inst : TRN_ADC_ADS_4145_IC_INTERFACE_v1_0_M00_AXIS
    generic map
    (
        C_M_AXIS_TDATA_WIDTH	=> C_M00_AXIS_TDATA_WIDTH
    )
    port map
    (
        adc_data        => in_dev_align,
        data_vld        => cdc2_oute,
        M_AXIS_ACLK     => m00_axis_aclk,
        M_AXIS_ARESETN  => m00_axis_aresetn,
        M_AXIS_TVALID   => m00_axis_tvalid,
        M_AXIS_TDATA    => m00_axis_tdata,
        M_AXIS_TSTRB    => m00_axis_tstrb,
        M_AXIS_TLAST    => m00_axis_tlast,
        M_AXIS_TREADY   => m00_axis_tready
    );

    P_ALIGN: process(m00_axis_aclk) begin
        if rising_edge(m00_axis_aclk) then
            if (m00_axis_aresetn = '0') then
                cdc1_mode       <= '0';
                cdc2_mode       <= '0';

                cdc1_oute       <= '0';
                cdc2_oute       <= '0';
                in_dev_align    <= (others => '0');
            else
                cdc1_mode       <= cdc0_mode;
                cdc2_mode       <= cdc1_mode;
                if (cdc2_mode = '1') then
                    if (in_dev_align = std_logic_vector(to_unsigned(16383, in_dev_align'length))) then
                        cdc0_mvld   <= '1'; 
                    else
                        cdc0_mvld   <= '0';
                    end if;
                else
                    if (in_dev_align = std_logic_vector(to_unsigned(0, in_dev_align'length))) then
                        cdc0_mvld   <= '1';
                    else
                        cdc0_mvld   <= '0';
                    end if;
                end if;

                cdc1_oute       <= cdc0_oute;
                cdc2_oute       <= cdc1_oute;
                in_dev_align    <= adc_data(6) & adc_data(13) & adc_data(5) & adc_data(12) & adc_data(4) & adc_data(11) & adc_data(3) & adc_data(10) & adc_data(2) & adc_data(9) & adc_data(1) & adc_data(8) & adc_data(0) & adc_data(7);
            end if;
        end if;
    end process P_ALIGN;

    -- Instantiation of Axi Bus Interface S00_AXI
    TRN_ADC_ADS_4145_IC_INTERFACE_v1_0_S00_AXI_inst : TRN_ADC_ADS_4145_IC_INTERFACE_v1_0_S00_AXI
    generic map
    (
        C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
        C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
    )
    port map
    (
        mode            => cdc0_mode,
        oute            => cdc0_oute,
        mvld            => cdc2_mvld,
        S_AXI_ACLK      => s00_axi_aclk,
        S_AXI_ARESETN   => s00_axi_aresetn,
        S_AXI_AWADDR    => s00_axi_awaddr,
        S_AXI_AWPROT    => s00_axi_awprot,
        S_AXI_AWVALID   => s00_axi_awvalid,
        S_AXI_AWREADY   => s00_axi_awready,
        S_AXI_WDATA     => s00_axi_wdata,
        S_AXI_WSTRB     => s00_axi_wstrb,
        S_AXI_WVALID    => s00_axi_wvalid,
        S_AXI_WREADY    => s00_axi_wready,
        S_AXI_BRESP     => s00_axi_bresp,
        S_AXI_BVALID    => s00_axi_bvalid,
        S_AXI_BREADY    => s00_axi_bready,
        S_AXI_ARADDR    => s00_axi_araddr,
        S_AXI_ARPROT    => s00_axi_arprot,
        S_AXI_ARVALID   => s00_axi_arvalid,
        S_AXI_ARREADY   => s00_axi_arready,
        S_AXI_RDATA     => s00_axi_rdata,
        S_AXI_RRESP     => s00_axi_rresp,
        S_AXI_RVALID    => s00_axi_rvalid,
        S_AXI_RREADY    => s00_axi_rready
    );

    P_MODE_CHANGE: process(s00_axi_aclk) begin
        if rising_edge(s00_axi_aclk) then
            if (s00_axi_aresetn = '0') then
                cdc1_mvld   <= '0';
                cdc2_mvld   <= '0';
            else
                cdc1_mvld   <= cdc0_mvld;
                cdc2_mvld   <= cdc1_mvld;
            end if;
        end if;
    end process P_MODE_CHANGE;

end arch_imp;
