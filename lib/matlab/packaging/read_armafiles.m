function [datamx, cdata, expdirs, errfiles, errratio] = read_armafiles(rootdir, fprefix)
%READ_ARMAFILES reads all armadillo output files in the subdirectories of ROODIR. 
%ALL armadillo output files should have fprefix. If the extension is  BIN, it is a binary file. 
%If the extension is MAT, then it is an ASCII file.
%
%   read_armafiles(resultroot, 'result')
%
%   See Also: READ_ARMAMASKS, FTEST, MYFSTAT, BATCHCOPYFILES, BATCHFTEST

%   $ Hyunwoo J. Kim $  $ 2015/08/02 22:49:27 (CDT) $

    expdirs = dir(fullfile(rootdir, 'exp*'));
    %% Read, convert and write permutation test results
    cdata = cell(length(expdirs),1);
    errors  = false(length(expdirs),1);

    parfor i =1:length(expdirs)
        try
            data = readdata(fullfile(rootdir, expdirs(i).name),fprefix);
            cdata{i} = data;
        catch err
            disp(err)
            errors(i) = true;
            continue;
        end
    end
    datamx = cell2mat(cdata(~errors));
    errfiles = expdirs(errors);
    errratio = sum(errors)/length(errors);
end

function mx = readdata(path,fprefix)
    ff = dir(fullfile(path,sprintf('%s*',fprefix)));
    ext = ff.name(end-2:end);
    if strcmp(ext,'bin')==1
        mx = fread_arma_binary(fullfile(path,ff.name));
    else
        mx = load(fullfile(path,ff.name),'-ascii');
    end
end
