library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg is
GENERIC( DATA_WIDTH : Integer := 8);
    port ( 
        clk, rst : in  std_logic;
        en       : in  std_logic;
        d        : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        q        : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end reg;

architecture rtl of reg is
    signal q_reg : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
begin
    process(clk, rst)
    begin
        if rst = '1' then
            q_reg <= (others => '0');
        elsif rising_edge(clk) then
            if en = '1' then
                q_reg <= d;
            end if;
        end if;
    end process;

    q <= q_reg;
end rtl;
