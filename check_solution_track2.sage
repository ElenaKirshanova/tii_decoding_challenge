import os
#import sys
import json


load("McElieceKeyGen.sage")

all_challenges = []
with open('key_rec_instances', 'r') as f:
    for line in f:
        all_challenges.append(json.loads(line))

McEliece22 = {"n": 32, "k": 22, "t": 2, "m": 5, "bitcomplexity": 22.0}
McEliece39 = {"n": 28, "k": 18, "t": 2, "m": 5, "bitcomplexity": 39.0}
all_toy_clallenges = [McEliece22, McEliece39]


def find_correct_instance(bitcomplexity):
    for instance in all_challenges:
        if int(round(instance['bitcomplexity']))==bitcomplexity: return instance
    for instance in all_toy_clallenges:
        if int(round(instance['bitcomplexity']))==bitcomplexity: return instance
    raise ValueError("instance with bitcomplexity = ", bitcomplexity, 'is not found')

def read_H_f_from_file(path, filename, n, k):
    H = matrix(GF(2), n-k, n)
    flist = []
    i = 0
    with open(path+filename, 'r') as f:
        for line in f:
            if i<n-k:
                line = line.strip('[').strip(']\n')
                H[i] = vector([GF(2)(el) for el in line.split(' ')])
            else:
                line = line.strip('[').strip(']\n')
                flist = [GF(2)(el) for el in line.split(', ')]
            i+=1

    return H, flist

def read_L_g_from_file(filename, ff):
    with open(filename, 'r') as f:
        i = 0
        for line in f:
            if i == 0:
                line = line.strip('[').strip(']\n')
                glist = [ff(el) for el in line.split(', ')]
            elif i==1:
                line = line.strip('[').strip(']\n')
                L = vector([ff(el) for el in line.split(', ')])
            else:
                raise ValueError('inconsistend data in file', filename)
            i+=1
    return L, glist



def check_key(sec, filename):

    instance = find_correct_instance(sec)
    n = instance['n']
    k = instance['k']
    t = instance['t']
    m = instance['m']

    path_pub = "public_keyRec/"
    filename_pub = 'pk_McEliece_'+str(int(round(instance['bitcomplexity'])))+'.txt'

    H, defining_poly_list = read_H_f_from_file(path_pub, filename_pub, n, k)

    GFx = PolynomialRing(GF(2), 'x')


    ff.<a>  = FiniteField(2**m, modulus = GFx(defining_poly_list))
    ffx     = PolynomialRing(ff, 'x')

    L, glist = read_L_g_from_file(filename, ff)
    g = ffx(glist)

    Hcandidate = gen_parity_full(L, g, m, n, GF(2), ff, echelonForm=True)

    if not H == Hcandidate:
        print('public H != Hcandidate from provided L and g')
        return 0

    return 1

if __name__ == '__main__':
    """
        Input: N filename
        N: security level
        filename: name of file that constans two lines:
                    coefficents of g (from low degree to high-defgree)
                    set of elements in L in variable a
        Requires existence of the public data in public_keyRec/pk_McEliece_*sec*.txt
    """
    if not os.path.isfile(sys.argv[2]): raise ValueError("file not found")
    print(check_key(int(sys.argv[1]), sys.argv[2]))
