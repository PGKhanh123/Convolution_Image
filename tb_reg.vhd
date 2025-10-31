
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.lib_package.all;
entity tb_reg is
end tb_reg;

architecture tb of tb_reg is
component  reg 
GENERIC( DATA_WIDTH : Integer := 8);
    port ( 
        clk, rst : in  std_logic;
        en       : in  std_logic;
        d        : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        q        : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end component;
    -- Parameters
    constant DATA_WIDTH : integer := 8;
    constant CLK_PERIOD : time := 10 ns;

    -- Test signals
    signal clk   : std_logic := '0';
    signal rst   : std_logic := '0';
    signal en    : std_logic := '0';
    signal d     : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal q     : std_logic_vector(DATA_WIDTH-1 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: reg
        generic map(DATA_WIDTH => DATA_WIDTH)
        port map(
            clk => clk,
            rst => rst,
            en  => en,
            d   => d,
            q   => q
        );

    -- Clock generation process
    clk_process : process
    begin
        while True loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Apply reset
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 10 ns;

        -- Enable register and apply input data
        en <= '1';
        d <= "00001111";
        wait for CLK_PERIOD;

        d <= "10101010";
        wait for CLK_PERIOD;

        d <= "11110000";
        wait for CLK_PERIOD;

        -- Disable enable signal, output should hold its value
        en <= '0';
        d <= "00000100";
        wait for CLK_PERIOD * 2;

        -- Apply reset again to clear output
        rst <= '1';
        wait for CLK_PERIOD;
        rst <= '0';
        wait for CLK_PERIOD;

        -- End simulation
        wait;
    end process;

end tb;
