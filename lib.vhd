library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package lib_package is

    --up counter
    component up_counter
        
        port (
            clk, rst : in  std_logic;
            inc      : in  std_logic;
            z        : out std_logic;
            count    : out unsigned(7 downto 0);
            stop     : in  unsigned(7 downto 0)
        );
    end component;

    -- Thanh ghi n bit
    component reg
        GENERIC( DATA_WIDTH : Integer := 8);
        port (
            clk, rst : in  std_logic;
            en       : in  std_logic;
            d        : in  std_logic_vector(DATA_WIDTH-1 downto 0);
            q        : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;

-- datapath
component datapath 
    port(
        rst, clk : in std_logic;
        K, N     : in unsigned(7 downto 0);

        -- counter control signals
        rst_i, inc_i : in std_logic;
        rst_j, inc_j : in std_logic;
        rst_m, inc_m : in std_logic;
        rst_n, inc_n : in std_logic;
        z_i, z_j, z_m, z_n : out std_logic;

        -- register controls
        rst_in, val_in_ld : in std_logic;
        rst_k, val_k_ld   : in std_logic;
        rst_sum, sum_ld   : in std_logic;

        -- memory signals
        base_in, base_k, base_out : in unsigned(17 downto 0);
        mem_addr_sel   : in std_logic_vector(1 downto 0);
        sum_sel        : in std_logic;
        mem_read_data  : in std_logic_vector(31 downto 0);
        mem_write_data : out std_logic_vector(31 downto 0);
        mem_addr       : out unsigned(17 downto 0)
    );
end component;

--controller
component controller 
port(
rst, clk : in std_logic;
start : in std_logic;
done : out std_logic;

--up_counter 
rst_i, inc_i: out std_logic;
rst_j, inc_j: out std_logic;
rst_m, inc_m: out std_logic;
rst_n, inc_n: out std_logic;
z_i, z_j, z_m, z_n : in std_logic;

--reg
rst_in, rst_k, rst_sum: out std_logic;
val_in_ld, val_k_ld, sum_ld : out std_logic;

-- mux
mem_addr_sel: out std_logic_vector(1 downto 0);
sum_sel : out std_logic;

--mem signal
mem_w_en, mem_r_en: out std_logic

);
end component;

component memory 
    port(
        clk   : in std_logic;
        mem_w_en    : in std_logic;
        mem_r_en    : in std_logic;
        mem_addr  : in unsigned(17 downto 0);         
        d_in  : in std_logic_vector(31 downto 0);
        d_out : out std_logic_vector(31 downto 0)
    );
end component;


component convolution_image
port(
-- control signals
        start       : in  std_logic;
        clk         : in  std_logic;
        rst         : in  std_logic;
        done        : out std_logic;

        -- parameters
        N, K        : in  unsigned(7 downto 0);
        base_in     : in  unsigned(17 downto 0);
        base_k      : in  unsigned(17 downto 0);
        base_out    : in  unsigned(17 downto 0);

        -- memory interface
        mem_w_en        : out std_logic;
        mem_r_en        : out std_logic;
        mem_addr        : out unsigned(17 downto 0);
        mem_write_data  : out std_logic_vector(31 downto 0);
        mem_read_data   : in  std_logic_vector(31 downto 0)

); 
end component;

end package lib_package;

package body lib_package is
end package body lib_package;
