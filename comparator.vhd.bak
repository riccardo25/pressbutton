library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is
generic (N :integer);
port (
	A : in std_logic_vector(N-1 downto 0);
	B : in std_logic_vector(N-1 downto 0);	
	Y : out std_logic
);
end comparator;

architecture s of comparator is
begin
	Y <= '1' when A = B else '0';
end s;