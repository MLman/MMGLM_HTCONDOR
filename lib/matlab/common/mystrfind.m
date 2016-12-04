function idx = mystrfind(queries, strset, varargin)
%MYSTRFIND searches QUERIES from STRSET.
%
%   IDX position of each QUERY in STRSET. If it is absent, then -1.
%   QUERIES is cell array of strings.
%
%   mystrfind(queries, strset)
%   mystrfind(queries, strset, 'nocase)
%
%   See Also: STRFIND, FINDSTR

%   $ Hyunwoo J. Kim $  $ 2015/03/17 14:27:49 (CDT) $
    if isstr(queries)
        tmp = queries;
        queries = cell(1);
        queries{1} = tmp;
    end
    assert(sum(size(queries)==1)>=1 && length(size(queries))==2, 'QUERIES is not a cell array');
    idx = zeros(size(queries));
    for i  =1:length(queries)
        tmp = find(strcmp(queries{i},strset));
        if ~isempty(tmp)
            idx(i) = tmp;
        else
            idx(i) = -1;
        end
    end
end