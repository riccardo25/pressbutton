library ieee;
use ieee.std_logic_1164.all;


entity syncronizer is
port (
	CLK, rst_n 	: in std_logic;
	sync 			: in std_logic;
	Q 				: out std_logic
);
end syncronizer;

architecture s of syncronizer is
signal connector : std_logic;
begin

	connector <= '0' when rst_n='0' else sync when rising_edge(CLK);
	Q <= '0' when rst_n='0' else connector when rising_edge(CLK);
end s;