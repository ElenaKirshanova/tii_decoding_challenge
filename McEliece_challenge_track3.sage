import sys, os

def testAndMakeDir(path):
  if not os.path.isdir(path):
      os.makedirs(path)

load("McElieceKeyGen.sage")


McEliece22 = {'sec': 22, 'n': 94, 'k': 73, 't': 3, 'm': 7}
McEliece23 = {'sec': 23, 'n': 89, 'k': 61, 't': 4, 'm': 7}
McEliece24 = {'sec': 24, 'n': 102, 'k': 74, 't': 4, 'm': 7}
McEliece25 = {'sec': 25, 'n': 117, 'k': 89, 't': 4, 'm': 7}
McEliece26 = {'sec': 26, 'n': 115, 'k': 80, 't': 5, 'm': 7}
McEliece27 = {'sec': 27, 'n': 139, 'k': 99, 't': 5, 'm': 8}
McEliece28 = {'sec': 28, 'n': 142, 'k': 94, 't': 6, 'm': 8}
McEliece29 = {'sec': 29, 'n': 156, 'k': 108, 't': 6, 'm': 8}
McEliece30 = {'sec': 30, 'n': 172, 'k': 124, 't': 6, 'm': 8}
McEliece31 = {'sec': 31, 'n': 190, 'k': 142, 't': 6, 'm': 8}
McEliece32 = {'sec': 32, 'n': 191, 'k': 135, 't': 7, 'm': 8}
McEliece33 = {'sec': 33, 'n': 231, 'k': 183, 't': 6, 'm': 8}

McEliece70 = {'sec': 70, 'n': 1322, 'k': 1014, 't': 28, 'm': 11}
McEliece71 = {'sec': 71, 'n': 1332, 'k': 1013, 't': 29, 'm': 11}
McEliece72 = {'sec': 72, 'n': 1343, 'k': 1013, 't': 30, 'm': 11}
McEliece73 = {'sec': 73, 'n': 1401, 'k': 1082, 't': 29, 'm': 11}
McEliece74 = {'sec': 74, 'n': 1388, 'k': 1047, 't': 31, 'm': 11}

McEliece80 = {'sec': 80, 'n': 1488, 'k': 1092, 't': 36, 'm': 11} #0.733870967741935
McEliece81 = {'sec': 81, 'n': 1490, 'k': 1072, 't': 38, 'm': 11} #0.719463087248322
McEliece82 = {'sec': 82, 'n': 1506, 'k': 1077, 't': 39, 'm': 11} #0.715139442231076
McEliece83 = {'sec': 83, 'n': 1523, 'k': 1083, 't': 40, 'm': 11} #0.711096520026264
McEliece84 = {'sec': 84, 'n': 1540, 'k': 1089, 't': 41, 'm': 11} #0.707142857142857
McEliece85 = {'sec': 85, 'n': 1686, 'k': 1290, 't': 36, 'm': 11} #0.765124555160142
McEliece86 = {'sec': 86, 'n': 1749, 'k': 1364, 't': 35, 'm': 11} #0.779874213836478
McEliece87 = {'sec': 87, 'n': 1732, 'k': 1325, 't': 37, 'm': 11} #0.765011547344111
McEliece88 = {'sec': 88, 'n': 1745, 'k': 1327, 't': 38, 'm': 11} #0.760458452722063
McEliece89 = {'sec': 89, 'n': 1754, 'k': 1325, 't': 39, 'm': 11} #0.755416191562144
McEliece90 = {'sec': 90, 'n': 1788, 'k': 1359, 't': 39, 'm': 11} #0.760067114093960

all_McEliece_toy = [McEliece22, McEliece23, McEliece24, McEliece25, McEliece26,
                    McEliece27, McEliece28, McEliece29, McEliece30, McEliece31,
                    McEliece32]

all_McEliece70 = [McEliece70, McEliece71, McEliece72, McEliece73, McEliece74]
all_McEliece80 = [McEliece80, McEliece81, McEliece82, McEliece83, McEliece84,
                  McEliece85, McEliece86, McEliece87, McEliece88, McEliece89,
                  McEliece90]

for param_set in all_McEliece70:  #change to all_McEliece_toy or to all_McEliece80 to generate challenges with other sec. levels
    p = 2               # Binary Goppa code
    m = param_set['m']  # Goppa field Extension degree
    F = GF(p)           # F_2


    defining_poly = generate_binary_irred(param_set['m'])
    ff.<a>        = FiniteField(p**m, modulus = defining_poly) # F_2^m

    H, L, g = gen_instance(param_set,ff,F)
    s, e = gen_syndrome(param_set, F, H)

    filename_pub = 'pk_McEliece_'+str(param_set['sec'])+'.txt'
    filename_er = 'error_McEliece_'+str(param_set['sec'])+'.txt'

    path_pub = "public/"
    testAndMakeDir(path_pub)
    original_stdout = sys.stdout
    with open(path_pub+filename_pub, 'w') as f:
        sys.stdout = f
        print(str(H))
        print(str(s))
        print(str(list(defining_poly)))

    path_priv = "priv/"
    testAndMakeDir(path_priv)
    with open(path_priv+filename_er, 'w') as f_:
        sys.stdout = f_
        print(str(e))

    sys.stdout = original_stdout
