function cnames = dirs2names(dirs)
%DIRS2NAMES converts DIR results (structure) to cell of names.
%
%   CNAMES = dirs2names(dir('./exp*'))
%
%   See Also: INTERSECT_DIRS, SETDIFF_DIRS

%   $ Hyunwoo J. Kim $  $ 2015/08/10 15:45:26 (CDT) $
    dirs_cell = struct2cell(dirs);
    cnames = dirs_cell(1,:);
    
end