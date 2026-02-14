import numpy as np
import time
import sympy
import math
import mont

#--------------------------------------------------------------------------------------------------------
#MARK: Classic

def poly_add_sub(f,g,sub=False):
	lf = len(f)
	lg = len(g)
	if lf < lg:
		new_f = np.concatenate((f,np.array([0]*(lg-lf))))
		if sub:
			return new_f + (-1*g)
		else :
			return new_f + g
	else :
		new_g = np.concatenate((g,np.array([0]*(lf-lg))))
		if sub :
			return f + (-1*new_g)
		else :
			return f + new_g


def cyclic_poly_mul(f,g,div,N):
	#f,g = set of polynomail coeff
	#f = (f0,f1,f2) == f0 + f1x^1 + f2x^2
	#N = len of set
	fnp = np.array(f,dtype=int)
	gnp = np.array(g,dtype=int)
	result = np.array([0]*(2*N-1),dtype=int)
	for i in range(N):
		mult = fnp*gnp[-(i+1)]
		# print(mult)
		result[(2*N-1)-i-N:(2*N-1)-i] += mult
		# print(result)
	
	div_res = result
	idx = (2*N-1)
	padd_front = N-2
	padd_back = 0
	divnp = np.array(div)
	while idx > N:
		div_pad = np.concatenate((np.zeros(padd_front),divnp, np.zeros(padd_back)))
		front = div_res[idx-1]
		mult_s = front*div_pad 
		# print("mult",front,mult_s)
		div_res = poly_add_sub(div_res,mult_s,True)
		# print(div_res)
		idx -= 1
		padd_front -= 1
		padd_back += 1
	
	return div_res


#--------------------------------------------------------------------------------------------------------
#MARK: NTT

def NIST_PQC_CONST(name):
	global Test_N
	if name == "Dill":
		return (256,8380417)
	elif name == "Kyber1":
		return (256,7681)
	elif name == "Kyber3":
		return (256,3329)
	elif name == "Test":
		return (Test_N,7681)
	else :
		print("Not Support")
		return (-1,-1)
	
def NIST_PQC_NTT_MATRIX_PRECOMPUTE(name,neq_wrap=False):
	const = NIST_PQC_CONST(name)
	if const == (-1,-1):
		return -1
	
	
	n,q = const[0],const[1]
	mat = np.zeros((n,n),dtype=int)
	mat_inv = np.zeros((n,n),dtype=int)
	global w 
	global w_inv 
	global phi
	global phi_inv
	# print(mat.size)
	
	if name == "Test":
		if not neq_wrap:
			#Forward
			tmp_dic = dict()
			for row in range(n):
				for col in range(row,n):
					k = row*col
					if k > n:
						k = k%n

					if k not in tmp_dic:
						w_res = (w**k)%q
						tmp_dic[k] = w_res
					else:
						w_res = tmp_dic[k]

					mat[row,col] = w_res
					mat[col,row] = w_res
					# print(row,col)
			np.savetxt('./data/test_ntt_mat.csv', mat, delimiter=',') 

			#Inverse
			tmp_dic = dict()
			for row in range(n):
				for col in range(row,n):
					k = row*col
					if k > n:
						k = k%n
					if k not in tmp_dic:
						w_res = (w_inv**k)%q
						tmp_dic[k] = w_res
					else:
						w_res = tmp_dic[k]
					mat_inv[row,col] = w_res
					mat_inv[col,row] = w_res
					# print(row,col)
			np.savetxt('./data/test_Intt_mat.csv', mat_inv, delimiter=',') 
			# print(mat_inv)

			return mat,mat_inv
		else:
			#Forward
			tmp_dic = dict()
			for row in range(n):
				for col in range(n):
					k = (2*row*col)+col
					if k > 2*n:
						k = k%(2*n)

					if k not in tmp_dic:
						w_res = (phi**k)%q
						tmp_dic[k] = w_res
					else:
						w_res = tmp_dic[k]

					mat[row,col] = w_res
					# print(row,col)
			np.savetxt('./data/test_neg_ntt_mat.csv', mat, delimiter=',') 

			#Inverse
			tmp_dic = dict()
			for row in range(n):
				for col in range(n):
					k = row*col
					if k > n:
						k = k%n
					k = 2*k + row
					if k not in tmp_dic:
						w_res = (phi_inv**k)%q
						tmp_dic[k] = w_res
					else:
						w_res = tmp_dic[k]
					mat_inv[row,col] = w_res
					# print(row,col)
			np.savetxt('./data/test_neg_Intt_mat.csv', mat_inv, delimiter=',') 
			# print(mat_inv)
	else:
		print("Not Support")


