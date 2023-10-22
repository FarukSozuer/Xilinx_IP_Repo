library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity TRN_TDM_1X2_OUT is
  generic 
  (
    DATA_WIDTH : integer := 32
  );
  Port ( 
    aclk           : in std_logic;
    aresetn       : in std_logic;
    s_axis_tdata        : in std_logic_vector(DATA_WIDTH-1 downto 0); 
    m_axis0_tdata      : out std_logic_vector(DATA_WIDTH-1 downto 0); 
    m_axis0_tvalid      : out std_logic; 
    m_axis1_tvalid      : out std_logic; 
    m_axis1_tdata      : out std_logic_vector(DATA_WIDTH-1 downto 0);
    
    s_axis_tvalid  : in std_logic;
    s_axis_tuser   : in std_logic
  );
end TRN_TDM_1X2_OUT;

architecture Behavioral of TRN_TDM_1X2_OUT is
 
begin

  TDM_SWITCH: process(aclk)
  begin
    if rising_edge(aclk) then
      if (s_axis_tvalid = '1') then
        if (s_axis_tuser = '0') then
          m_axis0_tdata <= s_axis_tdata;
          m_axis0_tvalid <= '1';
        elsif (s_axis_tuser = '1') then
          m_axis1_tdata <= s_axis_tdata;
          m_axis1_tvalid <= '1';
        end if;
      end if;
    end if;
  end process TDM_SWITCH;

end Behavioral;
