import math
import sys

#N=32 -> 5
# [0-7 16-23; 8-15 24-31]
# W [16-31 ; 16-31]

#N=64 -> 6
# [0-7 16-23; 8-15 24-31; 32-39 48-55 ; 40-47 56-63] [0-7 32-39;8-15 40-47; 16-23 48-55 ; 24-31 56-63]
# W (wDistance = 1<<StageCnt) [16-23 ; 24-31; 16-23 ; 24-31]                   [32-39; 40-47; 48-55;56-63]

#MARK:Parameter
N = 256
BF_UNIT = 8

output_dir = "../rtl/ram_rom/"
format_file = "./rom_format/async_rom_dec.sv"


if len(sys.argv) >= 5:
    # The first argument is sys.argv[0] (the script name)
    # sys.argv[1] is the first actual argument
	N = int(sys.argv[1])
	BF_UNIT = int(sys.argv[2])
	output_dir = sys.argv[3]
	format_file = sys.argv[4]

	print(f"{N=}")
	print(f"{BF_UNIT=}")
	print(f"{output_dir=}")
	print(f"{format_file=}")

else:
	print("Required more Arg : Used Default Arg")

#MARK:Addr Calc
stage_cnt = int(math.log2(N))
rom = []
StageCnt = 0
OP_PER_SG = int(N//(2*BF_UNIT))
Divided = stage_cnt-4-1
Stride = 16
Div_cnt = 0
wExcced_Offset = dict()
wExceed_W = dict()
for i in range(stage_cnt-4):
	StageCnt = 4+i
	OpCnt = 0
	if Divided != 0:
		Div_cnt = 1
	Base = 0
	Exceed_Offset = 0
	W_Exceed_Offset = 0
	W_Exceed_Offset_inv = 0
	for j in range(OP_PER_SG):
		OpCnt = j
		if OpCnt == Div_cnt << (i+1):
			Exceed_Offset += 1 << (StageCnt+1)
			Base = Exceed_Offset
			W_Exceed_Offset = 0
			Div_cnt += 1
			W_Exceed_Offset_inv += 1
		print(StageCnt,OpCnt,Base,Base+Stride,Exceed_Offset,":", W_Exceed_Offset,(1<<StageCnt) + W_Exceed_Offset, ":",W_Exceed_Offset_inv)
		wExcced_Offset[(StageCnt,OpCnt)] = Base 
		wExceed_W[(0,StageCnt,OpCnt)] = W_Exceed_Offset # NTT
		wExceed_W[(1,StageCnt,OpCnt)] = W_Exceed_Offset_inv # INTT
		Base += 8
		W_Exceed_Offset += 8
	Stride += 16
	Divided -= 1

print(wExcced_Offset)
print(wExceed_W)


with open(f'{format_file}', 'r') as format:
	format_list = [line.rstrip() for line in format]


rom_depth = len(wExcced_Offset.keys())
name = "exceed_addr_dec"
output_path = f"{output_dir+name}.sv"
with open(f'{output_path}', 'w') as f:
	for code in format_list:
		if code == "module prog_rom_8bits":
			f.write("module "+name + "\n")
		else :
			f.write(code + "\n")
		if(code == "\t\t//ROM"):
			for x in wExcced_Offset:
				word_addr = (x[0] << int(math.log2(OP_PER_SG)+1)) + x[1]
				code_rom = f"\t\trom[{word_addr}] = {wExcced_Offset[x]};"
				f.write(code_rom + "\n")

name = "exceed_W_addr_dec"
output_path = f"{output_dir+name}.sv"
with open(f'{output_path}', 'w') as f:
	for code in format_list:
		if code == "module prog_rom_8bits":
			f.write("module "+name + "\n")
		else :
			f.write(code + "\n")
		if(code == "\t\t//ROM"):
			for x in wExceed_W:
				word_addr = (x[0] << int(math.ceil(math.log2(OP_PER_SG))+math.ceil(math.log2(math.log2(N)))+2)) + (x[1] << int(math.log2(OP_PER_SG)+1)) + x[2]
				code_rom = f"\t\trom[{word_addr}] = {wExceed_W[x]};"
				f.write(code_rom + "\n")
# print(math.ceil(math.log2(OP_PER_SG)),math.ceil(math.log2(math.log2(N))))
print("\nExceed_addr_dec Gen : Done")