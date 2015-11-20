library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sync_ram is
    
    port ( DataIn : in  STD_LOGIC_VECTOR (8 downto 0);
           we : in  STD_LOGIC;
           b_we : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           data_block:in std_logic_vector(71 downto 0);
			  Address : in  natural range 0 to 8192;
           DataOut : out  STD_LOGIC_VECTOR (8 downto 0)
			  );
end sync_ram;

architecture Behavioral of sync_ram is
 -- Build a 2-D array type for the RAM
    subtype word_t is std_logic_vector(8 downto 0);
    type memory_t is array(8192 downto 0) of word_t;
    
    -- Declare the RAM
    shared variable ram : memory_t;
begin
 -- Port A
    -- Block Write
    process(clk)
    begin
     if(rising_edge(clk)) then
      if(b_we='1') then
             ram(Address):=data_block(71 downto 63);
             ram(Address+1):=data_block(62 downto 54);
             ram(Address+2):=data_block(53 downto 45);
             ram(Address+3):=data_block(44 downto 36);
             ram(Address+4):=data_block(35 downto 27);
             ram(Address+5):=data_block(26 downto 18);
             ram(Address+6):=data_block(17 downto 9);
             ram(Address+7):=data_block(8 downto 0);
         else
         if(we = '1') then
                         ram(Address) := DataIn;
          end if;         
         end if;
           DataOut <= ram(Address);
        end if;
 end process;

end Behavioral;
