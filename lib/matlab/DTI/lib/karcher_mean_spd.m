function xbar = karcher_mean_spd(X, W, niter, initidx)
%KARCHER_MEAN calculates weighted means on d-sphere.
%   W is weights.
%   X is a set of column vectors.
%   NITER is the max iteration.
%   Lower precision and speed up.
%
%   KARCHER_MEAN_SPD(X)
%   KARCHER_MEAN_SPD(X, W)
%   KARCHER_MEAN_SPD(X, W, NITER)
%   KARCHER_MEAN_SPD(X, W, NITER, INITIDX)
%   KARCHER_MEAN_SPD(X, W, NITER, INITIDX, PRECISION)
%
%   Default values
%   W = even
%   NITER = 50
%   INITIDX = 1
%   PRECISION = 1e-18
%
%   See Also: MAIN_SCRIPT_FOR_GMVL_2015_SANITY_CHECK, SMOOTHINGSUB1

%   $ Hyunwoo J. Kim $  $ 2015/03/08 17:09:11 (CDT) $

    if nargin <= 4
        precision = 1e-18;
    end
    if nargin <=3
        initidx = 1;
    end
    if nargin <= 2
        niter = 50;
    end

    if nargin <= 1
        W = [];
    end

    xbar = X(:,:,initidx);

    if isempty(W)
        for iter = 1:niter
            phi = mean(logmap_pt2array_spd(xbar,X),3);
            xbar = expmap_spd(xbar, phi);
            if norm(phi) < precision
                break
            end
        end
    else
        W = W/norm(W,1);
        for iter = 1:niter
            tmp = logmap_pt2array_spd(xbar,X);
            wtmp = zeros(size(tmp));
            for i = 1:size(tmp,3)
                wtmp(:,:,i) = W(i)*tmp(:,:,i);
            end
            phi = sum(wtmp,3);
            xbar = expmap_spd(xbar, phi);
            if norm(phi) < precision
                break
            end
        end
    end
end
