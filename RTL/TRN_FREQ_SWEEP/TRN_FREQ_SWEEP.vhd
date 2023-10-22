library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Örnek bir entity tanımı
entity TRN_FREQ_SWEEP is
    Port ( 
		   clk : in  std_logic;               -- Giriş clock sinyali
		   data_valid : in std_logic;
           output_array : out std_logic_vector(39 downto 0) -- 40-bitlik çıkış portu
         );
end TRN_FREQ_SWEEP;

-- Örnek bir architecture tanımı
architecture Behavioral of TRN_FREQ_SWEEP is
    type array_type is array (0 to 4) of std_logic_vector(39 downto 0); -- 5 elemanlı, her elemanı 40-bitlik bir array tanımı
    signal my_array : array_type := (x"0063BD81A9", x"006511F407", x"0066666666",x"0067BAD8C4",x"00686511F4"); -- Örnek bir array ataması
    signal counter : integer range 0 to 4 := 0; -- Başlangıc index degeri
    
begin

	output_array <= my_array(counter); -- Array'in indexlerini çıkışa vermek için index değişkeni kullanılır.

    process(clk)
    begin
        if (rising_edge(clk)) then  -- Clock yükselen kenarını kontrol eder
				
			if data_valid = '1' then			
				counter <= counter + 1; -- Index değişkeni, her clock sinyalinde bir artırılır.
				if (counter = 4) then  -- Index değeri, array uzunluğunu aştığında sıfırlanır.
					counter <= 0;
				end if;
			end if;
        end if;
    end process;

end Behavioral;