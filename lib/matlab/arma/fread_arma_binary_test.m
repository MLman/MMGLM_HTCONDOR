function [errfiles, errmsgs, elapsedtime] =fread_arma_binary_test(rootdir, pattern, nrows, ncols)
%FREAD_ARMA_BINARY_TEST test fread_arma_binary.
%
%   This code uses an executable file which is dependent on Armadillo.
%
%   [errfiles, errmsgs, elapsedtime] =fread_arma_binary_test(rootdir, '', nrows, ncols)
%   [errfiles, errmsgs, elapsedtime] =fread_arma_binary_test(rootdir, 'exp*', nrows, ncols)
%
%   See Also: FREAD_ARMA_BINARY

%   $ Hyunwoo J. Kim $  $ 2015/08/10 20:15:53 (CDT) $

    % Find missing folders
    fdirs = dir(fullfile(rootdir,pattern));

    tic;
    
    errmsgs = cell(length(fdirs),1);
    errfiles = cell(length(fdirs),1);
    
    t1 = clock; 
    i = 1;
    expdir = fullfile(rootdir, fdirs(i).name);
    fErrMx = readresult(expdir); 
    mycmd = sprintf('/home/hyunwoo/Workspaces/matlab_mv/arma/armabin2asciifull %s/result.bin %s/armabin2ascii.txt', expdir, expdir);
    system(mycmd);
    aErrMx = load(fullfile(rootdir, fdirs(i).name,'armabin2ascii.txt'),'-ascii');
    mycmd = sprintf('rm %s/armabin2ascii.txt', expdir);
    system(mycmd);
    assert(sumabs(fErrMx - aErrMx) == 0, ...
        'Discrepancy between loaded matrices by matlab and arma.');
    assert(fErrMx(end) ~= 0, 'The last value is zero.');
    assert(sumabs(size(fErrMx) - [nrows, ncols])==0,'Dimension is not matched.');    
    t2 = clock;
    fprintf('DIR : %s\n',rootdir);
    fprintf('Expected time : %s \n', length(fdirs)*etime(t2,t1)/3600);
    
    t1 = clock; 
    parfor i =1:length(fdirs)
        try
            expdir = fullfile(rootdir, fdirs(i).name);
            fErrMx = readresult(expdir); 
            mycmd = sprintf('/home/hyunwoo/Workspaces/matlab_mv/arma/armabin2asciifull %s/result.bin %s/armabin2ascii.txt', expdir, expdir);
            system(mycmd);
            aErrMx = load(fullfile(rootdir, fdirs(i).name,'armabin2ascii.txt'),'-ascii');
            mycmd = sprintf('rm %s/armabin2ascii.txt', expdir);
            system(mycmd);
 
            assert(sumabs(fErrMx - aErrMx) == 0, ...
                'Discrepancy between loaded matrices by matlab and arma.');
            assert(fErrMx(end) ~= 0, 'The last value is zero.');
            assert(sumabs(size(fErrMx) - [nrows, ncols])==0,'Dimension is not matched.');
        catch err
            disp(err)
            fdirs(i).name
            errmsgs{i} = err;
            errfiles{i} = fdirs(i).name;
        end
    end
    t2 = clock;
    elapsedtime = etime(t2, t1);
end
