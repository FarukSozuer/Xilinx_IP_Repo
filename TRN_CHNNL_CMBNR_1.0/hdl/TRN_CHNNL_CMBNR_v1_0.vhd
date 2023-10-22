library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TRN_CHNNL_CMBNR_v1_0 is
generic
(
    C_S00_AXI_DATA_WIDTH	: integer	:= 32;
    C_S00_AXI_ADDR_WIDTH	: integer	:= 4;
    C_M00_AXIS_TDATA_WIDTH	: integer	:= 16
);
port
(
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
    s00_axi_rready	: in std_logic;

    chn_0           : in std_logic_vector(15 downto 0);
    chn_1           : in std_logic_vector(15 downto 0);
    chn_2           : in std_logic_vector(15 downto 0);
    chn_3           : in std_logic_vector(15 downto 0);
    chn_4           : in std_logic_vector(15 downto 0);
    chn_5           : in std_logic_vector(15 downto 0);
    chn_6           : in std_logic_vector(15 downto 0);
    chn_7           : in std_logic_vector(15 downto 0);
	chn_noise       : in std_logic_vector(15 downto 0); -- fs added 15.02.2023

    chn_0_invld     : in std_logic;
    chn_1_invld     : in std_logic;
    chn_2_invld     : in std_logic;
    chn_3_invld     : in std_logic;
    chn_4_invld     : in std_logic;
    chn_5_invld     : in std_logic;
    chn_6_invld     : in std_logic;
    chn_7_invld     : in std_logic;

    -- Ports of Axi Master Bus Interface M00_AXIS
    m00_axis_aclk	: in std_logic;
    m00_axis_aresetn	: in std_logic;
    m00_axis_tvalid	: out std_logic;
    m00_axis_tdata	: out std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
    m00_axis_tstrb	: out std_logic_vector((C_M00_AXIS_TDATA_WIDTH/8)-1 downto 0);
    m00_axis_tlast	: out std_logic;
    m00_axis_tready	: in std_logic
);
end TRN_CHNNL_CMBNR_v1_0;

