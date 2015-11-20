library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_module is
port(
CLK :in std_logic;
OCP_port :in std_logic_vector(63 downto 0);
grad_x1:out std_logic_vector(8 downto 0);
grad_x2:out std_logic_vector(8 downto 0);
grad_x3:out std_logic_vector(8 downto 0);
grad_x4:out std_logic_vector(8 downto 0);
grad_x5:out std_logic_vector(8 downto 0);
grad_x6:out std_logic_vector(8 downto 0);
grad_x7:out std_logic_vector(8 downto 0)
);
end top_module;
architecture Behavioral of top_module is
component GradHori
   generic (n : INTEGER :=8);
    port (
        DataInx1: in STD_LOGIC_VECTOR (n-1 downto 0);
        DataInx2: in STD_LOGIC_VECTOR (n-1 downto 0);
        DATAOUT: out STD_LOGIC_VECTOR (n downto 0);
        CLK : in STD_LOGIC
    );
end component;
component SIPO
  Port ( 
  Sin : natural range 0 to 255;
  Pout : inout  STD_LOGIC_VECTOR (63 downto 0);
  CLK: in std_logic );    
end component;
 component true_dpram_sclk
   Port
     (    
    data_a    : in std_logic_vector(7 downto 0);
    data_block:in std_logic_vector(63 downto 0);
    data_b    : in std_logic_vector(7 downto 0);
    addr_a    : in natural range 0 to 63;
    addr_b    : in natural range 0 to 63;
    bwe_a:in std_logic :='0';
    we_a    : in std_logic := '1';
    we_b    : in std_logic := '1';
    CLK        : in std_logic;
    q_a        : out std_logic_vector(7 downto 0);
    q_b        : out std_logic_vector(7 downto 0) );
end component;	
component sync_ram
 port ( 
   DataIn : in  STD_LOGIC_VECTOR (8 downto 0);
   we : in  STD_LOGIC;
   b_we : in  STD_LOGIC;
   clk : in  STD_LOGIC;
   data_block:in std_logic_vector(71 downto 0);
   Address : in  natural range 0 to 8192;
   DataOut : out  STD_LOGIC_VECTOR (8 downto 0)
);
end component;
    --Inputs
    

    signal clk_sp:std_logic :='0';
    signal DataIN1:std_logic_vector (7 downto 0);
    signal DataIN2:std_logic_vector (7 downto 0);
    signal DataOut1:std_logic_vector (7 downto 0);
    signal DataOut2:std_logic_vector (7 downto 0);
    signal Address1: natural range 0 to 8192 :=0;
    signal Address2: natural range 0 to 8192;
    signal we_a:std_logic :='0';
    signal we_b:std_logic := '0';
    ---other signals
    signal q_a:std_logic_vector(7 downto 0):=(others => '0');
    signal q_b:std_logic_vector(7 downto 0):=(others => '0');
    signal x0:std_logic_vector(7 downto 0):=(others => '0');
    signal x1:std_logic_vector(7 downto 0):=(others => '0');
    signal x2:std_logic_vector(7 downto 0):=(others => '0');
    signal x3:std_logic_vector(7 downto 0):=(others => '0');
    signal x4:std_logic_vector(7 downto 0):=(others => '0');
    signal x5:std_logic_vector(7 downto 0):=(others => '0');
    signal x6:std_logic_vector(7 downto 0):=(others => '0');
    signal x7:std_logic_vector(7 downto 0):=(others => '0');
    signal x8:std_logic_vector(7 downto 0):=(others => '0');
    signal grd_x1:std_logic_vector(8 downto 0) :=(others => '0');
    signal grd_x2:std_logic_vector(8 downto 0) :=(others => '0');
    signal grd_x3:std_logic_vector(8 downto 0) :=(others => '0');
    signal grd_x4:std_logic_vector(8 downto 0) :=(others => '0');
    signal grd_x5:std_logic_vector(8 downto 0) :=(others => '0');
    signal grd_x6:std_logic_vector(8 downto 0) :=(others => '0');
    signal grd_x7:std_logic_vector(8 downto 0) :=(others => '0');
    signal dataread:natural range 0 to 255;
    signal bwe_a:std_logic :='0';
    signal endoffile:std_logic :='0';
    signal pixels:std_logic_vector(63 downto 0) :=(others => '0');
	signal gradientx_pixels:std_logic_vector(71 downto 0):=(others=> '0');
    signal pixel_block_count:natural range 0 to 1024 :=0;
    signal pixelcount:natural range 0 to 8192 :=0;
    signal grad_Address:natural range 0 to 8192 :=0;
	signal Gradientx:std_logic_vector(8 downto 0) :=(others=> '0');
	signal gradx_DataIn:std_logic_vector(8 downto 0) :=(others=> '0');
	signal we:std_logic :='0';
	signal b_we:std_logic:= '0';
    -- Clock period definitions
    constant CLK_period : time := 80 ns;
