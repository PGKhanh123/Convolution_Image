library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.lib_package.all; 

entity tb_convolution_image is
end tb_convolution_image;

architecture behavior of tb_convolution_image is
constant clk_period : time := 10 ns;
signal clk : std_logic := '0';
signal start, rst : std_logic;
signal done : std_logic;
 -- parameters
     signal    N, K        :   unsigned(7 downto 0);
     signal   base_in     :  unsigned(17 downto 0);
     signal   base_k      :   unsigned(17 downto 0);
     signal   base_out    :   unsigned(17 downto 0);

        -- memory interface
     signal   mem_w_en        :  std_logic;
     signal   mem_r_en        :  std_logic;
     signal   mem_addr        :  unsigned(17 downto 0);
     signal   mem_write_data  :  std_logic_vector(31 downto 0);
     signal   mem_read_data   :   std_logic_vector(31 downto 0);


begin 
clk <= not clk after clk_period/2;

dut : convolution_image
port map(
 -- control signals
        start      ,
        clk        ,
        rst        ,
        done       ,

        -- parameters
        N, K        ,
        base_in     ,
        base_k      ,
        base_out    ,

        -- memory interface
        mem_w_en        ,
        mem_r_en        ,
        mem_addr        ,
        mem_write_data  ,
        mem_read_data   
);

memory_unit : memory 
port map(
	clk   ,
        mem_w_en    ,
        mem_r_en    ,
        mem_addr  ,         
        mem_write_data  ,
        mem_read_data 
);


sim : process
	BEGIN
		N <= to_unsigned(5, 8);
                K <= to_unsigned(3, 8);
	        base_in <= to_unsigned(0, 18);
		base_k <= to_unsigned(25, 18);
                base_out <= to_unsigned(50, 18);
        
	        rst <= '1';
	        wait for clk_period;
                rst <= '0';
                start <= '1';
	        wait until done = '1';
	        start <= '0';
	        wait for 5 * clk_period;

	END PROCESS;

end behavior;