# ===== Import Modules =====

import numpy as np
import pandas as pd
import uproot as up
import matplotlib.pyplot as plt
import seaborn as sns
import time
from numba import njit, prange

# ===== /Import Modules/ =====

@njit
def pi( n=100 ):

    arcCount = 0
    for i in prange(n):
        point = np.array([np.random.rand(),np.random.rand()])
        dist = np.linalg.norm(point)
        if dist <= 1:
            arcCount += 1

    return 4*(arcCount/n)

# ===== Define Functions =====

# ===== /Define Functions/ =====

# ===== Main Program =====

if __name__ == '__main__':
    # Let's test out Numba

    ns = [ 10**i for i in range(9) ]

    for n in ns:
        start = time.time()
        pie = pi(n)
        end = time.time()
        print( "For {} points - Pi = {}. In {}s".format(n,pie,end-start))
    

# ===== /Main Program/ =====
