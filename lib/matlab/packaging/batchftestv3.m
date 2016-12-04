function [errfiles, cpvals, fexpdirs, totalnvox] = batchftestv3(fullmodel_dir)
%BATCHFTESTV3 calculates p-values for each pair of subdirectories which have permutation results.
%
%   The directory structures must be same. This will detect the type of
%   result files by their extensions. 
%   'result.bin' is armadillo binary.
%   'result.mat' is armadillo ascii.
%
%
%   BATCHFTEST(FULLMODEL_DIR, LIMITEDMODEL_DIR, OUTPUTDIR, NPARF, NPARL, NSUBJ)
%
%   FULLMODEL_DIR :  fullmodel_dir/exp_1 ...
%   LIMITEDMODEL_DIR : limitedmodel_dir/exp_1 ...
%   OUTPUTDIR : outputdir/exp_1
%   OUTPUTDIR may or may not exist. 
%
%   Outputs
%   ERRFILES : error directories in FULLMODEL_DIR.
%   WORSEFITS : worse fit voxel ratio.

%    See Also: FTEST, MYFSTAT, BATCHCOPYFILES, BATCHFTESTV2, BATCHFTEST

%   $ Hyunwoo J. Kim $  $ 2014/11/12 10:53:22 (CST) $

    fexpdirs = dir(fullfile(fullmodel_dir, 'exp*'));

    %% Read, convert and write permutation test results
    errfiles = cell(length(fexpdirs),1);
    nvox = zeros(length(fexpdirs),1);
    cpvals = cell(length(fexpdirs),1);
    t1 = clock;
    disp('Start')
    parfor i =1:length(fexpdirs)
        try
            
            fErrMx = readresult(fullfile(fullmodel_dir, fexpdirs(i).name));
            pvals = sum(fErrMx(:,1)*ones(1,size(fErrMx,2)) > fErrMx,2)/size(fErrMx,2); 
            cpvals{i} = pvals;
            nvox(i) = size(fErrMx,1) ;
        catch err
            disp(err)
            errfiles{i} = fexpdirs(i).name;
            continue;
        end
    end
    totalnvox = sum(nvox);
    t2 = clock;
	fprintf('%d folders (%f) \n',length(fexpdirs),etime(t2,t1));
end

function mx = readresult(path)
    ff = dir(fullfile(path,'result*'));
    if strcmp(ff.name(end-2:end),'bin')==1
        mx = fread_arma_binary(fullfile(path,'result.bin'));
    else
        mx = load(fullfile(path,'result.mat'),'-ascii');
    end
end
