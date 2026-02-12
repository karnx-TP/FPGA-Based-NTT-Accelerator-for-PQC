#--------------------------------------------------------------------------------------------------------
#MARK: 13bit Montgomery Reduction
def ExtendEuclid(a,b):
    s = 0;  old_s = 1
    t = 1;  old_t = 0
    r = b;  old_r = a
    while r != 0 :
        #print(old_r,old_s,old_t)
        #print(r,s,t)
        q = old_r//r
        [old_r, r] = [r, old_r%r]
        [old_s, s] = [s, old_s - q*s]
        [old_t, t] = [t, old_t - q*t] 
    return [old_s,old_t]
    
def mont_transform(x,r,m):
	return (x*r)%m

def monPro_Direct(a,b,r_inv,m):
	return (a*b*r_inv)%m

def monPro(a,b,r,m_inv,m):
    MultRes = (a*b)%r
    x = (m_inv * MultRes)%r
    xM = x*m
    r1 = (a*b + xM)//r 
    if r1 >= m : 
        return r1-m
    else:
        return r1
    
def mon_inv_transform(a,r,m_inv,m):
    # print("input",hex(a),hex(m_inv),hex(m))
    MultRes = a%r
    x = (m_inv * MultRes)%r
    xM = x*m
    r1 = (a + xM)//r 
    # print("proc",hex(MultRes),hex(x),hex(xM),hex(r1))
    if r1 >= m : 
          return r1-m
    elif r1 < 0:
          return r1+m
    else:
          return r1

def modInverse(A, M):
    for X in range(1, M):
        if (((A % M) * (X % M)) % M == 1):
            return X
    return -1

def main():
	w = 7607
	r = 2**13
	m = 7681
	a = 123
	if a < 0:
		a = m+a 
	r_inv = modInverse(r,m)
	m_inv = (-modInverse(m,r))%r
	# print(m_inv)
	wm = mont_transform(w,r,m)
	res = a*wm
	print(res)
	res_inv = monPro_Direct(res,1,r_inv,m)
	res_inv_slice = mon_inv_transform(res,r,m_inv,m)
	print((a*w)%m,res_inv,res_inv_slice)

	# testvector = [-3,-2,-1,0,1,2,3,m-1,m-2,m-3,m//2,m//2+123,m//2+17,2*m,-m+1,2**15+1]
	# wrong_case = []
	# wrong = 0
	# for a in testvector:
	# 	res = a*wm
	# 	res_inv_slice = mon_inv_transform(res,r,m_inv,m)
	# 	if res_inv_slice != (a*w)%m:
	# 		wrong += 1 
	# 		wrong_case.append(a)

	# print(wrong,wrong_case)
     
if __name__ == "__main__":
    main()