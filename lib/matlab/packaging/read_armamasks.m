function [masks, cmasks, mexpdirs, errfiles, errratio] = read_armamasks(maskdir)
%READ_ARMAMASK reads armamask files from exp_* directories in MASKDIR.
%
%    READ_ARMAMASK assumes that 'mask_job_arma.mat' is an ASCII file.  
%
%    ex)
%       maksdir/exp_1
%

%    See Also: FTEST, MYFSTAT, BATCHCOPYFILES, READ_ARMAFILES

%   $ Hyunwoo J. Kim $  $ 2015/08/02 22:51:55 (CDT) $
%   $ Hyunwoo J. Kim $  $ 2014/10/26 22:59:33 (CDT) $

%   TODO : refactoring with READ_ARMAFILES.

    mexpdirs = dir(fullfile(maskdir, 'exp*'));

    %% Read, convert and write permutation test results
    cmasks = cell(length(mexpdirs),1);
    errors  = false(length(mexpdirs),1);

    parfor i =1:length(mexpdirs)
        try
            mask = load(fullfile(maskdir, mexpdirs(i).name,'mask_job_arma.mat'),'-ascii');
            cmasks{i} = mask;
        catch err
            disp(err)
            errors(i) = true;
            continue;
        end
    end
    masks = cell2mat(cmasks(~errors));
    errfiles = mexpdirs(errors);
    errratio = sum(errors)/length(errors);
    
end

