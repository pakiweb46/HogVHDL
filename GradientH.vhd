----------------------------------------------------------------------------------
-- Company: 
-- Engineer: MIAN KHURAM ALI
-- 
-- Create Date:    11:57:01 10/30/2015 
-- Design Name: Gradient 
-- Module Name:    GradHori - Behavioral 
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
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity GradHori is
    generic (n : INTEGER :=8);
    port (
        DataInx1: in STD_LOGIC_VECTOR (n-1 downto 0);
        DataInx2: in STD_LOGIC_VECTOR (n-1 downto 0);
        DATAOUT: out STD_LOGIC_VECTOR (n downto 0);
        CLK : in STD_LOGIC
    );
end GradHori;
architecture RTL of GradHori is
begin
process(clk)
begin
	if rising_edge(clk) then
		DataOut<=("0" & DataInx1) - ("0" & DataInx2);
		end if;
end process;
end RTL;