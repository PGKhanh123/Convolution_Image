library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_up_counter is
end tb_up_counter;

architecture behavior of tb_up_counter is
    -- Component declaration
    component up_counter
        port (
            clk   : in  std_logic;
            rst   : in  std_logic;
            inc   : in  std_logic;
            stop  : in  unsigned(7 downto 0);
            z     : out std_logic;
            count : out unsigned(7 downto 0)
        );
    end component;

    -- Signals for simulation
    signal tb_clk   : std_logic := '0';
    signal tb_rst   : std_logic := '0';
    signal tb_inc   : std_logic := '0';
    signal tb_stop  : unsigned(7 downto 0) := (others => '0');
    signal tb_z     : std_logic;
    signal tb_count : unsigned(7 downto 0);

    constant CLK_PERIOD : time := 10 ns;
begin
    -- Instantiate the Unit Under Test (UUT)
    uut: up_counter
        port map (
            clk   => tb_clk,
            rst   => tb_rst,
            inc   => tb_inc,
            stop  => tb_stop,
            z     => tb_z,
            count => tb_count
        );

    -- Clock generation
    clk_process : process
    begin
        tb_clk <= '0';
        wait for CLK_PERIOD / 2;
        tb_clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Reset the counter
        tb_rst <= '1';
        tb_inc <= '0';
        tb_stop <= to_unsigned(5, 8);  -- Stop when count = 5
        wait for 20 ns;

        tb_rst <= '0';
        wait for 10 ns;

        -- Start counting
        tb_inc <= '1';
        wait for 100 ns;

        -- Stop incrementing
        tb_inc <= '0';
        wait for 20 ns;

        -- Reset again
        tb_rst <= '1';
        wait for 20 ns;
        tb_rst <= '0';

        -- Run again with a different stop value
        tb_stop <= to_unsigned(10, 8);
        tb_inc <= '1';
        wait for 120 ns;

        tb_inc <= '0';
        wait;

    end process;

end behavior;

