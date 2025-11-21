library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.sine_lut_pkg.all;

entity sine_lut is
    port (
        rst_n : in  std_logic;
        clk   : in  std_logic;
        addr  : in  std_logic_vector(LUT_ADDR_BITS+1 downto 0);
        wave  : out std_logic_vector(OUT_RES_BITS-1 downto 0)
    );
end entity sine_lut;

architecture rtl of sine_lut is

    signal pointer : std_logic_vector(LUT_ADDR_BITS-1 downto 0);

    signal sine_val : std_logic_vector(OUT_RES_BITS-1 downto 0);

    signal wave_reg : std_logic_vector(OUT_RES_BITS-1 downto 0);

begin

    pointer <= not addr(LUT_ADDR_BITS-1 downto 0) when addr(LUT_ADDR_BITS) = '1' else addr(LUT_ADDR_BITS-1 downto 0);

    sine_val <= SINE_TABLE(to_integer(unsigned(pointer)));

    wave_reg_logic : process(rst_n, clk)
    begin
        if rst_n = '0' then
            wave_reg <= (others => '0');
        elsif rising_edge(clk) then
            if addr(LUT_ADDR_BITS + 1) = '1' then
                wave_reg <= std_logic_vector(unsigned(not sine_val) + 1);
            else
                wave_reg <= sine_val;
            end if;
        end if ;
    end process wave_reg_logic; -- wave_reg_logic

    -- Assign register to output
    wave <= wave_reg;

end architecture rtl;