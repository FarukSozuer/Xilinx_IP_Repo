library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TRN_DAC_3482_IC_INTERFACE_v1_0_S00_AXI is
generic
(
    C_S_AXI_DATA_WIDTH:integer:= 32;
    C_S_AXI_ADDR_WIDTH:integer:= 6
);
port
(
    -- Users Ports
    pat0    : out std_logic_vector(15 downto 0);
    pat1    : out std_logic_vector(15 downto 0);
    pat2    : out std_logic_vector(15 downto 0);
    pat3    : out std_logic_vector(15 downto 0);
    pat4    : out std_logic_vector(15 downto 0);
    pat5    : out std_logic_vector(15 downto 0);
    pat6    : out std_logic_vector(15 downto 0);
    pat7    : out std_logic_vector(15 downto 0);
    mode    : out std_logic_vector(1 downto 0);

    -- AXI Ports
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
end TRN_DAC_3482_IC_INTERFACE_v1_0_S00_AXI;


architecture arch_imp of TRN_DAC_3482_IC_INTERFACE_v1_0_S00_AXI is

    -- AXI4LITE signals
    signal axi_awaddr   : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    signal axi_awready  : std_logic;
    signal axi_wready   : std_logic;
    signal axi_bresp    : std_logic_vector(1 downto 0);
    signal axi_bvalid   : std_logic;
    signal axi_araddr   : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    signal axi_arready  : std_logic;
    signal axi_rdata    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal axi_rresp    : std_logic_vector(1 downto 0);
    signal axi_rvalid   : std_logic;

    constant ADDR_LSB  : integer := (C_S_AXI_DATA_WIDTH/32)+ 1;
    constant OPT_MEM_ADDR_BITS : integer := 3;

    constant C_DEF_PAT0     : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := x"00007A7A";
    constant C_DEF_PAT1     : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := x"0000B6B6";
    constant C_DEF_PAT2     : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := x"0000EAEA";
    constant C_DEF_PAT3     : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := x"00004545";
    constant C_DEF_PAT4     : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := x"00001A1A";
    constant C_DEF_PAT5     : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := x"00001616";
    constant C_DEF_PAT6     : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := x"0000AAAA";
    constant C_DEF_PAT7     : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := x"0000C6C6";
    constant C_VERSION      : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := x"00010006";

    signal reg_pat0	    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal reg_pat1	    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal reg_pat2	    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal reg_pat3	    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal reg_pat4	    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal reg_pat5	    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal reg_pat6	    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal reg_pat7	    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal reg_mode	    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal reg_vrsn     : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal slv_reg_rden	: std_logic;
    signal slv_reg_wren	: std_logic;
    signal reg_data_out	: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal byte_index	: integer;
    signal aw_en	    : std_logic;

begin
	-- I/O Connections assignments

	S_AXI_AWREADY	<= axi_awready;
	S_AXI_WREADY	<= axi_wready;
	S_AXI_BRESP	    <= axi_bresp;
	S_AXI_BVALID	<= axi_bvalid;
	S_AXI_ARREADY	<= axi_arready;
	S_AXI_RDATA	    <= axi_rdata;
	S_AXI_RRESP	    <= axi_rresp;
	S_AXI_RVALID	<= axi_rvalid;

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awready <= '0';
	      aw_en <= '1';
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and aw_en = '1') then
	           axi_awready <= '1';
	           aw_en <= '0';
	        elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then
	           aw_en <= '1';
	           axi_awready <= '0';
	      else
	        axi_awready <= '0';
	      end if;
	    end if;
	  end if;
	end process;

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_awaddr <= (others => '0');
	    else
	      if (axi_awready = '0' and S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and aw_en = '1') then
	        -- Write Address latching
	        axi_awaddr <= S_AXI_AWADDR;
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement axi_wready generation
	-- axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	-- S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	-- de-asserted when reset is low. 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_wready <= '0';
	    else
	      if (axi_wready = '0' and S_AXI_WVALID = '1' and S_AXI_AWVALID = '1' and aw_en = '1') then
	          -- slave is ready to accept write data when 
	          -- there is a valid write address and write data
	          -- on the write address and data bus. This design 
	          -- expects no outstanding transactions.           
	          axi_wready <= '1';
	      else
	        axi_wready <= '0';
	      end if;
	    end if;
	  end if;
	end process; 

	-- Implement memory mapped register select and write logic generation
	-- The write data is accepted and written to memory mapped registers when
	-- axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	-- select byte enables of slave registers while writing.
	-- These registers are cleared when reset (active low) is applied.
	-- Slave register write enable is asserted when valid address and data are available
	-- and the slave is ready to accept the write address and write data.
	slv_reg_wren <= axi_wready and S_AXI_WVALID and axi_awready and S_AXI_AWVALID ;

	process (S_AXI_ACLK)
	variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0); 
	begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      reg_pat0 <= C_DEF_PAT0;
	      reg_pat1 <= C_DEF_PAT1;
	      reg_pat2 <= C_DEF_PAT2;
	      reg_pat3 <= C_DEF_PAT3;
	      reg_pat4 <= C_DEF_PAT4;
	      reg_pat5 <= C_DEF_PAT5;
	      reg_pat6 <= C_DEF_PAT6;
	      reg_pat7 <= C_DEF_PAT7;
	      reg_mode <= (others => '0');
	      reg_vrsn <= C_VERSION;
	    else
	      loc_addr := axi_awaddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
	      if (slv_reg_wren = '1') then
	        case loc_addr is
	          when b"0000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 0
	                reg_pat0(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"0001" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 1
	                reg_pat1(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"0010" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 2
	                reg_pat2(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"0011" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 3
	                reg_pat3(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"0100" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 4
	                reg_pat4(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"0101" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 5
	                reg_pat5(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"0110" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 6
	                reg_pat6(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"0111" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 7
	                reg_pat7(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when b"1000" =>
	            for byte_index in 0 to (C_S_AXI_DATA_WIDTH/8-1) loop
	              if ( S_AXI_WSTRB(byte_index) = '1' ) then
	                -- Respective byte enables are asserted as per write strobes                   
	                -- slave registor 8
	                reg_mode(byte_index*8+7 downto byte_index*8) <= S_AXI_WDATA(byte_index*8+7 downto byte_index*8);
	              end if;
	            end loop;
	          when others =>
	            reg_pat0 <= reg_pat0;
	            reg_pat1 <= reg_pat1;
	            reg_pat2 <= reg_pat2;
	            reg_pat3 <= reg_pat3;
	            reg_pat4 <= reg_pat4;
	            reg_pat5 <= reg_pat5;
	            reg_pat6 <= reg_pat6;
	            reg_pat7 <= reg_pat7;
	            reg_mode <= reg_mode;
                reg_vrsn <= reg_vrsn;
	        end case;
	      end if;
	    end if;
	  end if;                   
	end process; 

	-- Implement write response logic generation
	-- The write response and response valid signals are asserted by the slave 
	-- when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	-- This marks the acceptance of address and indicates the status of 
	-- write transaction.

	process (S_AXI_ACLK) begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_bvalid  <= '0';
	      axi_bresp   <= "00"; --need to work more on the responses
	    else
	      if (axi_awready = '1' and S_AXI_AWVALID = '1' and axi_wready = '1' and S_AXI_WVALID = '1' and axi_bvalid = '0'  ) then
	        axi_bvalid <= '1';
	        axi_bresp  <= "00"; 
	      elsif (S_AXI_BREADY = '1' and axi_bvalid = '1') then   --check if bready is asserted while bvalid is high)
	        axi_bvalid <= '0';                                 -- (there is a possibility that bready is always asserted high)
	      end if;
	    end if;
	  end if;                   
	end process;

	process (S_AXI_ACLK) begin
	  if rising_edge(S_AXI_ACLK) then 
	    if S_AXI_ARESETN = '0' then
	      axi_arready <= '0';
	      axi_araddr  <= (others => '1');
	    else
	      if (axi_arready = '0' and S_AXI_ARVALID = '1') then
	        -- indicates that the slave has acceped the valid read address
	        axi_arready <= '1';
	        -- Read Address latching 
	        axi_araddr  <= S_AXI_ARADDR;
	      else
	        axi_arready <= '0';
	      end if;
	    end if;
	  end if;
	end process; 

	process (S_AXI_ACLK)
	begin
	  if rising_edge(S_AXI_ACLK) then
	    if S_AXI_ARESETN = '0' then
	      axi_rvalid <= '0';
	      axi_rresp  <= "00";
	    else
	      if (axi_arready = '1' and S_AXI_ARVALID = '1' and axi_rvalid = '0') then
	        -- Valid read data is available at the read data bus
	        axi_rvalid <= '1';
	        axi_rresp  <= "00"; -- 'OKAY' response
	      elsif (axi_rvalid = '1' and S_AXI_RREADY = '1') then
	        -- Read data is accepted by the master
	        axi_rvalid <= '0';
	      end if;            
	    end if;
	  end if;
	end process;

	-- Implement memory mapped register select and read logic generation
	-- Slave register read enable is asserted when valid address is available
	-- and the slave is ready to accept the read address.
	slv_reg_rden <= axi_arready and S_AXI_ARVALID and (not axi_rvalid) ;

	process (reg_pat0, reg_pat1, reg_pat2, reg_pat3, reg_pat4, reg_pat5, reg_pat6, reg_pat7, reg_mode, reg_vrsn, axi_araddr, S_AXI_ARESETN, slv_reg_rden)
	variable loc_addr :std_logic_vector(OPT_MEM_ADDR_BITS downto 0);
	begin

	    loc_addr := axi_araddr(ADDR_LSB + OPT_MEM_ADDR_BITS downto ADDR_LSB);
	    case loc_addr is
	      when b"0000" =>
	        reg_data_out <= reg_pat0;
	      when b"0001" =>
	        reg_data_out <= reg_pat1;
	      when b"0010" =>
	        reg_data_out <= reg_pat2;
	      when b"0011" =>
	        reg_data_out <= reg_pat3;
	      when b"0100" =>
	        reg_data_out <= reg_pat4;
	      when b"0101" =>
	        reg_data_out <= reg_pat5;
	      when b"0110" =>
	        reg_data_out <= reg_pat6;
	      when b"0111" =>
	        reg_data_out <= reg_pat7;
	      when b"1000" =>
	        reg_data_out <= reg_mode;
          when b"1001" =>
              reg_data_out <= reg_vrsn;
	      when others =>
	        reg_data_out  <= (others => '0');
	    end case;
	end process; 

	process( S_AXI_ACLK ) is
	begin
	  if (rising_edge (S_AXI_ACLK)) then
	    if ( S_AXI_ARESETN = '0' ) then
	      axi_rdata  <= (others => '0');
	    else
	      if (slv_reg_rden = '1') then
	          axi_rdata <= reg_data_out;     -- register read data
	      end if;   
	    end if;
	  end if;
	end process;


	-- Add user logic here
    pat0    <= reg_pat0(15 downto 0);
    pat1    <= reg_pat1(15 downto 0);
    pat2    <= reg_pat2(15 downto 0);
    pat3    <= reg_pat3(15 downto 0);
    pat4    <= reg_pat4(15 downto 0);
    pat5    <= reg_pat5(15 downto 0);
    pat6    <= reg_pat6(15 downto 0);
    pat7    <= reg_pat7(15 downto 0);
    mode    <= reg_mode(1 downto 0);
	-- User logic ends

end arch_imp;
