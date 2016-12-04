function D = mydistmx(mx, metric)
%MYDISTMX calculates distance matrix D of a set of matrix MX, gievn a METRIC. 
%
%
%   See Also: DIST 

%   $ Hyunwoo J. Kim $  $ 2015/08/02 01:46:04 (CDT) $
    N = size(mx,3);
    D = zeros(N);
    for i = 1:N
        for j =(i+1):N
           D(i,j) = metric(mx(:,:,i),mx(:,:,j));
        end
    end
    D = D+D';
end