def ntt(x,method="Test"):
	#x = coef vector (a0,a1,a2,...)
	global test_ntt_mat
	const = NIST_PQC_CONST(method)
	if const == (-1,-1):
		print("Wrong method")
	n,q = const[0],const[1]
	# test_ntt_mat = np.loadtxt('./data/test_ntt_mat.csv', delimiter=',')
	if len(x) != n:
		print("Wrong Size")

	if method == "Test":
		return np.dot(test_ntt_mat,x)%q
	else:
		print("Not Support")


def inv_ntt(x,method="Test"):
	#x = coef vector (a0,a1,a2,...)
	global test_Intt_mat
	const = NIST_PQC_CONST(method)
	if const == (-1,-1):
		print("Wrong method")
	n,q = const[0],const[1]
	# test_Intt_mat = np.loadtxt('./data/test_Intt_mat.csv', delimiter=',')
	if len(x) != n:
		print("Wrong Size")

	if method == "Test":
		global n_inv
		return ((np.dot(test_Intt_mat,x)%q)*n_inv)%q
	else:
		print("Not Support")

def modInverse(A, M):

    for X in range(1, M):
        if (((A % M) * (X % M)) % M == 1):
            return X
    return -1

#--------------------------------------------------------------------------------------------------------
#MARK: NTT 2Stage Butterfly Matrix

def NTT_Butterfly_PRECOMPUTE_2stage(name,neq_wrap=False):
	const = NIST_PQC_CONST(name)
	if const == (-1,-1):
		return -1
	
	
	n,q = const[0],const[1]
	n = n//2
	mat = np.zeros((n,n),dtype=int)
	mat_inv = np.zeros((n,n),dtype=int)
	global w 
	global w_inv 
	global phi
	global phi_inv
	# print(mat.size)
	w_tmp = (w**2)%q
	w_inv_tmp = modInverse(w_tmp,q)
	phi = (phi**2)%q
	phi_inv = modInverse(phi,q)
	if name == "Test":
		if not neq_wrap:
			#Forward
			tmp_dic = dict()
			for row in range(n):
				for col in range(row,n):
					k = row*col
					if k > n:
						k = k%n

					if k not in tmp_dic:
						w_res = (w_tmp**k)%q
						tmp_dic[k] = w_res
					else:
						w_res = tmp_dic[k]

					mat[row,col] = w_res
					mat[col,row] = w_res
					# print(row,col)
			np.savetxt('./data/butterfly_test_ntt_mat.csv', mat, delimiter=',') 

			#Inverse
			tmp_dic = dict()
			for row in range(n):
				for col in range(row,n):
					k = row*col
					if k > n:
						k = k%n
					if k not in tmp_dic:
						w_res = (w_inv_tmp**k)%q
						tmp_dic[k] = w_res
					else:
						w_res = tmp_dic[k]
					mat_inv[row,col] = w_res
					mat_inv[col,row] = w_res
					# print(row,col)
			np.savetxt('./data/butterfly_test_Intt_mat.csv', mat_inv, delimiter=',') 
			# print(mat_inv)

			return mat,mat_inv
		else:
			#Forward
			tmp_dic = dict()
			for row in range(n):
				for col in range(n):
					k = (2*row*col)+col
					if k > 2*n:
						k = k%(2*n)

					if k not in tmp_dic:
						w_res = (phi**k)%q
						tmp_dic[k] = w_res
					else:
						w_res = tmp_dic[k]

					mat[row,col] = w_res
					# print(row,col)
			np.savetxt('./data/butterfly_test_neg_ntt_mat.csv', mat, delimiter=',') 

			#Inverse
			tmp_dic = dict()
			for row in range(n):
				for col in range(n):
					k = row*col
					if k > n:
						k = k%n
					k = 2*k + row
					if k not in tmp_dic:
						w_res = (phi_inv**k)%q
						tmp_dic[k] = w_res
					else:
						w_res = tmp_dic[k]
					mat_inv[row,col] = w_res
					# print(row,col)
			np.savetxt('./data/butterfly_test_neg_Intt_mat.csv', mat_inv, delimiter=',') 
			# print(mat_inv)
	else:
		print("Not Support")


