library IEEE;
use IEEE.STD_LOGIC_1164.ALL;	
use IEEE.NUMERIC_STD.ALL;


entity controller is
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

end controller;

architecture rtl of controller is
    type state_type is (
        s0, s1, s2, s3, s4, s5, s6, s7, s8, s9,
        s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22
    );
    signal state : state_type;
begin
    process(clk, rst)
    begin
        if (rst = '1') then
            state <= s0;

        elsif (clk'event and clk = '1') then
            case state is
                when s0 =>
                    state <= s1;

                when s1 =>
                    if (start = '1') then
                        state <= s2;
                    else
                        state <= s1;
                    end if;

                when s2 =>
                    state <= s3;

                when s3 =>
                    if (z_i = '0') then
                        state <= s4;
                    else
                        state <= s20;
                    end if;

                when s4 =>
                    state <= s5;

                when s5 =>
                    if (z_j = '0') then
                        state <= s6;
                    else
                        state <= s19;
                    end if;

                when s6 =>
                    state <= s7;

                when s7 =>
                    state <= s8;

                when s8 =>
                    if (z_m = '0') then
                        state <= s9;
                    else
                        state <= s17;
                    end if;

                when s9 =>
                    state <= s10;

                when s10 =>
                    if (z_n = '0') then
                        state <= s11;
                    else
                        state <= s16;
                    end if;

                when s11 =>
                    state <= s12;

                when s12 =>
                    state <= s13;

                when s13 =>
                    state <= s14;

                when s14 =>
                    state <= s15;

                when s15 =>
                    state <= s10;

                when s16 =>
                    state <= s8;

                when s17 =>
                    state <= s18;

		when s18 =>
                    state <= s5;

		when s19 =>
                    state <= s3;

		when s20 =>
                    state <= s21;

                when s21 =>
                    if (start = '0') then
                        state <= s22;
                    else
                        state <= s21;
                    end if;

                when s22 =>
                    state <= s0;

                when others =>
                    state <= s0;
            end case;
        end if;
    end process;

     -- counter control signal
rst_i <= '1' when state = s0 or state = s2 else '0';
rst_j <= '1' when state = s0 or state = s4 else '0';
rst_m <= '1' when state = s0 or state = s6 else '0';
rst_n <= '1' when state = s0 or state = s9 else '0';
inc_n <= '1' when state = s15 else '0';
inc_m <= '1' when state = s16 else '0';
inc_j <= '1' when state = s18 else '0';
inc_i <= '1' when state = s19 else '0';

--  reg control signal
rst_in <= '1' when state = s0 else '0';
val_in_ld <= '1' when state = s12 else '0';
rst_k <= '1' when state = s0 else '0';
val_k_ld <= '1' when state = s14 else '0';
rst_sum <= '1' when state = s0 else '0';
sum_ld <= '1' when state = s7 or state = s15 else '0';

--mux
sum_sel <= '0' when state = s6 else 
           '1' when state = s15 else 
           '0';
mem_addr_sel <= "00" when state = s18 else
                "10" when state = s13 else
                "01" when state = s11 else
                "11";

-- memory control signal
mem_w_en <= '1' when state = s18 else '0';
mem_r_en <= '1' when (state = s11 or state = s13 ) else '0';

--done
done <= '1' when state = s20 else '0';
end rtl;

