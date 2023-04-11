def constructL(ff, n):
	"""
		constructs a set of size of the finite field ff

		:param ff: extension field F_{2^m}
		:param n: code length
	"""
	L = set()
	while len(L)<n:
		while True:
			tmp = ff.random_element()
			if not tmp in L:
				L.add(tmp)
				break
	return list(L)

def gen_parity(L, g):
	"""
		generates the parity check matrix of GoppaCode(L, g)
		over the extension field

		:param L: set of Goppa points
		:param g: irreducbile polynomial
	"""
	n = len(L)
	glist = list(g)
	t  = g.degree()
	G = matrix(parent(glist[0]),t)
	for i in range(t):
		for k in range(i+1):
			G[i,k] = glist[t-k]
	V = matrix.vandermonde(L).transpose()

	V1 = V[0:t]
	Gdiag = matrix.diagonal([1/g(L[i]) for i in range(n)])
	#print(G)
	return V1*Gdiag

def gen_parity_full(L, g, m, n, base_field, ff, echelonForm=True):
	"""
		generates the parity check matrix of GoppaCode(L, g)
		over the base (binary) field

		:param L: set of Goppa points
		:param g: irreducbile polynomial
		:param m: extension degree ff
		:param n: code length
		:param base_field: F_2
		:param ff: extension field F_{2^m}
	"""
	Hbar = gen_parity(L,g)
	V, from_V, to_V = ff.vector_space(base_field, map=True)
	H = matrix(base_field, m*Hbar.nrows(), n)
	for i in range(Hbar.nrows()):
		for j in range(n):
			tmp_vec = to_V(Hbar[i,j])
			for k in range(m):
				H[m*i+k, j] = tmp_vec[k]
	if echelonForm: H = H.echelon_form()
	return H

def gen_irreducible(t,ff):
	"""
		Generates an irreducible polynomial over ff of degree t by randomly sampling a unitary polynomial
		and checking if it's irreducible. Aborts after >2*t trials

		:param t: degree
		:param ff: F_{2^m}
	"""
	Ntrials = max(3*t, 100)
	ffx   = PolynomialRing(ff, 'x')
	i = 0
	while i<Ntrials:
		glist = [ ff.random_element() for _ in range(t)]+[1]
		for i  in range(t):
			if not glist[i]**2 == glist[i]: break
		if i == t:
			print("Warning: generated a binary g!")
			continue

		g = ffx(glist)
		if(g.is_irreducible()):
			return g
		i+=1
	raise ValueError("run out of trials to generate irreducible g")

def generate_binary_irred(m):
	"""
		Generates a random binary irreducbile polynomial that defines F_{2^m}
		:param m: degree of the polynomial
	"""
	return PolynomialRing(GF(2), 'x').irreducible_element(m)



def gen_instance(param_set,ff,base_field):
	"""
		Generates McEliece public key H and priviate key (L,g)
		:param param_set: dictionary of McEliece parameters
		:params ff: field F_{2^n}
		:params base_field: F_2
	"""

	n = param_set['n']
	k = param_set['k']
	t = param_set['t']
	m = param_set['m']

	g = gen_irreducible(t,ff)  #alternative: g = PolynomialRing(ff, 'x').irreducible_element(t)

	identity = identity_matrix(n-k)

	L = constructL(ff, n)
	shuffle(L)
	Ntrials = 100
	i = 0
	while i<Ntrials:
		H = gen_parity_full(L, g, m, n, base_field, ff)
		if H.matrix_from_columns(range(0,n-k)) == identity:
			break
		shuffle(L)
		i+=1
	if i == Ntrials: raise ValueError('run out of trials to generate the identity in H')
	return H, L, g

def gen_syndrome(param_set, base_field, H):
	"""
		generates a syndome of a random error of weight t
		:param param_set: dictionary of McEliece parameters
		:params base_field: F_2
		:params H: public parity-check matrix

	"""
	n = param_set['n']
	t = param_set['t']

	e = [0]*n
	while sum(e) < t:
		e[randrange(n)] = 1

	return H*vector(base_field,e), e
