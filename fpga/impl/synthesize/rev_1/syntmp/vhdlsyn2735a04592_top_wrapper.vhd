--
-- Synopsys
-- Vhdl wrapper for top level design, written on Wed Jun 10 14:57:05 2020
--
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.genpackage.all;

entity wrapper_for_top is
   port (
      EQ : out std_logic;
      A : in std_logic_vector(9 downto 0);
      B : in std_logic_vector(9 downto 0)
   );
end wrapper_for_top;

architecture gen of wrapper_for_top is

component top
 port (
   EQ : out std_logic;
   A : in std_logic_vector (9 downto 0);
   B : in std_logic_vector (9 downto 0)
 );
end component;

signal tmp_EQ : std_logic;
signal tmp_A : std_logic_vector (9 downto 0);
signal tmp_B : std_logic_vector (9 downto 0);

begin

EQ <= tmp_EQ;

tmp_A <= A;

tmp_B <= B;



u1:   top port map (
		EQ => tmp_EQ,
		A => tmp_A,
		B => tmp_B
       );
end gen;