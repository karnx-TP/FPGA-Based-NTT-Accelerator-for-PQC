import numpy as np
import time
import sympy
import math
import mont
from ntt import bit_reversal

Test_N = 16
q = 7681
n = Test_N
q_inv = (-mont.modInverse(q,2**13))%(2**13)
print("n,q =",n,q)
w_list = sympy.ntheory.residue_ntheory.nthroot_mod(1,Test_N,q,True)
w = 0
for ww in w_list:
	found = 0
	if ww != 1:
		for i in range(1,n):
			if (ww**i)%q == 1:
				break
			if(i == n-1):
				print("w=",ww)
				found += 1
		if(found == 1):
			w = ww
			break

phi_list = sympy.ntheory.residue_ntheory.nthroot_mod(w,2,q,True)
phi = 0
for p in phi_list:
	if p != 1:
		if (p**2)%q == w and (p**n)%q == (q-1):
			phi = p
			break

w_inv = mont.modInverse(w,q)
n_inv = mont.modInverse(n,q)
phi_inv = mont.modInverse(phi,q)
print("(w,w_inv,n_inv) =",(w,w_inv,n_inv))
print("phi,phi_inv =",phi,phi_inv)
print("Check Mod Inverse Correctness = ",(w*w_inv)%q, (n*n_inv)%q, (phi*phi_inv)%q)
power_table_ntt = [0]
for i in range(int(math.log2(Test_N))):
	x = 2**(int(math.log2(Test_N))-i-1)
	for j in range(2**i):
		power_table_ntt.append(x)
		x += 2**(int(math.log2(Test_N))-i)
# print(power_table_ntt)
power_table_inv_ntt = bit_reversal([int(x) for x in range(Test_N)],Test_N)
factor_table_ntt = [mont.mont_transform((phi**x)%q,2**13,q) for x in power_table_ntt]
print(power_table_ntt,power_table_inv_ntt)
print(factor_table_ntt)
factor_table_inv_ntt = [mont.mont_transform((phi_inv**int(x))%q,2**13,q) for x in power_table_inv_ntt]
print(factor_table_inv_ntt)
print(len(factor_table_ntt),len(factor_table_inv_ntt))

#GEN ROM .sv

output_path_NTT = "../rtl/ram_rom/rom_wNTT.sv"
output_path_INV_NTT = "../rtl/ram_rom/rom_w_inv_NTT.sv"
format_file = "./rom_format/rom8x1024.sv"
mode = 0

# print(hex_string_prog)
rom_depth = Test_N
# for word_addr in range(rom_depth):
# 	if mode == 0:
# 		print(f"ram[{word_addr}*2] = 8'h{factor_table_ntt[word_addr]};")
# 	else :
# 		print(f"ram[{word_addr}*2] = 8'h{factor_table_inv_ntt[word_addr]};")

with open(f'{format_file}', 'r') as format:
	format_list = [line.rstrip() for line in format]
# print(format_list[22])


write_rom = 0
name = "rom_ntt"
output_path = output_path_NTT
with open(f'{output_path}', 'w') as f:
	for code in format_list:
		if code == "module prog_rom_8bits":
			f.write("module "+name + "\n")
		else :
			f.write(code + "\n")
		if(code == "\t\t//ROM"):
			for word_addr in range(rom_depth):
				code_rom = f"\t\trom[{word_addr}] = {factor_table_ntt[word_addr]};"
				f.write(code_rom + "\n")

name = "rom_intt"
output_path = output_path_INV_NTT
with open(f'{output_path}', 'w') as f:
	for code in format_list:
		if code == "module prog_rom_8bits":
			f.write("module "+name + "\n")
		else :
			f.write(code + "\n")
		if(code == "\t\t//ROM"):
			for word_addr in range(rom_depth):
				code_rom = f"\t\trom[{word_addr}] = {factor_table_inv_ntt[word_addr]};"
				f.write(code_rom + "\n")