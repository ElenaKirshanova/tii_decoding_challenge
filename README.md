# tii_crypto_challenges
This repository contains the scripts accompanying the McEliece Challenges from TII

# Contributers

* Elena Kirshanova
* Andre Esser

# Requirements

* [SageMath 9.3+](https://www.sagemath.org/)

# Description of files
Short description of the content:
* McElieceKeyGen.sage contains the main function to generate McEliece secret/public keys and a random syndrome
* McEliece_challenge_track2.sage generates McEliece public/secret for McEliece parameters given in key_rec_instances
* McEliece_challenge_track3.sage generates McEliece keys and a random syndrome for toy McEliece parameters, parameters for secuirty level 70-75, 80-90
* key_rec_instances contains list of dictionaries with parameters for Track 2 (McEliece key recovery)
* params.sage contains a script that find concrete Goppa code parameters for Track 2 (McEliece key recovery) and Track 3 (McElice message recovery)
* check_solution_track2.sage checks solution for Track 2
* check_solution_track3.sage checks solution for Track 3

These are the solutions to McEliece challenges Track 2.
* public_keyRec/ contains files 'pk_McEliece_'+bit_security+'.txt' with:
  * public matrix H in the systematic form (the identity matrix is also stored),
  * coefficients of unitary irreducbile polynomial f s.t. F_{2^m} = F_2[x]/f(x).
This is public data for McEliece challenges Track 2.

* public/ contains files 'pk_McEliece_'+bit_security+'.txt' with:
  * public matrix H in the systematic form (the identity matrix is also stored)
  * syndrome vector
  * coefficients of unitary irreducbile polynomial f s.t. F_{2^m} = F_2[x]/f(x).
  * parameter n
  * parameter k
  * parameter t
  * parameter m
This is public data for McEliece challenges Track 3.


# How to use

To generate all (non-toy) challenges for Track 2 run
```
sage McEliece_challenge_track2.sage
```
This will re-generate all the files with non-toy security levels in folders priv_keyRec/ and public_keyRec/. The generation might take a few minutes.
See the script *McEliece_challenge_track2.sage* to know how to generate only toy-challenges.

To check a solution, create a file that contains
* coefficient-vector of the secret Goppa polynomial g in variable 'a' (from low degree to high degree) of your solution
* a vector that contains L elements of the field F_{2^m} in variable 'a'.
Then execute the script *check_solution_track2.sage* providing the sec. level of the solved challenge as the first argument and the file name as the second.
For example, run
```
sage check_solution_track2.sage 22 priv_keyRec/sk_McEliece_22.txt
```
If the provided solution is correct, the script returns 1. Otherwise it returns 0.

To generate all challenges with security levels 70--74 for Track 3 run
```
sage McEliece_challenge_track3.sage
```
This will re-generate all the files with security levels 70--74 in folders priv/ and public/.
See the script *McEliece_challenge_track3.sage* to know how to generate the other challenges.

To check a solution execute the script *check_solution_track3.sage* providing the sec. level of the solved challenge as the first argument and the error vector as a binary string with no space. For example,
```
sage check_solution_track3.sage 22 0000000000000000010000000000000000000000100000100000000000000000000000000000000000000000000000
```
If the provided solution is correct, the script returns 1. Otherwise it returns 0.
