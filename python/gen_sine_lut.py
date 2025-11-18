#!/usr/bin/python3

import math as m

N = 7
R = 12

k = m.pi/2**(N+1)
s = [m.sin(k*n) for n in range(0, 2**N)]

MAX_VALUE = 2**R-1
y = [int(x*MAX_VALUE) for x in s]

print(f'type sine_lut_array is array (0 to {2**N-1}) of std_logic_vector({R-1} downto 0);')
print(f'constant SINE_TABLE : sine_lut_array := (')
for i, v in enumerate(y):
    sep = "," if i < 2**N - 1 else ""
    # Converte o valor inteiro para string hexadecimal
    # Calcula quantos dígitos hex são necessários (R bits = ceil(R/4) dígitos hex)
    hex_digits = (R + 3) // 4
    hex_str = format(v, f'0{hex_digits}X')
    print(f'    X"{hex_str}"{sep}')
print(f');')
