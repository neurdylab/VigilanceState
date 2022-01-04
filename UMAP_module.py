import umap

'''
This function depends on UMAP python toolbox
McInnes, Leland, and John Healy. 
UMAP: Uniform Manifold Approximation and Projection for Dimension Reduction. arXiv:1802.03426.
'''

def draw_umap(data, n_neighbors, n_components, min_dist=0.1, metric='correlation'):

    fit = umap.UMAP(
        n_neighbors=n_neighbors,
        min_dist=min_dist,
        n_components=n_components,
        metric=metric
    )
    u = fit.fit_transform(data)

    return u


'''
The following is an example to load matlab matrix in python: you need to use scipy.io.loadmat
        tmp = loadmat(X)       X is a matlab matrix
        tmp = tmp['name']      the name means the name of your matlab matrix
        
        
***Use following command to do UMAP-based dimensionality reduction
embedding = draw_umap(tmp, n_neighbors, n_components, min_dist=0.1, metric='correlation')

***Note: (1). n_neighbors and n_components should be based on intrinsic dimensionality reduction algorithm
         (2). min_dist and metric can be customized.

use scipy.io.savemat to save the low-dimensional embeddings for all scans (resting and task)

'''