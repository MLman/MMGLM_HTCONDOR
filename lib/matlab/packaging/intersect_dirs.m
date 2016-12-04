function [C, ia, ib ] = intersect_dirs(Adirs, Bdirs)
%INTERSECT_DIRS returns the intersection of two directory lists.
%   C is the intersection (table).
%   IA is the indices to get C with the entries form Adirs.  
%   IB is the indices to get C with the entries from Bdirs.  
%
%    See Also: FTEST, BATCHFTEST, MYFSTAT, BATCHCOPYFILES, BATCHFTESTV2, DIRS2NAMES

%   $ Hyunwoo J. Kim $  $ 2015/08/10 16:00:04 (CDT) $
%   $ Hyunwoo J. Kim $  $ 2015/07/26 22:25:19 (CDT) $

    Anames = dirs2names(Adirs);
    Bnames = dirs2names(Bdirs);
    Anames_tab = table(Anames(:));
    Bnames_tab = table(Bnames(:));
    [C, ia, ib] = intersect(Anames_tab, Bnames_tab);
end