def fast_2s_ntt(f_even,f_odd,method="Test"):
	#x = coef vector (a0,a1,a2,...)
	global butterfly_test_ntt_mat
	global w_odd
	const = NIST_PQC_CONST(method)
	if const == (-1,-1):
		print("Wrong method")
	n,q = const[0],const[1]

	if method == "Test":
		y0 = np.dot(butterfly_test_ntt_mat,f_even)%q
		# print(y0)
		y1 = np.dot(butterfly_test_ntt_mat,f_odd)%q
		# print(y0,y1) # print(np.concatenate((y0,y0))) # print(w_odd*np.concatenate((y1,y1)))
		y1_butterfly = w_odd*np.concatenate((y1,y1))
		G_2stage = (np.concatenate((y0,y0))+y1_butterfly)%q
		return G_2stage
	else:
		print("Not Support")


def inv_fast_2s_ntt(x,method):
	global butterfly_test_Intt_mat
	global w_inv_odd
	const = NIST_PQC_CONST(method)
	if const == (-1,-1):
		print("Wrong method")
	n,q = const[0],const[1]

	x_even = np.array([x[i] for i in range(0,Test_N,2)])
	x_odd = np.array([x[i] for i in range(1,Test_N,2)])

	if method == "Test":
		y0 = np.dot(butterfly_test_Intt_mat,x_even)%q
		y1 = np.dot(butterfly_test_Intt_mat,x_odd)%q
		y1_butterfly = w_inv_odd*np.concatenate((y1,y1))
		G_2stage = (((np.concatenate((y0,y0))+y1_butterfly)%q)*n_inv)%q
		return G_2stage
	else:
		print("Not Support")


#--------------------------------------------------------------------------------------------------------
#MARK: NTT Full Butterfly Matrix

def bit_reversal(f,N):
	bit_cnt = int(math.log2(N))
	result = np.zeros(N,dtype=int)
	for i in range(N):
		b = bin(i)[2:]
		if len(b) < bit_cnt:
			b = '0'*(bit_cnt-len(b)) + b
		b_rev = "0b"+b[::-1]
		result[int(b_rev,2)] = int(f[i])
	return result

btf_calc_time = 0
def full_fast_ntt(f_br,q,N,factor_table):
	global phi
	global q_inv
	global btf_calc_time
	# print(power_table)
	f = f_br
	# print(f)
	stage_cnt = int(math.log2(N))
	# power_table = [0,4,2,6,1,3,5,7]
	idx = 1
	for i in range(stage_cnt):
		mem = 2**(i+1)
		pair = 2**i
		for m in range(pair): # Loop to other group
			for k in range(m,N,mem): # Loop in Group
				start_time = time.perf_counter()
				w_odd = factor_table[idx]
				j = k+pair
				# print(i,m,k,j,idx)
				# T = (w_odd*f[j])%q

				#Montgomery mult mod\
				# print("In",f[k],f[j],w_odd,q,q_inv)
				if f[k] < 0:
					f[k] += q
				if f[j] < 0:
					f[j] += q
				Tmult = f[j]*w_odd
				# print("mult",Tmult)
				T = mont.mon_inv_transform(Tmult,2**13,q_inv,q)
				# print(T==Tmont)
				# print(T)
				tmp = f[k]
				# print(tmp+T,(tmp + T)%q)
				f[k] = (tmp + T)%q
				f[j] = (tmp - T)%q
				end_time = time.perf_counter()
				btf_calc_time = end_time - start_time
				# print("Out",f[k],f[j])
			idx += 1
			# print(pw_idx)
		# print(f_br)
	return f

