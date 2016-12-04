function [ids, idx]= partition(N, k)
%PARTITION returns a set of IDs and indices.
%
%

%   See also DTI_CONDORDATA_GEN, DTI_CONDORDATA_GEN_C

%   Hyunwoo J. Kim
%   $Revision: 0.1 $  $Date: 2014/07/17 21:19:00 $

nfolds = ceil(N/k);
ids = zeros(nfolds,2);

for i = 1:(nfolds-1)
    ids(i,1) = k*(i-1)+1;
    ids(i,2) = k*i;
end

ids(end,1) = k*(nfolds-1)+1;
ids(end,2) = N;

if nargout == 2
    idx = 1:nfolds;
end
