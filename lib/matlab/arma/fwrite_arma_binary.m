function count = fwrite_arma_binary(fpath, mx)
%FWRITE_ARMA_BINARY writes ab Armadillo binary double matrix file at FPATH.
%
%
%   MX is a 2D data matrix to write.
%   FPATH  is a path to write.
%   COUNT is the number of elements of A that fwrite successfully writes to the file.
%
%   See Also: FREAD_ARMA_BINARY, FREAD, FGETS

%   $ Hyunwoo J. Kim $  $ 2015/08/05 18:06:55 (CDT) $



    fout = fopen(fpath,'w');
    % Read header
    fprintf(fout, '%s\n','ARMA_MAT_BIN_FN008');
    [nrows, ncols ] = size(mx);
    fprintf(fout, '%d %d\n', nrows, ncols);
    
    % Read data
    count = fwrite(fout, mx, 'double');
    fclose(fout);
end