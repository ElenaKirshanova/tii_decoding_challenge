import sys, os
import json

def testAndMakeDir(path):
  if not os.path.isdir(path):
      os.makedirs(path)

load("McElieceKeyGen.sage")

McEliece22 = {"n": 32, "k": 22, "t": 2, "m": 5, "bitcomplexity": 22.0}
McEliece39 = {"n": 28, "k": 18, "t": 2, "m": 5, "bitcomplexity": 39.0}
all_toy_clallenges = [McEliece22, McEliece39]


all_challenges = []
with open('key_rec_instances', 'r') as f:
    for line in f:
        all_challenges.append(json.loads(line))


for param_set in all_challenges:  #change to all_toy_clallenges to generates toy instances 
    p = 2               # Binary Goppa code
    m = param_set['m']  # Goppa field Extension degree
    F = GF(p)           # F_2


    defining_poly = generate_binary_irred(param_set['m'])
    ff.<a>        = FiniteField(p**m, modulus = defining_poly) # F_2^m

    H, L, g = gen_instance(param_set,ff,F)

    filename_pub = 'pk_McEliece_'+str(int(round(param_set['bitcomplexity'])))+'.txt'
    filename_sk = 'sk_McEliece_'+str(int(round(param_set['bitcomplexity'])))+'.txt'

    path_pub = "public_keyRec/"
    testAndMakeDir(path_pub)
    original_stdout = sys.stdout
    with open(path_pub+filename_pub, 'w') as f:
        sys.stdout = f
        print(str(H))
        print(str(list(defining_poly)))

    path_priv = "priv_keyRec/"
    testAndMakeDir(path_priv)
    with open(path_priv+filename_sk, 'w') as f_:
        sys.stdout = f_
        print(str(list(g)))
        print(str(L))

    sys.stdout = original_stdout
