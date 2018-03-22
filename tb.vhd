library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;

-- interface
entity TB is
end TB;

architecture behav of TB is

	--CONSTANTS
	constant CLK_SEMIPERIOD0	: time := 25 ns;
	constant CLK_SEMIPERIOD1	: time := 15 ns;
	constant CLK_PERIOD 			: time := CLK_SEMIPERIOD0+CLK_SEMIPERIOD1;
	constant RESET_TIME 			: time := 3*CLK_PERIOD + 9 ns;
	constant N_bit 				: integer := 8;

	--SINGALS

	signal CLK, rst_n 			: std_logic;
	signal DATA 					: std_logic_vector(N_bit-1 downto 0);
	signal GO 						: std_logic;
	signal done						: std_logic := '0';
	signal count					: std_logic_vector( 15 downto 0);
	signal int_count 				: integer := 0;

	component buttonpresscounter is
		generic (N_bit_out : integer);
		port (
			CLK, rst_n 		: in std_logic;
			GO 				: in std_logic;
			DATA 				: out std_logic_vector (N_bit_out-1 downto 0)
		);
	end component;

begin
	DUT : buttonpresscounter generic map(N_bit) 
									 port map (	
											CLK => CLK, 
											rst_n => rst_n,
											GO => GO,
											DATA => DATA );
	start_process: process
	begin
		GO <= '0';
		rst_n <= '1';
		wait for 1 ns;
		rst_n <= '0';
		wait for RESET_TIME;
		rst_n <= '1';
		GO <= '1';
		wait for 1500 ns;
		GO <= '0';
		wait for 400 ns;
		GO <= '1';
		--done <= '1';
	wait;
	end process start_process;

	clk_process: process
	begin
		if CLK = '0' then
			CLK <= '1';
			wait for CLK_SEMIPERIOD1;
		else
			CLK <= '0';
			wait for CLK_SEMIPERIOD0;
			count <= std_logic_vector(unsigned(count) + 1);
			int_count <= int_count + 1;
		end if;
	end process clk_process;



	done_process: process(done)
		variable outputline : LINE;
		begin
			if (done = '1') then
				write(outputline, string'("End simulation - "));
				write(outputline, string'("cycle counter is "));
				write(outputline, int_count);
				writeline(output, outputline);
				assert false report "NONE. End of simulation." severity failure;
			end if;
		end process done_process;

end behav;
