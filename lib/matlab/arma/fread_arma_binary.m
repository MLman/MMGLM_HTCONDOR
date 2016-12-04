function mx = fread_arma_binary(fpath)
%FREAD_ARMA_BINARY reads an Armadillo binary double matrix file at FPATH.
%
%   matlab FREAD and FGETS cause a problem to read data.
%   Please check with SHOW_ARMA_MX binary code to verify your reading.
%   
%   See Also: FREAD, FGETS

%   $ Hyunwoo J. Kim $  $ 2015/08/08 01:35:32 (CDT) $
%   $ Hyunwoo J. Kim $  $ 2014/11/05 20:40:53 (CST) $
    fin = fopen(fpath,'r');
    % Read header
    type = fgets(fin);
    if ~strcmp(strtrim(type), 'ARMA_MAT_BIN_FN008')
        error(sprintf('Not Implemented for %s.\n',type)); 
    end
    mxsizestr = fgets(fin);
    
    tmp = strsplit(mxsizestr,' ');
    deblanked_tmp = deblank(tmp);
    mxsize = str2double(deblanked_tmp);
    offset = length(deblanked_tmp{2}) - length(tmp{2}); % wrong fgets with \n
    offset = offset + 1;
    if offset <= 0
        fseek(fin, offset, 0);
    end

    % Read data
    mx = fread(fin, mxsize, 'double');
%    mx = fread(fin, [mxsizestr(1), mxsizestr(2)],  'double')
    fclose(fin);
%end
