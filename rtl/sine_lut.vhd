library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sine_lut is
    generic (
        LUT_ADDR_BITS : natural := 8;
        OUT_RES_BITS  : natural := 12
    );
    port (
        rst_n : in  std_logic;
        clk   : in  std_logic;
        addr  : in  std_logic_vector(LUT_ADDR_BITS-1 downto 0);
        wave  : out std_logic_vector(OUT_RES_BITS-1 downto 0)
    );
end entity sine_lut;

architecture rtl of sine_lut is

    type sine_lut_array is array (0 to 127) of std_logic_vector(11 downto 0);

    constant SINE_TABLE : sine_lut_array := (
        X"000",
        X"032",
        X"064",
        X"096",
        X"0C8",
        X"0FB",
        X"12D",
        X"15F",
        X"191",
        X"1C3",
        X"1F5",
        X"227",
        X"258",
        X"28A",
        X"2BC",
        X"2ED",
        X"31E",
        X"350",
        X"381",
        X"3B2",
        X"3E3",
        X"413",
        X"444",
        X"474",
        X"4A4",
        X"4D4",
        X"504",
        X"534",
        X"563",
        X"592",
        X"5C1",
        X"5F0",
        X"61F",
        X"64D",
        X"67B",
        X"6A9",
        X"6D6",
        X"704",
        X"731",
        X"75D",
        X"78A",
        X"7B6",
        X"7E2",
        X"80D",
        X"839",
        X"864",
        X"88E",
        X"8B9",
        X"8E3",
        X"90C",
        X"935",
        X"95E",
        X"987",
        X"9AF",
        X"9D7",
        X"9FE",
        X"A25",
        X"A4C",
        X"A72",
        X"A98",
        X"ABE",
        X"AE3",
        X"B07",
        X"B2B",
        X"B4F",
        X"B72",
        X"B95",
        X"BB8",
        X"BDA",
        X"BFB",
        X"C1C",
        X"C3D",
        X"C5D",
        X"C7D",
        X"C9C",
        X"CBA",
        X"CD9",
        X"CF6",
        X"D14",
        X"D30",
        X"D4C",
        X"D68",
        X"D83",
        X"D9E",
        X"DB8",
        X"DD1",
        X"DEB",
        X"E03",
        X"E1B",
        X"E32",
        X"E49",
        X"E60",
        X"E75",
        X"E8B",
        X"E9F",
        X"EB3",
        X"EC7",
        X"EDA",
        X"EEC",
        X"EFE",
        X"F0F",
        X"F20",
        X"F30",
        X"F3F",
        X"F4E",
        X"F5C",
        X"F6A",
        X"F77",
        X"F84",
        X"F90",
        X"F9B",
        X"FA6",
        X"FB0",
        X"FB9",
        X"FC2",
        X"FCA",
        X"FD2",
        X"FD9",
        X"FE0",
        X"FE6",
        X"FEB",
        X"FEF",
        X"FF3",
        X"FF7",
        X"FFA",
        X"FFC",
        X"FFD",
        X"FFE"
    );

    signal pointer : std_logic_vector(LUT_ADDR_BITS-2 downto 0);

    signal wave_reg : std_logic_vector(OUT_RES_BITS-1 downto 0);

begin

    pointer <= not addr(LUT_ADDR_BITS-2 downto 0) when addr(LUT_ADDR_BITS-1) = '1' else addr(LUT_ADDR_BITS-2 downto 0);

    wave_reg_logic : process(rst_n, clk)
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                wave_reg <= (others => '0');
            else
                wave_reg <= SINE_TABLE(to_integer(unsigned(pointer)));
            end if ;
        end if ;
    end process ; -- wave_reg_logic

    -- Assign register to output
    wave <= wave_reg;

end architecture rtl;