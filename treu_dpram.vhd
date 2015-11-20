----------------------------------------------------------------------------------
-- Company:
-- Engineer:
-- 
-- Create Date:    14:21:52 11/11/2015
-- Design Name:
-- Module Name:    true_dpram - Behavioral
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
library ieee;
use ieee.std_logic_1164.all;

entity true_dpram_sclk is
    port
    (    
        data_a    : in std_logic_vector(7 downto 0);
        data_block:in std_logic_vector(63 downto 0);
        data_b    : in std_logic_vector(7 downto 0);
        addr_a    : in natural range 0 to 8192;
        addr_b    : in natural range 0 to 8192;
        bwe_a:in std_logic :='0';
        we_a    : in std_logic := '0';
        we_b    : in std_logic := '0';
        clk        : in std_logic;
        q_a        : out std_logic_vector(7 downto 0);
        q_b        : out std_logic_vector(7 downto 0)
    );
    
end true_dpram_sclk;

architecture rtl of true_dpram_sclk is
    
    -- Build a 2-D array type for the RAM
    subtype word_t is std_logic_vector(7 downto 0);
    type memory_t is array(8192 downto 0) of word_t;
    
    -- Declare the RAM
    shared variable ram : memory_t;

begin

    -- Port A
    -- Block Write
    process(clk)
    begin
     if(rising_edge(clk)) then
      if(bwe_a='1') then
             ram(addr_a):=data_block(63 downto 56);
             ram(addr_a+1):=data_block(55 downto 48);
             ram(addr_a+2):=data_block(47 downto 40);
             ram(addr_a+3):=data_block(39 downto 32);
             ram(addr_a+4):=data_block(31 downto 24);
             ram(addr_a+5):=data_block(23 downto 16);
             ram(addr_a+6):=data_block(15 downto 8);
             ram(addr_a+7):=data_block(7 downto 0);
         else
         if(we_a = '1') then
                         ram(addr_a) := data_a;
          end if;         
         end if;
           q_a <= ram(addr_a);
        end if;
 end process;
    -- Port B

    process(clk)
    begin
        if(rising_edge(clk)) then
            if(we_b = '1') then
                ram(addr_b) := data_b;
            end if;
            q_b <= ram(addr_b);
        end if;
    end process;
end rtl;

     
