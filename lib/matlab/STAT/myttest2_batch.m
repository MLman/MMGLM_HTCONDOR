function P = myttest2_batch(mx, G)
%MYTTEST2_BATCH calculates ttest with group information G and data MX.
%
%   G = {-1, 1}^N
%   MX in R^{NxM}, where M is the number of features.
%   P (in R^{M})
%
%   See Also: TTEST2

%   $ Hyunwoo J. Kim $  $ 2015/10/15 22:15:49 (CDT) $
    
    [N, M] = size(mx);
    assert(length(G) == N);
    P = zeros(M,1);
    grp1 = mx(G==1,:);
    grp2 = mx(G==-1,:);
    parfor i = 1:M
        [~,p] = ttest2(grp1(:,i), grp2(:,i));
        P(i) = p;
    end
end