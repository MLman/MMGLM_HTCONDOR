function Xs = scaling(X)
%SCALING converts X to Xs so that max(Xs')-min(Xs')= [ 1, ... 1].
%   X is a set of column vectors
%   Xs is a set of column vectors.

%   $ Hyunwoo J. Kim $  $ 2015/05/29 11:45:42 (CDT) $

    Xmin = min(X,[],2);
    Xmax = max(X,[],2);
    Xrange = Xmax - Xmin;
    Xrange = zero2one(Xrange);
    Xs = X./repmat(Xrange,1,size(X,2));
end