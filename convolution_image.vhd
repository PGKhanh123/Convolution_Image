	library IEEE;
use IEEE.STD_LOGIC_1164.ALL;	
use IEEE.NUMERIC_STD.ALL;
use WORK.lib_package.ALL;

entity convolution_image is
    port (
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
end convolution_image;


architecture rtl of convolution_image is

    -- internal control signals
    signal rst_i, inc_i      : std_logic;
    signal rst_j, inc_j      : std_logic;
    signal rst_m, inc_m      : std_logic;
    signal rst_n, inc_n      : std_logic;
    signal z_i, z_j, z_m, z_n: std_logic;

    signal val_in_ld, val_k_ld, sum_ld : std_logic;
    signal rst_in, rst_k, rst_sum      : std_logic;

    signal mem_addr_sel : std_logic_vector(1 downto 0);
    signal sum_sel      : std_logic;

begin

    --------------------------------------------------------------------
    -- Controller module
    --------------------------------------------------------------------
    control_unit : controller 
        port map(
            rst   => rst,
            clk   => clk,
            start => start,
            done  => done,

            -- up_counter controls
            rst_i => rst_i,  inc_i => inc_i,
            rst_j => rst_j,  inc_j => inc_j,
            rst_m => rst_m,  inc_m => inc_m,
            rst_n => rst_n,  inc_n => inc_n,

            z_i => z_i, z_j => z_j, z_m => z_m, z_n => z_n,

            -- register controls
            rst_in     => rst_in,
            rst_k      => rst_k,
            rst_sum    => rst_sum,
            
            val_in_ld  => val_in_ld,
            val_k_ld   => val_k_ld,
            sum_ld     => sum_ld,
	    
            -- mux selects
            mem_addr_sel => mem_addr_sel,
            sum_sel      => sum_sel,

            -- memory control
            mem_w_en => mem_w_en,
            mem_r_en => mem_r_en
        );


    --------------------------------------------------------------------
    -- Datapath module
    --------------------------------------------------------------------
    datapath_unit : datapath
        port map(
            rst => rst,
            clk => clk,
            K   => K,
            N   => N,

            -- counter controls
            rst_i => rst_i, inc_i => inc_i,
            rst_j => rst_j, inc_j => inc_j,
            rst_m => rst_m, inc_m => inc_m,
            rst_n => rst_n, inc_n => inc_n,

            z_i => z_i, z_j => z_j, z_m => z_m, z_n => z_n,

            -- register controls
            rst_in     => rst_in,  val_in_ld => val_in_ld,
            rst_k      => rst_k,   val_k_ld  => val_k_ld,
            rst_sum    => rst_sum, sum_ld    => sum_ld,
            
            -- memory interface
            base_in        => base_in,
            base_k         => base_k,
            base_out       => base_out,
            mem_addr_sel   => mem_addr_sel,
            sum_sel        => sum_sel,
            mem_read_data  => mem_read_data,
            mem_write_data => mem_write_data,
            mem_addr       => mem_addr
        );

end rtl;

