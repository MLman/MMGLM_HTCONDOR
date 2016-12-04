function  mxstack = exsubjsfromcarray(mxstack, ia)
%EXSUBJSFROMCARRAY extracts subjects from 3D matrix stacks in each cell.
%
%
%   cellfun(@(c)c(:,:,ia),mxstack,'UniformOutput',false)
%   This is done parallely.
%
%   See Also: CELLFUN

%   $ Hyunwoo J. Kim $  $ 2015/05/29 14:10:37 (CDT) $

    parfor i = 1:length(mxstack)
        amxstack = mxstack{i};
        mxstack{i} = amxstack(:,:,ia);
    end
end