begin
pixels<=OCP_port;
sync:true_dpram_sclk
  port map (
       data_a => DataIN1,
        data_b    => DataIN2,
        addr_a    => Address1,
        addr_b    => Address2,
        data_block => pixels,
        we_a    => we_a,
        we_b    => we_b,
        bwe_a   => bwe_a,
        clk        => CLK,
        q_a        => q_a ,
        q_b        => q_b);
gradx_ram:sync_ram
port map(
DataIn => gradx_DataIn,
we=> we,
b_we => b_we,
clk =>clk,
 data_block=>gradientx_pixels,
Address => grad_Address,
DataOut =>Gradientx );
			  
gradx1:GradHori
  port map (
    CLK   => CLK,
    DataInx1 => x1,
    DataInx2 => x2,
    DataOut  => grd_x1
  );
gradx2:GradHori
  port map(
    CLK   => CLK,
    DataInx1 => x1,
    DataInx2 => x3,
    DataOut  => grd_x2
  );
gradx3:GradHori
  port map(
        CLK   => CLK,
        DataInx1 => x2,
        DataInx2 => x4,
        DataOut  => grd_x3
        );
gradx4:GradHori
   port map(
    CLK   => CLK,
    DataInx1 => x3,
    DataInx2 => x5,
    DataOut  => grd_x4
    );
              
gradx5:GradHori
 port map(
   CLK   => CLK,
   DataInx1 => x4,
   DataInx2 => x6,
   DataOut  => grd_x5
        );
gradx6:GradHori
 port map(
    CLK   => CLK,
    DataInx1 => x5,
    DataInx2 => x7,
    DataOut  => grd_x6
            );
gradx7:GradHori
port map(
  CLK   => CLK,
  DataInx1 => x6,
  DataInx2 => x8,
  DataOut  => grd_x7
);
sync_fifout:process
begin
wait until CLK='1' and CLK'EVENT;
    x1<=pixels(63 downto 56);
    x2<=pixels(55 downto 48);
    x3<=pixels(47 downto 40);
    x4<=pixels(39 downto 32);
    x5<=pixels(31 downto 24);
    x6<=pixels(23 downto 16);
    x7<=pixels(15 downto 8);
    x8<=pixels(7 downto 0);
     pixelcount<=pixelcount+8;    
     pixel_block_count<=pixel_block_count+1;
     if(pixel_block_count>1024) then
     bwe_a<='0';
     b_we<='0';
     we_a<='1';
     else
     bwe_a<='1';
     b_we<='1';
     we_a<='0';
     end if;
    end process sync_fifout;
block_write:process
begin
wait until CLK='1' and CLK'EVENT;
if(bwe_a='1') then
Address1<=pixelcount;
grad_Address<=pixelcount-8;
end if;
end process block_write;
gradient_out:process
begin
wait until CLK='1' and CLK'EVENT;
grad_x1<=grd_x1;
grad_x2<=grd_x2;
grad_x3<=grd_x3;
grad_x4<=grd_x4;
grad_x5<=grd_x5;
grad_x6<=grd_x6;
grad_x7<=grd_x7;
end process gradient_out;
gradient_pixel:process
begin
wait until CLK='1' and CLK'EVENT;
gradientx_pixels<=grd_x1&grd_x2&grd_x3&grd_x4&grd_x5&grd_x6&grd_x7&"000000000";
end process;
end Behavioral;
