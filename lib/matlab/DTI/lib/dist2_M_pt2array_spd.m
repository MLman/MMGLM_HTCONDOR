function d = dist2_M_pt2array_spd(x,Y)
%DIST_M_PT2ARRAY_SPD calculates distance from x to y_i in Y(:,:,i).
%     For speed up code, reduced redundant calculation for distance
%     calculation.
%
%     d is a row vector
%     x is a 3x3 SPD matrix.
%     Y is an array of 3x3 SPD matrices. size(Y) == [3, 3, nmx]
%     distance is SQUARED disatnce
%
%   See Also: LOGMAP_PT2ARRAY_SPD

%   $ Hyunwoo J. Kim $  $ 2015/10/05 22:59:57 (CDT) $

    % Common part
    [U D ] = eig(x);
    invg = U*diag(1./sqrt(diag(D)))*U';
    
    d = zeros(1,size(Y,3));
    
    % For each y
    for i =1:size(Y,3)
        [U D ] = eig(invg*Y(:,:,i)*invg);
        d(i) = sum(log(diag(D)).^2);
%        d(i) = sqrt(sum(diag(log(D)).^2));
    end

end