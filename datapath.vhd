library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- interface
entity datapath is

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
end datapath;

architecture struct of datapath is
	component reg is
		generic( N : integer);
		port (
				CLK, rst_n : in std_logic;
				load : in std_logic;
				D : in std_logic_vector(N-1 downto 0);
				Q : out std_logic_vector(N-1 downto 0)
		);
	end component;

	component mux2input is
		generic(N : integer);
		port (
			sel : in std_logic;
			I0 : in std_logic_vector(N-1 downto 0);
			I1 : in std_logic_vector(N-1 downto 0);
			Y : out std_logic_vector(N-1 downto 0)
		);
	end component;

	component comparator is
		generic (N :integer);
		port (
			A : in std_logic_vector(N-1 downto 0);
			B : in std_logic_vector(N-1 downto 0);	
			Y : out std_logic
		);
	end component;

	component adder is
		generic ( N : integer );
		port (
			A : in std_logic_vector(N-1 downto 0);
			B : in std_logic_vector(N-1 downto 0);
			Y : out std_logic_vector(N-1 downto 0)
		);
	end component;

	signal CNT_out, DIV_out, DIV_in, CNT_in 	: std_logic_vector(N-1 downto 0);
	signal mux1out, mux2out, mux3out 			: std_logic_vector(N-1 downto 0);
	signal adderout 									: std_logic_vector(N-1 downto 0);
	
	constant one 										: std_logic_vector(N-1 downto 0) := ( 0 => '1', others => '0');

begin
	-- REGISTERS
	CNTS : reg generic map (N) port map (CLK => CLK, rst_n => rst_n, load => loadCNT, D => CNT_in, Q => CNT_out);
	DIVS : reg generic map (N) port map (CLK => CLK, rst_n => rst_n, load => loadDIV, D => DIV_in, Q => DIV_out);

	-- MUX for CNT
	MUX1: mux2input generic map (N) port map (sel => loadCNT, I0 => adderout, I1 => (others => '0'), Y => mux1out );
	-- MUX for DIV
	MUX2: mux2input generic map (N) port map (sel => loadDIV, I0 => (others => '0'), I1 => adderout, Y => mux2out );
	--MUX for adder
	MUX3: mux2input generic map (N) port map (sel => adder_sel_in, I0 => CNT_out, I1 => DIV_out, Y => mux3out );

	-- COMPARATOR for CNT
	COMP1 : comparator generic map (N) port map ( A => CNT_out, B => L_1, Y => cnt_eq_L);
	-- COMPARATOR for DIV 
	COMP2 : comparator generic map (N) port map ( A => DIV_out, B => N_2, Y => div_eq_N); 

	-- ADDER
	ADDER1 : adder generic map (N) port map ( A => one, B => mux3out, Y => adderout);
	
	--put here the connection to debug
	CNT_in <= mux1out;
	DIV_in <= mux2out;
	DATA <= CNT_out;
	
end struct;