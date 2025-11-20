#!/usr/bin/python3

import math
import sys

if __name__ == '__main__':

    argv_len = len(sys.argv)

    if argv_len == 1:
        print(f'Use: {sys.argv[0]} <lut-addr-bits> <out-res-bits>')
        print('default values: lut-addr-bits=8 out-res-bits=12')
        exit(1)

    # LUT address bits
    lut_addr_bits = int(sys.argv[1]) if argv_len > 1 else 8

    # Output resolution bits
    out_res_bits = int(sys.argv[2]) if argv_len > 2 else 12

    # Period
    period = math.pi

    # Samples quantity
    samples = 2 ** lut_addr_bits

    k = period / samples

    s = [math.sin(k*n-math.pi/2) for n in range(0, samples)]

    amplitude = 2 ** (out_res_bits - 1) - 1

    y = [amplitude * (x + 1) for x in s]

    hex_digits = math.ceil(out_res_bits / 4)

    lut = [f'x"{int(v):0{hex_digits}x}"' for v in y]

    lut_values = ',\n\t\t'.join(lut)

    template = f'''
library IEEE;
use IEEE.std_logic_1164.all;

package sine_lut_pkg is
    
    constant LUT_ADDR_BITS : natural := {lut_addr_bits};

    constant OUT_RES_BITS  : natural := {out_res_bits};

    type sine_lut_array is array (0 to 2 ** LUT_ADDR_BITS-1) of std_logic_vector(OUT_RES_BITS-1 downto 0);

    constant SINE_TABLE : sine_lut_array := (
        {lut_values}
    );

end package sine_lut_pkg;
    '''
    print(template)