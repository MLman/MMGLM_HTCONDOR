#include <iostream>
#include <armadillo>
using namespace arma;
using namespace std;

#include "spd_funcs.h"

void mmglm_spd_perm(mat& ErrMx, const mat& X, const cube& Y, const imat & idx_dti, unsigned ithvox){

	unsigned int ndata = X.n_cols;
	unsigned int nperms = idx_dti.n_rows;
	unsigned int niter = 100;

	mat p(3,3);
	karcher_mean_spd(p, Y, niter);
	mat sqrtp = zeros<mat>(3,3);
	mat invg = zeros<mat>(3,3);
	mat g = zeros<mat>(3,3);
	get_g_invg(g,invg,p);
	sqrtm(sqrtp, p);

	cube logY(3,3,ndata);
	logmap_pt2array_spd(logY, p, Y);

	mat Yv(6,ndata);
	cube S(3,3,ndata);

	embeddingR6_vecs(Yv, S, p, logY);
	cube logYvhat_perm(6,ndata,nperms);

	unsigned int iperm;
	mat Xc(X.n_rows, X.n_cols);
	mat L;
	mat logYv_hat(6,ndata);
	cube V_hat(3,3,ndata);


	for(iperm=0; iperm < nperms; iperm++){
		mxpermute(Xc, X, idx_dti, iperm);
		//    A \ B	  	solve(A,B)
		L = solve(Xc.t(),Yv.t());
		logYv_hat = L.t()*Xc;
		logYvhat_perm.slice(iperm) = logYv_hat;
	}

	// Check distance
    unsigned int idata;
    for(idata =0; idata <ndata;idata++){
    	dist_M_pt2array(ErrMx,p, sqrtp, g, invg, Y, logYvhat_perm, idata, ithvox);
    }
}

// X and Y are a set of column vectors
double mglm(const mat& X, const mat&Y){
    mat B = solve(X.t(),Y.t());
    mat Yhat = B.t()*X;
    return sum(sum(square(Y-Yhat)));
}

// Return p value
// Y is 3 x 3 x ndata
// Y should be a slice for only a voxel.
// th threshold for p_value
double mmglm_spd_perm_tan(const mat& X, const cube& Y, const imat & idx_dti
                         ,const double th){

	unsigned int ndata = X.n_cols;
	unsigned int nperms = idx_dti.n_rows;
	unsigned int niter = 100;

	mat p(3,3);
	karcher_mean_spd(p, Y, niter);
#ifdef DEBUG
    p.print("p"); // Debugging
#endif

	cube logY(3,3,ndata);
	logmap_pt2array_spd(logY, p, Y);

	mat Yv(6,ndata);

	embeddingR6_vecs(Yv, p, logY);
	cube logYvhat_perm(6,ndata,nperms);

	unsigned int iperm;
	mat Xc(X.n_rows, X.n_cols);
	mat L;
	mat logYv_hat(6,ndata);
	cube V_hat(3,3,ndata);
    int dimX = X.n_rows;

#ifdef DEBUG
    cout << "dim X :" << dimX << endl;
#endif
    // the number of improved case than random.
    int ncounts = 1; // itself
    double improvement_0=.0;
	for(iperm=0; iperm < nperms; iperm++){
		mxpermute(Xc, X, idx_dti, iperm);
#ifdef DEBUG
        cout << "iperm:" << iperm << endl;
		//    A \ B	  	solve(A,B)
        Xc.cols(0,5).print("Xc");
        Xc.rows(0,dimX-2).cols(0,5).print("Xc_dimX-2");
#endif
        if(iperm == 0){
            improvement_0 =  mglm(Xc.rows(0,dimX-2),Yv) - mglm(Xc, Yv);
#ifdef DEBUG
            cout << "After MGLM." << endl;
#endif
        }else if(improvement_0 < mglm(Xc.rows(0,dimX-2),Yv)-mglm(Xc, Yv)) {
                ncounts++;
        }

#ifdef DEBUG
        cout << "nperms:" << nperms << endl;
        cout << "iperms:" << iperm << endl;
        cout << "ncounts/nerpms:" << double(ncounts)/nperms << endl;
        cout << "pvalue=ncounts/iperpms:" << double(ncounts)/iperm << endl;
#endif
        // Early stop when pvalue is not promissing at significance level 0.05.
        if(double(ncounts)/nperms > th){
#ifdef DEBUG
            cout << "Early stop." << endl;
#endif
            return (double)ncounts/iperm;
        }
	}
    return (double)ncounts/nperms;
}

double mmglm_spd_perm_tan(const mat& X, const cube& Y, const imat & idx_dti){
    return mmglm_spd_perm_tan(X, Y, idx_dti, 0.05);
}



