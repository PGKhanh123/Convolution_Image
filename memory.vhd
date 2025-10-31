library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memory is
    port(
        clk   : in std_logic;
        mem_w_en    : in std_logic;
        mem_r_en    : in std_logic;
        mem_addr  : in unsigned(17 downto 0);         
        d_in  : in std_logic_vector(31 downto 0);
        d_out : out std_logic_vector(31 downto 0)
    );
end entity;

architecture behavior of memory is 
    type ram_type is array(0 to 262143) of std_logic_vector(31 downto 0);
    signal ram : ram_type := (
        -- Vùng base_in : matrix in 5*5
        0  => std_logic_vector(to_unsigned(17, 32)),
        1  => std_logic_vector(to_unsigned(24, 32)),
        2  => std_logic_vector(to_unsigned(1, 32)),
        3  => std_logic_vector(to_unsigned(8, 32)),
        4  => std_logic_vector(to_unsigned(15, 32)),
        5  => std_logic_vector(to_unsigned(23, 32)),
        6  => std_logic_vector(to_unsigned(5, 32)),
        7  => std_logic_vector(to_unsigned(7, 32)),
        8  => std_logic_vector(to_unsigned(14, 32)),
        9  => std_logic_vector(to_unsigned(16, 32)),
        10 => std_logic_vector(to_unsigned(4, 32)),
        11 => std_logic_vector(to_unsigned(6, 32)),
        12 => std_logic_vector(to_unsigned(13, 32)),
        13 => std_logic_vector(to_unsigned(20, 32)),
        14 => std_logic_vector(to_unsigned(22, 32)),
        15 => std_logic_vector(to_unsigned(10, 32)),
        16 => std_logic_vector(to_unsigned(12, 32)),
        17 => std_logic_vector(to_unsigned(19, 32)),
        18 => std_logic_vector(to_unsigned(21, 32)),
        19 => std_logic_vector(to_unsigned(3, 32)),
        20 => std_logic_vector(to_unsigned(11, 32)),
        21 => std_logic_vector(to_unsigned(18, 32)),
        22 => std_logic_vector(to_unsigned(25, 32)),
        23 => std_logic_vector(to_unsigned(2, 32)),
        24 => std_logic_vector(to_unsigned(9, 32)),

        -- kernel 3*3
        25 => std_logic_vector(to_unsigned(1, 32)),
        26 => std_logic_vector(to_unsigned(0, 32)),
        27 => std_logic_vector(to_unsigned(1, 32)),
        28 => std_logic_vector(to_unsigned(0, 32)),
        29 => std_logic_vector(to_unsigned(1, 32)),
        30 => std_logic_vector(to_unsigned(0, 32)),
        31 => std_logic_vector(to_unsigned(1, 32)),
        32 => std_logic_vector(to_unsigned(0, 32)),
        33 => std_logic_vector(to_unsigned(1, 32)),

        others => (others => '0')
    );
begin
    process(clk)
    begin 
        if rising_edge(clk) then
            if mem_w_en = '1' then 
                ram(to_integer(mem_addr)) <= d_in;  
            elsif mem_r_en = '1' then 
                d_out <= ram(to_integer(mem_addr)); 
            else 
                d_out <= (others => '0');
            end if;
        end if;
    end process;
end behavior;
