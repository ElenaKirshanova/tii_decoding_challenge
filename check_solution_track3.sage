
import sys

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

McEliece80 = {'sec': 80, 'n': 1488, 'k': 1092, 't': 36, 'm': 11}
McEliece81 = {'sec': 81, 'n': 1490, 'k': 1072, 't': 38, 'm': 11}
McEliece82 = {'sec': 82, 'n': 1506, 'k': 1077, 't': 39, 'm': 11}
McEliece83 = {'sec': 83, 'n': 1523, 'k': 1083, 't': 40, 'm': 11}
McEliece84 = {'sec': 84, 'n': 1540, 'k': 1089, 't': 41, 'm': 11}
McEliece85 = {'sec': 85, 'n': 1548, 'k': 1075, 't': 43, 'm': 11}

all_challenges = [McEliece22, McEliece23, McEliece24, McEliece25, McEliece26, McEliece27,
              McEliece28, McEliece29, McEliece30, McEliece31, McEliece32, McEliece33,
              McEliece70, McEliece71, McEliece72, McEliece73, McEliece74,
              McEliece80, McEliece81, McEliece82, McEliece83, McEliece84, McEliece85]

def find_correct_instance(sec):
    for instance in all_challenges:
        if instance['sec']==sec: return instance
    raise ValueError("instance with n = ", n, 'is not found')

def read_H_s_from_file(path, filename, n, k):
    H = matrix(GF(2), n-k, n)
    s = vector(GF(2), n-k)
    i = 0
    with open(path+filename, 'r') as f:
        for line in f:
            if i<n-k:
                line = line.strip('[').strip(']\n')
                H[i] = vector([GF(2)(el) for el in line.split(' ')])
            elif i==n-k:
                line = line.strip('(').strip(')\n')
                s = vector([GF(2)(el) for el in line.split(', ')])
            else: break
            i+=1

    return H, s



def check_error(e_str, sec):
    e = vector([GF(2)(e_str[i]) for i in range(len(e_str)) ])


    instance = find_correct_instance(sec)
    n = instance['n']
    k = instance['k']
    t = instance['t']

    if not len(e) == n:
        print('Wrong erro length')
        return 0

    if not sum([int(e[i]) for i in range(n)])==t:
        print('Wrong erro weight')
        return 0

    path_pub = "public/"
    filename_pub = 'pk_McEliece_'+str(instance['sec'])+'.txt'

    H, s = read_H_s_from_file(path_pub, filename_pub, n, k)

    if not H*e == s:
        print('H*e==s is not satisfied')
        return 0

    return 1

if __name__ == '__main__':
    """
        Run  sage check_solution_track3.sage bit_sec e
        Example: 22 0000000000000000000000000000000010000010000000000000000000000000000000000000000000000100000000
        Requires existence of the public data in public/pk_McEliece_*sec*.txt
    """

    print(check_error(sys.argv[2], int(sys.argv[1])))
