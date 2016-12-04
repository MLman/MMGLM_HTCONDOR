function Ybars = karcher_mean_spd_batch(mxstack)
%KARCHER_MEAN_SPD_BATCH
%
%
%   See Also:

%   $ Hyunwoo J. Kim $  $ 2015/05/28 15:44:45 (CDT) $

    nvoxels = length(mxstack);
    Ybars = zeros(3,3,nvoxels);
    parfor i = 1:nvoxels
        Ybars(:,:,i) = karcher_mean_spd(mxstack{i}, [], 50); % Riemannian CCA
    end
end