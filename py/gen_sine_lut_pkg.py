#!/usr/bin/python3

from typing import List
import math
import sys

# Generate sine values
def gen_sine_values(samples: int, amplitude: int, initial_phase: int, final_phase: int) -> List[float]:
    delta = (final_phase - initial_phase) / 180 * math.pi
    omega = delta / samples
    phi = initial_phase / 180 * math.pi
    return [amplitude * math.sin(omega*n + phi) for n in range(0, samples)]

# Convert a integer to a hex string
def int_to_hex_str(integer: int, bits: int) -> str:
    value = (2 ** bits + integer) if integer < 0 else integer
    hex_digits = math.ceil(bits / 4)
    return f'x"{value:0{hex_digits}x}"'

# Generate a VHDL list
def gen_vhdl_sine_lut(sine_values: List[float], bits: int) -> str:
    lut = [int_to_hex_str(integer, bits) for integer in map(int, sine_values)]
    return ',\n\t\t'.join(lut)

PACKAGE_TEMPLATE = '''library IEEE;
use IEEE.std_logic_1164.all;

package sine_lut_pkg is
    
    constant LUT_ADDR_BITS : natural := {lut_addr_bits};

    constant OUT_RES_BITS  : natural := {out_res_bits};

    type sine_lut_array is array (0 to 2 ** LUT_ADDR_BITS-1) of std_logic_vector(OUT_RES_BITS-1 downto 0);

    constant SINE_TABLE : sine_lut_array := (
        {lut_values}
    );

end package sine_lut_pkg;'''

if __name__ == '__main__':

    argv_len = len(sys.argv)

    if argv_len == 1:
        print(f'Use: {sys.argv[0]} <lut-addr-bits> <out-res-bits> <initial-phase-deg> <final-phase-deg>')
        print('default values: lut-addr-bits=8 out-res-bits=12')
        exit(1)

    # LUT address bits
    lut_addr_bits = int(sys.argv[1]) if argv_len > 1 else 8

    # Output resolution bits
    out_res_bits = int(sys.argv[2]) if argv_len > 2 else 12

    # Initial phase of the sine wave (default value = 0°)
    initial_phase = int(sys.argv[3]) if argv_len > 3 else 0

    # Final phase of the sine wave (default value = 360°)
    final_phase = int(sys.argv[4]) if argv_len > 4 else 360

    # Number of samples
    samples = 2 ** lut_addr_bits

    # Maximum / minimum value
    amplitude = 2 ** (out_res_bits - 1) - 1

    sine_values = gen_sine_values(samples, amplitude, initial_phase, final_phase)

    lut_values = gen_vhdl_sine_lut(sine_values, out_res_bits);

    package = PACKAGE_TEMPLATE.format(lut_addr_bits=lut_addr_bits, out_res_bits=out_res_bits, lut_values=lut_values)
    
    print(package)