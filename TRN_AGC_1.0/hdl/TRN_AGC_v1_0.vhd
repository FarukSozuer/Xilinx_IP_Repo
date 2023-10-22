library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TRN_AGC_v1_0 is
	generic
    (
		-- Users to add parameters here
        G_DATA_WIDTH    : integer := 16;                                    -- Input Data Width
        G_WINDOW_WIDTH  : integer := 512;                                   -- Auto Gain Window Width
		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 4
	);
	port (
        -- Users to add ports here
        rstn            : in std_logic;                                     -- Synchronous Active High Reset
        clk             : in std_logic;                                     -- Clock
    
        data_in         : in std_logic_vector(G_DATA_WIDTH - 1 downto 0);   -- Input Data
        data_invld      : out std_logic;
        data_out        : out std_logic_vector(G_DATA_WIDTH - 1 downto 0);  -- Output Data
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
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
end TRN_AGC_v1_0;

architecture arch_imp of TRN_AGC_v1_0 is

	-- component declaration
	component TRN_AGC_v1_0_S00_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 4
		);
		port (
        cdc0_th_o   : out std_logic_vector(15 downto 0);
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component TRN_AGC_v1_0_S00_AXI;
	signal cdc0_th          : std_logic_vector(15 downto 0);
	signal cdc1_th          : std_logic_vector(15 downto 0);
	signal cdc2_th          : std_logic_vector(15 downto 0);

    signal data_in_twos     : std_logic_vector(G_DATA_WIDTH - 1 downto 0);
    signal data_in_abs      : std_logic_vector(G_DATA_WIDTH - 1 downto 0);
    signal input_cntr       : std_logic_vector(9 downto 0);
    signal abv_trsh_cnt     : std_logic_vector(9 downto 0);
    signal is_interference  : std_logic;

begin

-- Instantiation of Axi Bus Interface S00_AXI
TRN_AGC_v1_0_S00_AXI_inst : TRN_AGC_v1_0_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
	    cdc0_th_o      => cdc0_th,
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

	-- Add user logic here


    ---------------------------------------------------------------------------------------
    -- Calculate absolute value combinational way (Timing may problem (%10 probability))
    ---------------------------------------------------------------------------------------
    data_in_twos    <= std_logic_vector(unsigned(not data_in) + 1);
    data_in_abs     <= ('0' & data_in_twos(G_DATA_WIDTH - 2 downto 0)) when (data_in(G_DATA_WIDTH - 1) = '1') else data_in;
    ---------------------------------------------------------------------------------------

    P_CNT_WNDW: process(clk) begin
        if rising_edge(clk) then
            if (rstn = '0') then
                cdc1_th         <= (others => '0');
                cdc2_th         <= (others => '0');

                data_invld      <= '0';
                data_out        <= (others => '0');

                input_cntr      <= (others => '0');
                abv_trsh_cnt    <= (others => '0');
                is_interference <= '0';
            else
                cdc1_th         <= cdc0_th;
                cdc2_th         <= cdc1_th;
                ----------------------------------------------------------
                -- Calculate if data is below treshold for given window
                ----------------------------------------------------------
                if (input_cntr = std_logic_vector(to_unsigned(G_WINDOW_WIDTH - 1, input_cntr'length))) then
                    input_cntr      <= (others => '0');

                    -- After end of each window, reset treshold counter to detect interference in next windows
                    abv_trsh_cnt    <= (others => '0');

                    ------------------------------------------------------------------------------
                    -- After each window, make deicision about input data is interference or not
                    -- This will affect next window for output delay
                    ------------------------------------------------------------------------------
                    if (abv_trsh_cnt > std_logic_vector(to_unsigned(G_WINDOW_WIDTH - 200, abv_trsh_cnt'length))) then
                        is_interference <= '0';
                    else
                        is_interference <= '1';
                    end if;
                    ------------------------------------------------------------------------------
                else
                    input_cntr  <= std_logic_vector(unsigned(input_cntr) + 1);

                    ---------------------------------------------
                    -- How much sample is above treshold or not
                    ---------------------------------------------
                    if (unsigned(cdc2_th) > unsigned(data_in_abs)) then
                        abv_trsh_cnt    <= abv_trsh_cnt;
                    else
                        abv_trsh_cnt    <= std_logic_vector(unsigned(abv_trsh_cnt) + 1);
                    end if;
                    ---------------------------------------------

                    -- Do not touch is_interference in window trehsold calculation
                    is_interference <= is_interference;
                end if;
                ----------------------------------------------------------

                ------------------------------------------------
                -- If data is below treshold, pass data as zero
                ------------------------------------------------
                if (is_interference = '1') then
                    data_out        <= (others => '0');
                else
                    data_out        <= data_in;
                end if;
                data_invld  <= is_interference;
                ------------------------------------------------
            end if;
        end if;
    end process P_CNT_WNDW;
	-- User logic ends

end arch_imp;
