library ieee;
use ieee.std_logic_1164.all;

entity ctrlunit is
generic(	N 	: integer);

port (
	CLK, rst_n 		: in std_logic;
	
	-- control inputs
	CNT 				: in std_logic_vector (N-1 downto 0);
	GO 				: in std_logic;
	DIV 				: in std_logic_vector (N-1 downto 0);
	cnt_eq_L			: in std_logic;
	div_eq_N			: in std_logic;

	-- control outputs
	selCNT			: out std_logic;
	selDIV 			: out std_logic;
	loadCNT 			: out std_logic;
	loadDIV 			: out std_logic;
	adder_sel_in	: out std_logic
	
);
end ctrlunit;


architecture behav of ctrlunit is

	type statetype is (INIT, START, COUNTWAIT, COUNT, STALLED);
	signal state, nextstate : statetype;
	
begin
	-- FSM
	state <= 	INIT 	when rst_n = '0' else nextstate when rising_edge(CLK);

	process (state, CNT, DIV, GO, cnt_eq_L, div_eq_N)
	begin
		case state is

			when INIT =>
				nextstate <= START;

			when START =>
				if GO = '1' then
					nextstate <= COUNTWAIT;
				else
					nextstate <= START;
				end if;

			when COUNTWAIT =>
				
				if GO = '0' and div_eq_N = '0'  then 		-- 00
					nextstate <= START;
				elsif GO = '0' and div_eq_N = '1'  then 	-- 01
					nextstate <= COUNT;
				elsif GO = '1' and div_eq_N = '1'  then 	-- 11
					nextstate <= COUNT;
				else  												-- 10
					nextstate <= COUNTWAIT;
				end if;

			when COUNT =>
				
				if GO = '0' and cnt_eq_L = '0'  then 		-- 00
					nextstate <= START;
				elsif GO = '0' and cnt_eq_L = '1'  then 	-- 01
					nextstate <= INIT;
				elsif GO = '1' and cnt_eq_L = '1'  then 	-- 11
					nextstate <= STALLED;
				else  												-- 10
					nextstate <= COUNTWAIT;
				end if;

			when STALLED =>

				if GO = '1' then
					nextstate <= STALLED;
				else
					nextstate <= INIT;
				end if;

			when others =>

				nextstate <= INIT;

		end case;
	end process;

	-- OUTPUTS
	selCNT 			<= '1'	when 	state=INIT 
									else 	'0';

	selDIV 			<= '0' 	when 	state=INIT or
											state=COUNT 
									else 	'1';

	loadCNT 			<= '1' 	when 	state=INIT or
											state=COUNT 
									else '0';

	loadDIV 			<= '1' 	when 	state = INIT or
											state = COUNTWAIT or
											state = COUNT
									else '0';

	adder_sel_in	<= '1' 	when 	state=COUNTWAIT
									else '0';

end behav;
