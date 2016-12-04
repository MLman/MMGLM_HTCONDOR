function tout = jointables(table1, table2, oncol1, oncol2, varargin)
%JOINTABLE joins two tables. Inner join in SQL.
%
%   ONCOL1 and ONCOL2 are the columns used for identifying the same row.
%
%   tout = jointables(table1, table2, oncol1, oncol2)
%   tout = jointables(table1, table2, oncol1, oncol2, idxColCSV1)
%   tout = jointables(table1, table2, oncol1, oncol2, idxColCSV1, idxColCSV2)
%
%   See Also: MERGEMETADATA

%   $ Hyunwoo J. Kim $  $ 2015/05/26 17:47:14 (CDT) $

    % Intersection
    [~, ia, ib ] = intersect(table1(:,oncol1),table2(:,oncol2));
    
    if nargin >=5 && ~isempty(varargin{1})
        idxColCSV1 = varargin{1};
    else
        idxColCSV1 = 1:size(table1,2);
        idxColCSV1(oncol1) = [];
        idxColCSV1 = [oncol1, idxColCSV1]; % The Key column at the first.
    end
    if nargin >= 6 && ~isempty(varargin{2})
        idxColCSV2 = varargin{2};
    else
        idxColCSV2 = 1:size(table2,2);
        idxColCSV2(oncol2) = []; % No redundant key column.
    end
    
    tout = [table1(ia, idxColCSV1), table2(ib, idxColCSV2)];

end