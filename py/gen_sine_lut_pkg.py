#!/usr/bin/python3

import math as m
import os
import sys

N = 7
R = 12

k = m.pi/2**(N+1)
s = [m.sin(k*n) for n in range(0, 2**N)]

MAX_VALUE = 2**R-1
y = [int(x*MAX_VALUE) for x in s]

# Determina o caminho do arquivo de saída
script_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(script_dir)
output_file = os.path.join(project_root, 'rtl', 'sine_lut_pkg.vhd')

# Gera o conteúdo do package
content = []
content.append('library IEEE;')
content.append('use IEEE.std_logic_1164.all;')
content.append('')
content.append(f'package sine_lut_pkg is')
content.append(f'    type sine_lut_array is array (0 to {2**N-1}) of std_logic_vector({R-1} downto 0);')
content.append(f'    constant SINE_TABLE : sine_lut_array := (')
for i, v in enumerate(y):
    sep = "," if i < 2**N - 1 else ""
    # Converte o valor inteiro para string hexadecimal
    # Calcula quantos dígitos hex são necessários (R bits = ceil(R/4) dígitos hex)
    hex_digits = (R + 3) // 4
    hex_str = format(v, f'0{hex_digits}X')
    content.append(f'        X"{hex_str}"{sep}')
content.append(f'    );')
content.append(f'end package sine_lut_pkg;')

# Escreve o arquivo
with open(output_file, 'w') as f:
    f.write('\n'.join(content))

print(f'Package gerado com sucesso: {output_file}')
