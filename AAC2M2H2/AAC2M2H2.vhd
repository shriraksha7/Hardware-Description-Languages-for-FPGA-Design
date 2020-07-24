library ieee;

use ieee.std_logic_1164.all;

use ieee.numeric_std.all;

USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FIFO8x9 is

port(

clk, rst: in std_logic;

RdPtrClr, WrPtrClr: in std_logic;

RdInc, WrInc: in std_logic;

DataIn: in std_logic_vector(8 downto 0);

DataOut: out std_logic_vector(8 downto 0);

rden, wren: in std_logic

);

end entity FIFO8x9;

architecture RTL of FIFO8x9 is

--signal declarations

type fifo_array is array(7 downto 0) of std_logic_vector(8 downto 0); -- makes use of VHDL?s enumerated type

signal fifo: fifo_array;

signal wrptr, rdptr: unsigned(2 downto 0);

signal en: std_logic_vector(7 downto 0);

signal dmuxout: std_logic_vector(8 downto 0);

begin

wrptr<="000";

rdptr<="000";

DS: process(CLK,RST,RdInc,WrInc,rden,wren,DataIn,RdptrClr,WrPtrClr)

begin

if(rst='1') then

dmuxout<="000000000";

end if;

if (wren='1') then

fifo(to_integer(wrptr))<=DataIn;

wrptr<=wrptr+WrInc;

end if;

if(rden='1')then

dmuxout<=fifo(to_integer(rdptr));

rdptr <= rdptr+RdInc;

elsif(rden='0') then

dmuxout<="ZZZZZZZZZ";

end if;

if(RdPtrClr='1')then

rdptr<="000";

end if;

if(WrPtrClr='1')then

wrptr<="000";

end if;

DataOut <= dmuxout;

end process DS;

end architecture RTL;