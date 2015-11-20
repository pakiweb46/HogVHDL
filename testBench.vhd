library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE STD.TEXTIO.ALL;
use ieee.numeric_std.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testBench is
end testBench;

architecture Behavioral of testBench is
component top_module
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
end component;
  component SIPO
     Port ( Sin : natural range 0 to 255;
           Pout : inout  STD_LOGIC_VECTOR (63 downto 0);
              clk: in std_logic );    
    end component;
    signal CLK        : std_logic := '0';
    signal clk_sp:std_logic :='0';
    signal grd_x1:std_logic_vector(8 downto 0) :=(others => '0');
    signal grd_x2:std_logic_vector(8 downto 0) :=(others => '0');
    signal grd_x3:std_logic_vector(8 downto 0) :=(others => '0');
    signal grd_x4:std_logic_vector(8 downto 0) :=(others => '0');
    signal grd_x5:std_logic_vector(8 downto 0) :=(others => '0');
    signal grd_x6:std_logic_vector(8 downto 0) :=(others => '0');
    signal grd_x7:std_logic_vector(8 downto 0) :=(others => '0');
   signal dataread:natural range 0 to 255;
	signal endoffile:std_logic :='0';
    signal pixels:std_logic_vector(63 downto 0) :=(others => '0');
	  constant CLK_period : time := 80 ns;
begin
top:top_module
port map
(
CLK=>CLK,
OCP_port=>pixels,
grad_x1=>grd_x1,
grad_x2=>grd_x2,
grad_x3=>grd_x3,
grad_x4=>grd_x4,
grad_x5=>grd_x5,
grad_x6=>grd_x6,
grad_x7=>grd_x7
);
sipo1:SIPO
        port map(
        clk=>clk_sp,
        Sin=>dataread,
        Pout=>pixels
        );
-- Clock process definitions
CLK_process :process
    begin
        CLK <= '0';
        wait for CLK_period;
        CLK <= '1';
        wait for CLK_period;
    end process;
	 clk_spzial:process
    begin
      clk_sp <= '0';
        wait for CLK_period/8;
      clk_sp <= '1';
        wait for CLK_period/8;
    end process;
	 read_file:process
     file   infile    : text is in "C:\Users\pakiweb\Gradient\image_1D.txt"; --/home/ali/workspace/Gradient/image_1D.txt";   --declare input file
   variable  inline    : line; --line number declaration
   variable  dataread1    : natural range 0 to 255;
begin
wait for 70ns;--wait until CLK='1' and CLK'EVENT; -- wait for one clock
for i in 1 to 8192 loop
wait until clk_sp = '1' and clk_sp'event;
if (not endfile(infile)) then   --checking the "END OF FILE" is not reached.
readline(infile, inline);       --reading a line from the file.
  --reading the data from the line and putting it in a integer type variable.
read(inline, dataread1);
dataread <=dataread1;   --put the value available in variable in a signal.
else
endoffile <='1';         --set signal to tell end of file read file is reached.
end if;
end loop;
wait;
end process read_file;
end Behavioral;
