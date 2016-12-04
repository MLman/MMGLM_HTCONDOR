function v = spd2vec(X)
%SPD2VEC converts matrix X to coefficient vector v.
%
%
%   See Also: DTICOEF2MX

%   $ Hyunwoo J. Kim $  $ 2016/08/16 21:41:31 (CDT) $

 
%    v = [Dxx, Dyx, Dyy, Dzx, Dzy, Dzz]' 
%
%
%    See Also: dticoef2mx
%     Dxx = X(1,1);
%     Dyx = X(2,1);
%     Dyy = X(2,2);
%     Dzx = X(3,1);
%     Dzy = X(3,2);
%     Dzz = X(3,3);
%     v = [Dxx, Dyx, Dyy, Dzx, Dzy, Dzz]';
%  For converting 3D matrix to 2D matrix by vectorizing the matrix at each
%  slice.
%
%  >> C = permute(A,[1 3 2]);
%  >> C = reshape(C,[],size(A,2),1)

    idx = triu(true(size(X)));
    v = X(idx);
end
