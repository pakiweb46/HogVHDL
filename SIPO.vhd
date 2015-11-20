----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:40:50 11/12/2015 
-- Design Name: 
-- Module Name:    SIPO - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SIPO is
    Port ( Sin : natural range 0 to 255;
           Pout : inout  STD_LOGIC_VECTOR (63 downto 0):=(others=>'0');
			  clk: in std_logic			  );
end SIPO;

architecture RTL of SIPO is

begin
process(clk)
begin
    for i in 1 to 8 loop
    if (clk='1' and clk'event)then
         Pout(63 downto 8)  <= Pout(55 downto 0);
        Pout(7 downto 0) <= std_logic_vector(to_unsigned(Sin,8));
    end if;
	 end loop;
end process;
end RTL;

