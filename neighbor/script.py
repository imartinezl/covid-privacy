# %%

import numpy as np
from scipy import spatial
x, y = np.mgrid[0:4, 0:4]
points = np.c_[x.ravel(), y.ravel()]
tree = spatial.cKDTree(points)
tree.query_ball_point([2, 0], 1)

tree.query_ball_point(points, 1)
# %%

tree.query_ball_tree(points, 1)