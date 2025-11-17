library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sig_gen is
    generic (
        PHA_ACC_BITS : natural := 32;
        OUT_RES_BITS : natural := 12
    );
    port (
        rst_n   : in  std_logic;
        clk     : in  std_logic;
        pha_inc : in  std_logic_vector(PHA_ACC_BITS-1 downto 0);
        dds_out : out std_logic_vector(OUT_RES_BITS-1 downto 0)
    );
end entity sig_gen;

architecture rtl of sig_gen is

    component sine_lut is
        generic (
            LUT_ADDR_BITS : natural := 32;
            OUT_RES_BITS  : natural := 12
        );
        port (
            rst_n : in  std_logic;
            clk   : in  std_logic;
            addr  : in  std_logic_vector(LUT_ADDR_BITS-1 downto 0);
            wave  : out std_logic_vector(OUT_RES_BITS-1 downto 0)
        );
    end component sine_lut;

    signal phase_reg : std_logic_vector(PHA_ACC_BITS-1 downto 0);

begin

    phase_reg_logic : process(clk, rst_n)
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                phase_reg <= (others => '0');
            else
                phase_reg <= std_logic_vector(unsigned(phase_reg) + unsigned(pha_inc));
            end if ;
        end if ;
    end process phase_reg_logic; -- phase_reg_logic

    u_sine_lut : sine_lut generic map (
        LUT_ADDR_BITS => 8,
        OUT_RES_BITS  => OUT_RES_BITS
    ) port map (
        rst_n  => rst_n,
        clk    => clk,
        addr   => phase_reg(PHA_ACC_BITS-1 downto PHA_ACC_BITS-8),
        wave   => dds_out
    );

end architecture rtl;