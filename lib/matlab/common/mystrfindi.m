function idx = mystrfindi(queries, strset, varargin)
%MYSTRFINDI searches QUERIES from STRSET case insensitively.
%
%   IDX position of each QUERY in STRSET. If it is absent, then -1.
%   QUERIES is cell array of strings.
%
%   mystrfind(queries, strset)
%   mystrfind(queries, strset, 'nocase)
%
%   See Also: GETCOLFROMCSVDATA, MYSTRFIND, STRFIND, FINDSTR

%   $ Hyunwoo J. Kim $  $ 2015/03/17 14:27:49 (CDT) $
        
    queries = lower(queries);
    strset = lower(strset);
    idx = mystrfind(queries, strset);
end