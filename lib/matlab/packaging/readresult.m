function mx = readresult(path)
%READRESULT reads results based on their extensions.
%
%    result.bin : Armadillo binary
%    result.mat : ASCII

%    See Also: BATCHFTEST, MYFSTAT, BATCHCOPYFILES, INTERSECT_DIRS

%   $ Hyunwoo J. Kim $  $ 2015/08/06 02:57:48 (CDT) $
    try
        ff = dir(fullfile(path,'result*'));
        if strcmp(ff.name(end-2:end),'bin')==1
            mx = fread_arma_binary(fullfile(path,'result.bin'));
        else
            mx = load(fullfile(path,'result.mat'),'-ascii');
        end
    catch
        error(sprintf('Failed to read %s\n', path));
    end
end