def full_fast_Intt(f_br,q,N,N_inv,factor_table):
	global phi_inv
	# print(f_br)
	f = f_br
	stage_cnt = int(math.log2(N))
	# power_table_fix = [0,4,2,6,1,5,3,7]
	for i in range(stage_cnt):
		mem = 2**(i+1)
		pair = 2**i
		idx_stage = 2**(stage_cnt-i-1) #4,2,1 [0,4(1),2(2),6,1(4),5,3,7]
		for m in range(pair): # Loop in Group
			idx = idx_stage
			for k in range(m,N,mem): # Loop to other group
				w_odd = factor_table[idx]
				j = k+pair
				# print(i,m,k,j,idx,w_odd)

				# print("In",f[k],f[j],w_odd,q,q_inv)
				t0 = f[k] + f[j]
				t1 = f[k] - f[j]
				# print("ADD,SUB mod q",t0,t1)
				if t1 < 0:
					t1 += q
				f[k] = (t0)%q
				

				Tmult = t1*w_odd
				T = mont.mon_inv_transform(Tmult,2**13,q_inv,q)
				f[j] = T
				# print("Out",f[k],f[j])
				idx += 1
		# print(f_br)
	return (f*N_inv)%q



#--------------------------------------------------------------------------------------------------------
#MARK: MAIN
def main():
	print("Start")
	global Test_N
	global q_inv
	global w
	global w_inv
	global phi
	global phi_inv
	global n
	global n_inv
	global test_ntt_mat
	global test_Intt_mat
	global butterfly_test_ntt_mat
	global w_odd
	global butterfly_test_Intt_mat
	global w_inv_odd

	Test_N = 16
	const = NIST_PQC_CONST("Test")
	if const == (-1,-1):
		print("Wrong method")
	n,q = const[0],const[1]
	q_inv = (-modInverse(q,2**13))%(2**13)
	print("n,q,q_inv =",n,q,q_inv)
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

	w_inv = modInverse(w,q)
	n_inv = modInverse(n,q)
	n_inv_mont = (n_inv*(2**13))%q
	phi_inv = modInverse(phi,q)
	print("(w,w_inv,n_inv) =",(w,w_inv,n_inv),n_inv_mont)
	print("phi,phi_inv =",phi,phi_inv)
	print("Check Mod Inverse Correctness = ",(w*w_inv)%q, (n*n_inv)%q, (phi*phi_inv)%q)

	# f = [-1,2,-3,3]
	# g = [0,-3,2,3]
	# f = np.random.randint(-3,3,size=(Test_N)).tolist()
	# g = np.random.randint(-3,3,size=(Test_N)).tolist()
	f = np.array(range(1,Test_N+1))
	g = np.array(range(Test_N,Test_N*2))
	# print(f,g)
	div = np.zeros((Test_N+1),dtype=int).tolist()
	div[Test_N] = 1
	div[0] = 1
	# print("f=",f)
	# print("g=",g)
	# print("n=",n)

	print("<Numpy>")
	fnp = f[::-1]
	gnp = g[::-1]
	start_time = time.perf_counter()
	Res_np = (np.polydiv(np.polymul(fnp,gnp),div)[1])[::-1]
	end_time = time.perf_counter()
	# print(Res_np)
	elapsed_timeNP = end_time - start_time
	print(f"Execution time: {elapsed_timeNP:.4f} seconds")

	print("<Classic>")
	start_time = time.perf_counter()
	Res_classic = (cyclic_poly_mul(f,g,div,len(f))%q)[0:Test_N]
	end_time = time.perf_counter()
	# print(Res_classic)
	elapsed_timeC = end_time - start_time
	print(f"Execution time: {elapsed_timeC:.4f} seconds")


	NIST_PQC_NTT_MATRIX_PRECOMPUTE("Test")
	NIST_PQC_NTT_MATRIX_PRECOMPUTE("Test",neq_wrap=True)
	# test_ntt_mat = np.loadtxt('./data/test_ntt_mat.csv', delimiter=',')
	# test_Intt_mat = np.loadtxt('./data/test_Intt_mat.csv', delimiter=',')
	test_ntt_mat = np.loadtxt('./data/test_neg_ntt_mat.csv', delimiter=',')
	test_Intt_mat = np.loadtxt('./data/test_neg_Intt_mat.csv', delimiter=',')
	np.set_printoptions(suppress=True, precision=2)
	# print(test_ntt_mat)
	# print(test_Intt_mat)


	print("<NTT Method>")
	start_time = time.perf_counter()
	# Conv = ((np.dot(test_ntt_mat,f)%q)*(np.dot(test_ntt_mat,g)%q))
	# ResNtt = ((np.dot(test_Intt_mat,Conv)%q)*n_inv)%q
	F = ntt(f);G = ntt(g)
	ResNtt = inv_ntt(F*G)
	end_time = time.perf_counter()
	# print(ResNtt)
	elapsed_timeNTT = end_time - start_time
	print(f"Execution time: {elapsed_timeNTT:.4f} seconds")

	print("<Verify> :",sum(Res_classic != ResNtt) == 0)

	# print("\n<NTT Butterfly>") ~~~!!!Only for Positive Wrapped
	# # print(f)
	# start_time = time.perf_counter()
	# F = ntt(f,"Test")
	# end_time = time.perf_counter()
	# # t = end_time-start_time
	# # print(f"Transform time: {t:.7f} seconds")
	# G = ntt(g,"Test")
	# # print("Direct NTT=",G)


	# NTT_Butterfly_PRECOMPUTE_2stage("Test",False)
	# butterfly_test_ntt_mat = np.loadtxt('./data/butterfly_test_ntt_mat.csv', delimiter=',')
	# butterfly_test_Intt_mat = np.loadtxt('./data/butterfly_test_Intt_mat.csv', delimiter=',')
	# # print(test_ntt_mat)
	# # print(test_Intt_mat)

	# f_even = np.array([f[i] for i in range(0,Test_N,2)])
	# f_odd = np.array([f[i] for i in range(1,Test_N,2)])
	# g_even = np.array([g[i] for i in range(0,Test_N,2)])
	# g_odd = np.array([g[i] for i in range(1,Test_N,2)])

	# w_odd = np.array([(w**(i))%q for i in range(n)])
	# w_inv_odd = np.array([(w_inv**(i))%q for i in range(n)])

	# F_2stage = fast_2s_ntt(f_even,f_odd,"Test")
	# G_2stage = fast_2s_ntt(g_even,g_odd,"Test")
	# print("Direct vs 2 Stage NTT(f)=",sum(F_2stage!=F) == 0)
	# print("Direct vs 2 Stage NTT(g)=",sum(G_2stage!=G) == 0)
	# F_inv = inv_ntt(F,"Test")
	# F_inv_2stage = inv_fast_2s_ntt(F_2stage,"Test")
	# print("Direct vs 2 Stage INTT(F)=",sum(F_inv_2stage!=F_inv) == 0)
	# G_inv_2stage = inv_fast_2s_ntt(G_2stage,"Test")
	# print("Direct vs 2 Stage INTT(G)=",sum(G_inv_2stage!=[gg%q for gg in g]) == 0)
	# # print(G_inv_2stage)

	# start_time = time.perf_counter()
	# F_2stage = fast_2s_ntt(f_even,f_odd,"Test")
	# G_2stage = fast_2s_ntt(g_even,g_odd,"Test")
	# ResNtt_fast = inv_fast_2s_ntt(F_2stage*G_2stage,"Test")
	# end_time = time.perf_counter()
	# # print(ResNtt_fast)
	# elapsed_timeNTT_fast = end_time - start_time
	# print(f"Execution time(Full PolyMultMod Step): {elapsed_timeNTT_fast:.4f} seconds")
	# print("Verify :",sum(Res_classic != ResNtt_fast) == 0)

	print("<SymPy NTT>") #~~~!!!Only for Positive Wrapped
	start_time = time.perf_counter()
	Res_sympy = np.array(sympy.intt(((np.array(sympy.ntt(f,q))*np.array(sympy.ntt(g,q)))%q),q))
	end_time = time.perf_counter()
	# print(Res_sympy)
	elapsed_time_sympy = end_time - start_time
	print(f"Execution time: {elapsed_time_sympy:.4f} seconds")
	# print("Verify with DIY vs Sympy Lib :",sum(Res_sympy != ResNtt_fast) == 0)


	print("<Full Butterfly NTT>")
	N_inv = modInverse(Test_N,q)
	f_br = bit_reversal(f,Test_N)
	g_br = bit_reversal(g,Test_N)
	# print("bit reversed",f_br)

	#Generate Butterfly Twiddle Factor table
	power_table_ntt = [0]
	for i in range(int(math.log2(Test_N))):
		x = 2**(int(math.log2(Test_N))-i-1)
		for j in range(2**i):
			power_table_ntt.append(x)
			x += 2**(int(math.log2(Test_N))-i)
	# print(power_table_ntt)
	power_table_inv_ntt = bit_reversal([int(x) for x in range(Test_N)],Test_N)
	print(power_table_ntt,power_table_inv_ntt)
	factor_table_ntt = [mont.mont_transform((phi**x)%q,2**13,q) for x in power_table_ntt]
	print(max(factor_table_ntt))
	factor_table_inv_ntt = [mont.mont_transform(((phi_inv**int(x)))%q,2**13,q) for x in power_table_inv_ntt]
	factor_table_inv_ntt[1] = factor_table_inv_ntt[1]
	print(max(factor_table_inv_ntt))
	print(len(factor_table_ntt),len(factor_table_inv_ntt))
	# F_ntt_fast = full_fast_ntt(f_br,q,Test_N,factor_table_ntt)
	# G_ntt_fast = full_fast_ntt(g_br,q,Test_N,factor_table_ntt)
	# print("Test NTT :",sum(F_ntt_fast != ntt(f,"Test")) == 0)
	# F_inv_fast = full_fast_Intt(bit_reversal(F_ntt_fast,Test_N),q,Test_N,N_inv,factor_table_inv_ntt)
	# G_inv_fast = full_fast_Intt(bit_reversal(G_ntt_fast,Test_N),q,Test_N,N_inv,factor_table_inv_ntt)
	# print(F_ntt_fast)
	# print("Test NTT,INTT:",sum(F_inv_fast!=f)==0)

	start_time = time.perf_counter()
	F_ntt_fast = full_fast_ntt(f_br,q,Test_N,factor_table_ntt)
	G_ntt_fast = full_fast_ntt(g_br,q,Test_N,factor_table_ntt)
	start_time2 = time.perf_counter()
	Dot_res = (F_ntt_fast*G_ntt_fast)%q
	end_time2 = time.perf_counter()
	vectordot_time = end_time2 - start_time2
	ResultFNTT = full_fast_Intt(bit_reversal(Dot_res,Test_N),q,Test_N,N_inv,factor_table_inv_ntt)
	end_time = time.perf_counter()
	elapsed_time_fastfull = end_time - start_time
	print(f"Execution time: {elapsed_time_fastfull:.6f} seconds")
	print("Verify:",sum(ResultFNTT!=ResNtt)==0)
	print(",".join([str(i) for i in F_ntt_fast]))
	# print(ntt(f,"Test"))

	
	print("<Performance>")
	print("Numpy   \t\t: ",f"{elapsed_timeNP:.6f} seconds")
	print("Classic \t\t: ",f"{elapsed_timeC:.6f} seconds")
	print("My Matrix Mult NTT     \t: ",f"{elapsed_timeNTT:.6f} seconds")
	print("My Full Butterfly NTT\t: ",f"{elapsed_time_fastfull:.6f} seconds")
	
	print("\n[Hardware Approx Perf Calculation]")
	stage_cnt = math.log2(Test_N)
	btf_cnt = 8
	op_per_stage = Test_N//(2*btf_cnt)
	elapsed_time_fastfull_par = ((op_per_stage*btf_calc_time)*stage_cnt*3) + vectordot_time
	overhead_cycles = Test_N*2 #Rd ramA, WB ramA
	bf_cycles_each_op = 10
	elapsed_time_fastfull_hw = ((((op_per_stage*bf_cycles_each_op)+overhead_cycles)*10e-9*stage_cnt)*3) + vectordot_time
	print("**Full Butterfly 1 pair operation",f"{btf_calc_time:.6f} seconds")
	print("My Full Butterfly NTT Parallel (python speed)\t: ",f"{elapsed_time_fastfull_par:.6f} seconds")
	print("My Full Butterfly NTT Real HW approx (1 NTT = 7 cycle latency;100MHz)",f"{elapsed_time_fastfull_hw:.6f} seconds")
	# print("My NTT_fast(2stage)\t: ",f"{elapsed_timeNTT_fast:.6f} seconds")
	# print(f"Sympy   \t\t: {elapsed_time_sympy:.6f} seconds")

if __name__ == "__main__":
	main()