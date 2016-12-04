function [gvar, X_bar]= geodesic_var_spd_batch(X_bar, X)
%KARCHER_MEAN_SPD_BATCH
%
%   X bar is a 3x3xN array.
%   X is a column cell vector. [N, 1]
%   
%   See Also: KARCHER_MEAN_SPD_BATCH

%   $ Hyunwoo J. Kim $  $ 2015/10/05 23:48:59 (CDT) $

    if isempty(X_bar)
        X_bar = karcher_mean_spd_batch(X);
    end

    gvar = zeros(size(X));
    for j = 1:size(X,1)
        j
        Xj = X{j};
        gvar(j) = sum(dist2_M_pt2array_spd(X_bar(:,:,j),Xj));
    end
    gvar = gvar/size(X,3);
%    gvar = gvar/(size(X,3)-1);
end