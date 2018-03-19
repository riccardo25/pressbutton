library ieee;
use ieee.std_logic_1164.all;

-- interface
entity buttonpresscounter is
	generic (N_bit_out : integer);
	port (
		CLK, rst_n 		: in std_logic;

		-- data inputs

		GO 				: in std_logic;

		-- data outputs

		DATA 				: out std_logic_vector (N_bit_out-1 downto 0)

		-- control inputs

		-- control outputs

	);
end buttonpresscounter;

architecture struct of buttonpresscounter is
	component ctrlunit is
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
		end component;

	component datapath is
		generic( N : integer);
		port (

				CLK, rst_n 		: in std_logic;
				-- data inputs
				-- data outputs
				DATA 				: out std_logic_vector(N-1 downto 0);
				-- control signals
				selCNT			: in std_logic;
				selDIV 			: in std_logic;
				loadCNT 			: in std_logic;
				loadDIV 			: in std_logic;
				adder_sel_in	: in std_logic;
				L_1				: in std_logic_vector (N-1 downto 0);
				N_2				: in std_logic_vector (N-1 downto 0);
				cnt_eq_L			: out std_logic;
				div_eq_N			: out std_logic;
				-- status signals
				CNT 				: out std_logic_vector (N-1 downto 0);
				DIV 				: out std_logic_vector (N-1 downto 0)
			);
	end component;


	signal selCNT			: std_logic;
	signal selDIV 			: std_logic;
	signal loadCNT 		: std_logic;
	signal loadDIV 		: std_logic;
	signal adder_sel_in	: std_logic;
	signal cnt_eq_L		: std_logic;
	signal div_eq_N		: std_logic;
	
	signal CNT 				: std_logic_vector (N_bit_out-1 downto 0);
	signal DIV 				: std_logic_vector (N_bit_out-1 downto 0);

	constant L_1			: std_logic_vector (N_bit_out-1 downto 0) := ( 2 => '1',1 => '1' , others => '0'); -- L-1 = 6 : 00000110
	constant N_2			: std_logic_vector (N_bit_out-1 downto 0) := ( 0 => '1',1 => '1' , others => '0'); -- N-2 = 3 : 00000011


begin
	CTRL : ctrlunit 	generic map ( N_bit_out ) 
							port map ( 	CLK 			=> CLK, 
											rst_n 		=> rst_n,
											CNT 			=> CNT,
											GO 			=> GO,
											DIV 			=> DIV,
											cnt_eq_L		=> cnt_eq_L,
											div_eq_N		=> div_eq_N,
											selCNT		=> selCNT,
											selDIV 		=> selDIV,
											loadCNT 		=> loadCNT,
											loadDIV 		=> loadDIV,
											adder_sel_in=> adder_sel_in);

	DP : datapath 		generic map ( N_bit_out )
							port map ( 	CLK 			=> CLK, 
											rst_n 		=> rst_n,
											DATA			=> DATA,
											CNT 			=> CNT,
											DIV 			=> DIV,
											cnt_eq_L		=> cnt_eq_L,
											div_eq_N		=> div_eq_N,
											selCNT		=> selCNT,
											selDIV 		=> selDIV,
											loadCNT 		=> loadCNT,
											loadDIV 		=> loadDIV,
											adder_sel_in=> adder_sel_in,
											N_2 			=> N_2,
											L_1 			=> L_1);
end struct;
