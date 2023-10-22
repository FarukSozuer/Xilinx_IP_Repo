library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TRN_AXI_DATA_SHARE_v1_0 is
	generic (
		-- Users to add parameters here
        G_FFT_SIZE              : integer := 4096;
		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 4
	);
	port (
        rstp_fft        : in std_logic;
        clk_fft         : in std_logic;
        fft_tlast       : in std_logic;
        fft_sum         : in std_logic_vector(31 downto 0);
        fft_index       : in std_logic_vector(15 downto 0);
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
	);
end TRN_AXI_DATA_SHARE_v1_0;

architecture arch_imp of TRN_AXI_DATA_SHARE_v1_0 is

	-- component declaration
	component TRN_AXI_DATA_SHARE_v1_0_S00_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 4
		);
		port (
        fft_sum_rec     : in std_logic_vector(31 downto 0);
        fft_index_rec   : in std_logic_vector(15 downto 0);
        fft_vld         : in std_logic;
		S_AXI_ACLK	    : in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	    : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	    : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	    : out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	    : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	    : out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component TRN_AXI_DATA_SHARE_v1_0_S00_AXI;

    signal fft_sum_r        : std_logic_vector(31 downto 0);
    signal fft_index_r      : std_logic_vector(15 downto 0);
    signal fft_index_d0     : std_logic_vector(15 downto 0);
    signal fft_index_d1     : std_logic_vector(15 downto 0);
	
    signal cdc0_fft_sum_rec     : std_logic_vector(31 downto 0);
    signal cdc1_fft_sum_rec     : std_logic_vector(31 downto 0);
    signal cdc2_fft_sum_rec     : std_logic_vector(31 downto 0);
    signal cdc0_fft_index_rec   : std_logic_vector(15 downto 0);
    signal cdc1_fft_index_rec   : std_logic_vector(15 downto 0);
    signal cdc2_fft_index_rec   : std_logic_vector(15 downto 0);

    signal cdc0_fft_vld         : std_logic;
    signal cdc1_fft_vld         : std_logic;
    signal cdc2_fft_vld         : std_logic;

begin

-- Instantiation of Axi Bus Interface S00_AXI
TRN_AXI_DATA_SHARE_v1_0_S00_AXI_inst : TRN_AXI_DATA_SHARE_v1_0_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
        fft_sum_rec     => cdc2_fft_sum_rec,
        fft_index_rec   => cdc2_fft_index_rec,
        fft_vld         => cdc2_fft_vld,
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

    P_CDC_REG: process(s00_axi_aclk) begin
        if rising_edge(s00_axi_aclk) then
            if (s00_axi_aresetn = '0') then
                cdc1_fft_sum_rec     <= (others => '0');
                cdc2_fft_sum_rec     <= (others => '0');
                cdc1_fft_index_rec   <= (others => '0');
                cdc2_fft_index_rec   <= (others => '0');
                cdc1_fft_vld         <= '0';
                cdc2_fft_vld         <= '0';
            else
                cdc1_fft_sum_rec     <= cdc0_fft_sum_rec;
                cdc2_fft_sum_rec     <= cdc1_fft_sum_rec;
                cdc1_fft_index_rec   <= cdc0_fft_index_rec;
                cdc2_fft_index_rec   <= cdc1_fft_index_rec;
                cdc1_fft_vld         <= cdc0_fft_vld;
                cdc2_fft_vld         <= cdc1_fft_vld;
            end if;
        end if;
    end process P_CDC_REG;
--
    P_FETCH: process(clk_fft) begin
        if rising_edge(clk_fft) then
            fft_sum_r       <= fft_sum;
            fft_index_r     <= fft_index;
            --fft_index_d0    <= fft_index;
            --fft_index_d1    <= fft_index_d0;
        end if;
    end process P_FETCH;

    P_GET_VAL: process(clk_fft) begin
        if rising_edge(clk_fft) then
            if (rstp_fft = '1') then
                cdc0_fft_sum_rec    <= (others => '0');
                cdc0_fft_index_rec  <= (others => '0');
                cdc0_fft_vld        <= '0';
            else
                if (fft_tlast = '1') then
				
                    cdc0_fft_sum_rec    <= (others => '0');
                    cdc0_fft_index_rec  <= (others => '0');
					elsif (fft_index_r < std_logic_vector(to_unsigned(G_FFT_SIZE / 2, fft_index_r'length))) then
					   if (cdc0_fft_sum_rec < fft_sum_r) then
					       cdc0_fft_sum_rec    <= fft_sum_r;
					       cdc0_fft_index_rec  <= fft_index_r;
							 cdc0_fft_vld    <= '1';					
                    end if;                 
					elsif (fft_index_r = std_logic_vector(to_unsigned(G_FFT_SIZE / 2 + 1, fft_index_r'length))) then
					    cdc0_fft_vld    <= '1';
					else
					     cdc0_fft_vld    <= '0';
                end if;
            end if;
        end if;
    end process P_GET_VAL;

end arch_imp;
