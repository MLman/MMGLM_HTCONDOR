function csvdata = csvstr2num(csvdata, varargin)
%CSVSTR2NUM converts string columns in CSVDATA.data into numbers
%
%   CSVDATA is a structure and CSVDATA.DATA is the cells of string data.
%   ICOLS is the indices of columns to convert.
%
%   See also CSVREAD, IND2SUB, MYCSVREAD, MYCSVREAD

%   $ Hyunwoo J. Kim $  $ 2015/05/26 13:54:58 (CDT) $

    [nrows, ncols] = size(csvdata.data);
    if nargin == 1
        icols = 1:ncols;
    else
        icols = varargin{1};
    end
    for i= 1:nrows
        for j = icols
            strin = csvdata.data{i,j};
            numout = str2num(strin);
            assert( isempty(strin) || ~isempty(numout), ...
                sprintf('Non-number field : {%d, %d} =  %s',i,j, strin));
            csvdata.data{i,j} = numout;
        end
    end
end
