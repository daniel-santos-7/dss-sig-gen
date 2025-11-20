library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.sig_gen_pkg.all;
use work.sine_lut_pkg.OUT_RES_BITS;

entity sig_gen_tb is
    generic (
        PHA_ACC_BITS : natural := 32
    );
end sig_gen_tb;

architecture tb of sig_gen_tb is

    -- Testbench signals
    signal rst_n   : std_logic := '0';
    signal clk     : std_logic := '0';
    signal pha_inc : std_logic_vector(PHA_ACC_BITS-1 downto 0) := (others => '0');
    signal dds_out : std_logic_vector(OUT_RES_BITS-1 downto 0);

    -- Clock period
    constant CLK_PERIOD : time := 10 ns;

    signal clk_en : boolean := true;

begin

    -- Instantiate the unit under test
    uut : sig_gen
        generic map (
            PHA_ACC_BITS => PHA_ACC_BITS
        )
        port map (
            rst_n   => rst_n,
            clk     => clk,
            pha_inc => pha_inc,
            dds_out => dds_out
        );

    -- Clock generation
    clk_process : process
    begin
        while clk_en loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Test stimulus
    stim_process : process
    begin
        -- Initialize reset
        rst_n <= '0';
        pha_inc <= (others => '0');

        -- Release reset
        wait until rising_edge(clk);
        rst_n <= '1';

        -- Set phase increment (example: 1/256 of full range for slow frequency)
        wait until rising_edge(clk);
        pha_inc <= std_logic_vector(to_unsigned(16777216, 32)); -- 2^24

        -- End simulation
        for i in 0 to 1000 loop
            wait until rising_edge(clk);
        end loop;
        clk_en <= false;
        wait;
    end process;

end tb;