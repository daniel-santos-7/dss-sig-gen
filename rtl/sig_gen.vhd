library IEEE;
library work;
use IEEE.std_logic_1164.all;
use work.sig_gen_pkg.all;
use work.sine_lut_pkg.LUT_ADDR_BITS;
use work.sine_lut_pkg.OUT_RES_BITS;

entity sig_gen is
    generic (
        PHA_ACC_BITS : natural := 32
    );
    port (
        rst_n   : in  std_logic;
        clk     : in  std_logic;
        pha_inc : in  std_logic_vector(PHA_ACC_BITS-1 downto 0);
        dds_out : out std_logic_vector(OUT_RES_BITS-1 downto 0)
    );
end entity sig_gen;

architecture rtl of sig_gen is

    signal pha_val : std_logic_vector(PHA_ACC_BITS-1 downto 0);

    signal addr : std_logic_vector(LUT_ADDR_BITS downto 0);

begin

    u_pha_acc : pha_acc generic map (
        PHA_ACC_BITS => PHA_ACC_BITS
    ) port map (
        rst_n   => rst_n,
        clk     => clk,
        pha_inc => pha_inc,
        pha_val => pha_val
    );

    addr <= pha_val(PHA_ACC_BITS-1 downto PHA_ACC_BITS-LUT_ADDR_BITS-1);

    u_sine_lut : sine_lut port map (
        rst_n  => rst_n,
        clk    => clk,
        addr   => addr,
        wave   => dds_out
    );

end architecture rtl;