function mx = mxstack_job2mx(mxstack)
%MXSTACK_JOB2MX coverts matrix stack to a 2D matrix for legr_core.cpp.
%
%
%   See Also: DTICOFF2MX, SPD2VEC

%   $ Hyunwoo J. Kim $  $ 2014/11/18 17:12:07 (CST) $

el = [ 1 1; 1 2; 1 3; 2 2; 2 3; 3 3];
ndim =  6; %length(el)
nvoxels = length(mxstack);
nrows = nvoxels*ndim;
ncols = size(mxstack{1},3);
mx = zeros(nrows,ncols);

for ivox =1:nvoxels
    start_idx = ndim*(ivox-1)+1;
    end_idx = start_idx+ndim-1;
    mx(start_idx:end_idx,:) = cube2mat(mxstack{ivox},el);
end
