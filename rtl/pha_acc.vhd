library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pha_acc is
    generic (
        PHA_ACC_BITS : natural := 32
    );
    port (
        rst_n   : in  std_logic;
        clk     : in  std_logic;
        pha_inc : in  std_logic_vector(PHA_ACC_BITS-1 downto 0);
        pha_val : out std_logic_vector(PHA_ACC_BITS-1 downto 0)
    );
end entity pha_acc;

architecture rtl of pha_acc is

    signal pha_reg : std_logic_vector(PHA_ACC_BITS-1 downto 0);

begin

    pha_reg_logic : process(clk, rst_n)
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                pha_reg <= (others => '0');
            else
                pha_reg <= std_logic_vector(unsigned(pha_reg) + unsigned(pha_inc));
            end if ;
        end if ;
    end process pha_reg_logic; -- pha_reg_logic

    pha_val <= pha_reg;

end architecture rtl;