function cout = ncharstr(cin, n)
%NCHARSTR cut strings to have n chracters
%
%   CIN is an array of cells.
%
%   See Also:  INTERSECT

%   $ Hyunwoo J. Kim $  $ 2015/03/10 15:06:54 (CDT) $

    cout = cell(size(cin));
    for i =1:length(cin)
        tmp = cin{i};
        if length(tmp) > n 
            fprintf('%s => %s\n',tmp,tmp(1:n));
            cout{i} = tmp(1:n);
        else
            cout{i} = tmp;
        end
    end
end
