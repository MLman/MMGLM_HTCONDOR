function [srcexpdirs, dstexpdirs, errfiles, errratio] = mergeerrmx(srcdir, dstdir, mergeddir)
%MERGEERRMX merges results (Error Matrix) from permutation tests based on experiment names.
%
%   This function assumes that directories are absolute paths. 
%
%   MERGEDMX = [ DSTMX SRCMX ]
%
%   See Also: MERGEPVALMASK, BATCHFTEST, MYFSTAT, BATCHCOPYFILES

%   $ Hyunwoo J. Kim $  $ 2015/08/06 02:49:35 (CDT) $
    
    srcexpdirs = dir(fullfile(srcdir, 'exp*'));
    dstexpdirs = dir(fullfile(dstdir, 'exp*'));


    if length(srcexpdirs) ~= length(dstexpdirs)
        fprintf('There are missing directories.\n');
        fprintf('[%d]: %s \n',length(srcexpdirs), srcdir);
        fprintf('[%d]: %s \n',length(dstexpdirs), dstdir);
    end

    %% Read, convert and write permutation test results
    errors  = false(length(srcexpdirs),1);
    if exist(mergeddir) == 0
        system(sprintf('mkdir %s',mergeddir));
    end
    parfor i =1:length(srcexpdirs)
        %i
        try
            dErrMx = readresult(fullfile(dstdir, srcexpdirs(i).name));
            sErrMx = readresult(fullfile(srcdir, srcexpdirs(i).name));
            mErrMx = [dErrMx sErrMx];
            [nrows, ncols ] =size(mErrMx);
%            fprintf('[%d] (%d, %d)\n',i, nrows, ncols);
            targetdir = fullfile(mergeddir, srcexpdirs(i).name);
            if ~exist(targetdir)
                system(sprintf('mkdir %s',targetdir));
 %               sprintf('mkdir %s\n',targetdir)
            end
            
            % Error check part
            fwrite_arma_binary(fullfile(targetdir, 'result.bin'), mErrMx);
            rErrMx = fread_arma_binary(fullfile(targetdir, 'result.bin'));
            assert(sumabs(mErrMx - rErrMx) == 0, ...
                'Discrepancy between matrices by fread_arma_binary and fwrite_arma_binary.');
            
            mycmd = sprintf('/home/hyunwoo/Workspaces/matlab_mv/arma/armabin2asciifull %s/result.bin %s/armabin2ascii.txt', targetdir, targetdir);
            system(mycmd);
            aErrMx = load(fullfile(targetdir,'armabin2ascii.txt'),'-ascii');
            mycmd = sprintf('rm %s/armabin2ascii.txt', targetdir);
            system(mycmd);
            assert(sumabs(mErrMx - aErrMx) == 0, ...
                'Discrepancy between matrices by fwrite_arma_binary and armabin2asciifull.');
        catch err
            if exist(fullfile(dstdir, srcexpdirs(i).name))==7 && exist(fullfile(srcdir, srcexpdirs(i).name))==7
                disp(err)
            end
%            disp(err)
            errors(i) = true;
            continue;
        end
    end
    errfiles = srcexpdirs(errors);
    errratio = sum(errors)/length(errors);
    
end

