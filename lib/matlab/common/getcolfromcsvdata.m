function X = getcolfromcsvdata(columnname, csvdata)
%GETCOLFROMCSVDATA exstracts a column from csvdata.
%
%       An example of the field of CSVDATA
%       csvdata.colnames: {1x9 cell}
%       csvdata.data: {181x9 cell}
%       csvdata.fname: '20140918_piprpdt_n211_1.csv'
       
%   See Also: MYSTRFINDI

%   $ Hyunwoo J. Kim $  $ 2015/10/07 20:59:38 (CDT) $
    idxftrs = mystrfindi(columnname , csvdata.colnames);
    if idxftrs == -1
        X = [];
    else
        cX = csvdata.data(:,idxftrs);
        if isstr(cX{1})
            X=cX;
        else
            X = cell2mat(cX);
        end
    end
end