architecture arch_imp of TRN_CHNNL_CMBNR_v1_0 is

    component TRN_CHNNL_CMBNR_v1_0_S00_AXI is
    generic
    (
        C_S_AXI_DATA_WIDTH  : integer   := 32;
        C_S_AXI_ADDR_WIDTH  : integer   := 4
    );
    port
    (
        cdc0_chnl_op_o  : out std_logic_vector(8 downto 0);
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
    end component TRN_CHNNL_CMBNR_v1_0_S00_AXI;
    signal cdc0_chnl_op : std_logic_vector(8 downto 0);
    signal cdc1_chnl_op : std_logic_vector(8 downto 0);
    signal cdc2_chnl_op : std_logic_vector(8 downto 0);

    component TRN_CHNNL_CMBNR_v1_0_M00_AXIS is
    generic
    (
        C_M_AXIS_TDATA_WIDTH    : integer	:= 32
    );
    port
    (
        stream_data_out : in std_logic_vector(C_M_AXIS_TDATA_WIDTH - 1 downto 0);
        M_AXIS_ACLK     : in std_logic;
        M_AXIS_ARESETN  : in std_logic;
        M_AXIS_TVALID   : out std_logic;
        M_AXIS_TDATA    : out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
        M_AXIS_TSTRB    : out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
        M_AXIS_TLAST    : out std_logic;
        M_AXIS_TREADY   : in std_logic
    );
    end component TRN_CHNNL_CMBNR_v1_0_M00_AXIS;
    signal stream_data_out          : std_logic_vector(C_M00_AXIS_TDATA_WIDTH - 1 downto 0);
    signal stream_data_out_temp     : std_logic_vector(C_M00_AXIS_TDATA_WIDTH - 1 downto 0);

    signal chnl_add     : std_logic_vector(3 downto 0);
    --signal chnl_sub     : std_logic_vector(3 downto 0);
    --signal chnl_tot     : std_logic_vector(3 downto 0);

    signal chn_0_sel    : std_logic_vector(15 downto 0);
    signal chn_1_sel    : std_logic_vector(15 downto 0);
    signal chn_2_sel    : std_logic_vector(15 downto 0);
    signal chn_3_sel    : std_logic_vector(15 downto 0);
    signal chn_4_sel    : std_logic_vector(15 downto 0);
    signal chn_5_sel    : std_logic_vector(15 downto 0);
    signal chn_6_sel    : std_logic_vector(15 downto 0);
    signal chn_7_sel    : std_logic_vector(15 downto 0);
	signal chn_noise_sel    : std_logic_vector(15 downto 0);
	
    signal chn_cumulative   : std_logic_vector(18 downto 0);

begin

-- Instantiation of Axi Bus Interface S00_AXI
TRN_CHNNL_CMBNR_v1_0_S00_AXI_inst : TRN_CHNNL_CMBNR_v1_0_S00_AXI
    generic map (
        C_S_AXI_DATA_WIDTH  => C_S00_AXI_DATA_WIDTH,
        C_S_AXI_ADDR_WIDTH  => C_S00_AXI_ADDR_WIDTH
    )
    port map
    (
        cdc0_chnl_op_o  => cdc0_chnl_op,
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

-- Instantiation of Axi Bus Interface M00_AXIS
TRN_CHNNL_CMBNR_v1_0_M00_AXIS_inst : TRN_CHNNL_CMBNR_v1_0_M00_AXIS
    generic map (
        C_M_AXIS_TDATA_WIDTH	=> C_M00_AXIS_TDATA_WIDTH
    )
    port map (
        stream_data_out => stream_data_out,
        M_AXIS_ACLK	    => m00_axis_aclk,
        M_AXIS_ARESETN  => m00_axis_aresetn,
        M_AXIS_TVALID   => m00_axis_tvalid,
        M_AXIS_TDATA    => m00_axis_tdata,
        M_AXIS_TSTRB    => m00_axis_tstrb,
        M_AXIS_TLAST    => m00_axis_tlast,
        M_AXIS_TREADY   => m00_axis_tready
    );

    P_CALC_OUT: process(m00_axis_aclk) begin
        if rising_edge(m00_axis_aclk) then
            if (m00_axis_aresetn = '0') then
                cdc1_chnl_op    <= (others => '0');
                cdc2_chnl_op    <= (others => '0');

                chnl_add    <= (others => '0');
                --chnl_sub    <= (others => '0');
                --chnl_tot    <= (others => '0');

                chn_0_sel       <= (others => '0');
                chn_1_sel       <= (others => '0');
                chn_2_sel       <= (others => '0');
                chn_3_sel       <= (others => '0');
                chn_4_sel       <= (others => '0');
                chn_5_sel       <= (others => '0');
                chn_6_sel       <= (others => '0');
                chn_7_sel       <= (others => '0');
				chn_noise_sel       <= (others => '0');

                chn_cumulative  <= (others => '0');

                stream_data_out         <= (others => '0');
                stream_data_out_temp    <= (others => '0');
            else
                ----------------------------------------------------------------------
                -- Total Active Channel Count Calculation for proper division operation
                ----------------------------------------------------------------------
                -- Channel Register Clock Domain Crossing
                cdc1_chnl_op    <= cdc0_chnl_op;
                cdc2_chnl_op    <= cdc1_chnl_op;

                -- Total Active channel count
                chnl_add        <= std_logic_vector(unsigned'("000" & cdc2_chnl_op(7)) + unsigned'('0' & cdc2_chnl_op(6)) + unsigned'('0' & cdc2_chnl_op(5)) + unsigned'('0' & cdc2_chnl_op(4))
                + unsigned'('0' & cdc2_chnl_op(3))  + unsigned'('0' & cdc2_chnl_op(2))  + unsigned'('0' & cdc2_chnl_op(1)) + unsigned'('0' & cdc2_chnl_op(0)));

                -- Total invalid channel from AGC+
                --chnl_sub        <= std_logic_vector(unsigned'("000" & chn_0_invld) + unsigned'('0' & chn_1_invld) + unsigned'('0' & chn_2_invld) + unsigned'('0' & chn_3_invld)
                --+ unsigned'('0' & chn_4_invld)  + unsigned'('0' & chn_5_invld)  + unsigned'('0' & chn_6_invld) + unsigned'('0' & chn_7_invld));

                -- Final decision to division (No channel will be off if invalid because AGCs have already made related channels' output zero)
                --chnl_tot        <= std_logic_vector(unsigned(chnl_add) - unsigned(chnl_sub));
                ----------------------------------------------------------------------

                ----------------------------------------------------------------------
                -- If related channel number is open, pass it; if not pass zero value
                ----------------------------------------------------------------------
                if ( (cdc2_chnl_op(0) = '1') and (chn_0_invld = '0') ) then
                    chn_0_sel       <= chn_0;
                else
                    chn_0_sel       <= (others => '0');
                end if;

                if ( (cdc2_chnl_op(1) = '1') and (chn_1_invld = '0') ) then
                    chn_1_sel       <= chn_1;
                else
                    chn_1_sel       <= (others => '0');
                end if;

                if ( (cdc2_chnl_op(2) = '1') and (chn_2_invld = '0') ) then
                    chn_2_sel       <= chn_2;
                else
                    chn_2_sel       <= (others => '0');
                end if;

                if ( (cdc2_chnl_op(3) = '1') and (chn_3_invld = '0') ) then
                    chn_3_sel       <= chn_3;
                else
                    chn_3_sel       <= (others => '0');
                end if;

                if ( (cdc2_chnl_op(4) = '1') and (chn_4_invld = '0') ) then
                    chn_4_sel       <= chn_4;
                else
                    chn_4_sel       <= (others => '0');
                end if;

                if ( (cdc2_chnl_op(5) = '1') and (chn_5_invld = '0') ) then
                    chn_5_sel       <= chn_5;
                else
                    chn_5_sel       <= (others => '0');
                end if;

                if ( (cdc2_chnl_op(6) = '1') and (chn_6_invld = '0')) then
                    chn_6_sel       <= chn_6;
                else
                    chn_6_sel       <= (others => '0');
                end if;

                if ( (cdc2_chnl_op(7) = '1') and (chn_7_invld = '0')) then
                    chn_7_sel       <= chn_7;
                else
                    chn_7_sel       <= (others => '0');
                end if;
				
				if (cdc2_chnl_op(8) = '1') then
					chn_noise_sel <= chn_noise;
				else
					chn_noise_sel <= (others => '0');
				end if;
				

                -- Add all filtered channels
                chn_cumulative  <= std_logic_vector(resize(signed(chn_0_sel), chn_cumulative'length) + signed(chn_1_sel) + signed(chn_2_sel) + signed(chn_3_sel)
                + signed(chn_4_sel) + signed(chn_5_sel) + signed(chn_6_sel) + signed(chn_7_sel) + signed(chn_noise_sel));
                ----------------------------------------------------------------------

                ----------------------------------------------------------------------
                -- Divide Operation, according to channel count
                ----------------------------------------------------------------------
                case (chnl_add) is
                    when "0000" =>
                        stream_data_out_temp <= (others => '0');

                    when "0001" =>  -- Result is meaningful in 15 downto 0. (Divide to 1)
                        stream_data_out_temp <= chn_cumulative(15 downto 0);

                    when "0010" =>  -- Result is meaningful in 16 downto 0. (Divide to sqrt(2))
                        stream_data_out_temp <= std_logic_vector
                        (
                            signed(chn_cumulative(16 downto 01)) +
                            signed(chn_cumulative(16 downto 03)) +
                            signed(chn_cumulative(16 downto 04)) +
                            signed(chn_cumulative(16 downto 06)) +
                            signed(chn_cumulative(16 downto 08)) +
                            signed(chn_cumulative(16 downto 14))
                        );

                    when "0011" =>  -- Result is meaningful in 17 downto 0. (Divide to 1,7310022503029253938030119439155)
                        stream_data_out_temp <= std_logic_vector
                        (
                            signed(chn_cumulative(16 downto 1)) +   -- Neden 17 değilde 16?? Çünkü ben sayıyı 16 bit yapmak için 17 downto 2 yazmam lazım ama sayıyı 4 e bölmüş olurum.
                            -- O zaman 16 downto 1 yazarsam sayıyı 2 ye böler MSb attığım yerde genelde 0 çıkacağını varsayarım sayısal olarak. (Overflow oluyor mu kontrol et)
                            signed(chn_cumulative(17 downto 04)) +
                            signed(chn_cumulative(17 downto 07)) +
                            signed(chn_cumulative(17 downto 08)) +
                            signed(chn_cumulative(17 downto 09)) +
                            signed(chn_cumulative(17 downto 11)) +
                            signed(chn_cumulative(17 downto 12)) +
                            signed(chn_cumulative(17 downto 14))
                        );

                    when "0100" =>  -- Result is meaningful in 17 downto 0. (Divide to 2)
                        stream_data_out_temp <= chn_cumulative(16 downto 1);

                    when "0101" =>  -- Result is meaningful in 18 downto 0. (Divide to 2,2371364653243847874720357941834)
                        stream_data_out_temp <= std_logic_vector
                        (
                            signed(chn_cumulative(17 downto 02)) +
                            signed(chn_cumulative(18 downto 03)) +
                            signed(chn_cumulative(18 downto 04)) +
                            signed(chn_cumulative(18 downto 07)) +
                            signed(chn_cumulative(18 downto 10)) +
                            signed(chn_cumulative(18 downto 11)) +
                            signed(chn_cumulative(18 downto 13)) +
                            signed(chn_cumulative(18 downto 14)) +
                            signed(chn_cumulative(18 downto 15)) +
                            signed(chn_cumulative(18 downto 17))
                        );

                    when "0110" =>  -- Result is meaningful in 18 downto 0. (Divide to 2,4509803921568627450980392156863)
                        stream_data_out_temp <= std_logic_vector
                        (
                            signed(chn_cumulative(17 downto 02)) +
                            signed(chn_cumulative(18 downto 03)) +
                            signed(chn_cumulative(18 downto 05)) +
                            signed(chn_cumulative(18 downto 10)) +
                            signed(chn_cumulative(18 downto 11)) +
                            signed(chn_cumulative(18 downto 12)) +
                            signed(chn_cumulative(18 downto 15)) +
                            signed(chn_cumulative(18 downto 17))
                        );

                    when "0111" =>  -- Result is meaningful in 18 downto 0. (Divide to 2,6525198938992042440318302387268)
                        stream_data_out_temp <= std_logic_vector
                        (
                            signed(chn_cumulative(17 downto 02)) +
                            signed(chn_cumulative(18 downto 03)) +
                            signed(chn_cumulative(18 downto 09)) +
                            signed(chn_cumulative(18 downto 15)) +
                            signed(chn_cumulative(18 downto 16))
                        );

                    when "1000" =>  -- Result is meaningful in 18 downto 0. (Divide to 2,83286118980169971671388101983)
                        stream_data_out_temp <= std_logic_vector
                        (
                            signed(chn_cumulative(17 downto 02)) +
                            signed(chn_cumulative(18 downto 04)) +
                            signed(chn_cumulative(18 downto 05)) +
                            signed(chn_cumulative(18 downto 07)) +
                            signed(chn_cumulative(18 downto 10)) +
                            signed(chn_cumulative(18 downto 12)) +
                            signed(chn_cumulative(18 downto 13)) +
                            signed(chn_cumulative(18 downto 14)) +
                            signed(chn_cumulative(18 downto 15))
                        );

                    when others =>
                        stream_data_out_temp  <= (others => '0');
                end case;
                ----------------------------------------------------------------------
                -- Result is static multiply value. (Multiply 1.5)
                stream_data_out <= std_logic_vector
                (
                    signed(stream_data_out_temp)
                    --signed(stream_data_out_temp) +
                    --signed(stream_data_out_temp(15 downto 1))
                );
            end if;
        end if;
    end process P_CALC_OUT;
    -- User logic ends

end arch_imp;
