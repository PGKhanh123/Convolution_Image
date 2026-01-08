library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity up_counter is
    port (
        clk, rst  : in  std_logic;
        inc       : in  std_logic;
        stop      : in  unsigned(7 downto 0);
        z         : out std_logic;
        count     : out unsigned(7 downto 0)
    );
end up_counter;

architecture rtl of up_counter is
    signal cnt : unsigned(7 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cnt <= (others => '0');
            elsif inc = '1' then
                cnt <= cnt + 1;
            end if;
        end if;
    end process;

    z <= '1' when cnt = stop else '0';
    count <= cnt;
end rtl;

