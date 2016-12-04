function [errfiles, worsefits, cpvals, fexpdirs, cmasks] = batchftestv4(fullmodel_dir, limitedmodel_dir, nparf, nparl, nsubj, fpvalpath, lpvalpath)
%BATCHFTEST calculates p-values for each pair of subdirectories which have permutation results.
% 
%   Special case of ftest with the missing top unpermuted result. 
%   Assume that the mask files are in the sub directories of FULLMODEL_DIR.
%   'mask_job_arma.mat'
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
%   NPARL : number of parameters (or #coveriates+1) of limited model.
%   NPARF : number of parameters (or #coveriates+1) of full model.
%   NSUBJ : number of subjects.A
%
%   Outputs
%   ERRFILES : error directories in FULLMODEL_DIR.
%   WORSEFITS : worse fit voxel ratio.
%   CPVALS : cells of pvals
%   FEXPDIRS : directory names of full models

%    See Also: FTEST, MYFSTAT, BATCHCOPYFILES, INTERSECT_DIRS

%   $Hyunwoo J. Kim$  $2014/10/25 22:18:53 (CDT) $

    fexpdirs = dir(fullfile(fullmodel_dir, 'exp*'));
    lexpdirs = dir(fullfile(limitedmodel_dir, 'exp*'));
    fErr_missing = load(fpvalpath);
    lErr_missing = load(lpvalpath);

    assert(sumabs(fErr_missing.mask - lErr_missing.mask) ==0, 'Differnt Mask Files.')
    mask_missing = fErr_missing.mask;
    fErrMx_missing = fErr_missing.datamx;
    lErrMx_missing = lErr_missing.datamx;

    if length(fexpdirs) ~= length(lexpdirs)
        fprintf('There are missing directories.\n');
        fprintf('[%d]: %s \n',length(fexpdirs), fullmodel_dir);
        fprintf('[%d]: %s \n',length(lexpdirs), limitedmodel_dir);
    end

    %% Read, convert and write permutation test results
    errfiles = cell(length(fexpdirs),1);
    worsefits = zeros(length(fexpdirs),1); %Worse fit of full model than limted model. (due to approximation error)
    nvox = zeros(length(fexpdirs),1);
    cpvals = cell(length(fexpdirs),1);
    cmasks = cell(length(fexpdirs),1);
%    t1 = clock;
    disp('Start')
    parfor i =1:length(fexpdirs)
 %       if mod(i,100)==1
 %           t2 = clock;
 %           fprintf('%s (%f) \n',mat2str(i/length(fexpdirs)), etime(t2,t1));
 %           t1 = clock;
 %       end
        try
            
            fErrMx = readresult(fullfile(fullmodel_dir, fexpdirs(i).name));
            lErrMx = readresult(fullfile(limitedmodel_dir, fexpdirs(i).name));
            mask = load(fullfile(fullmodel_dir, fexpdirs(i).name,'mask_job_arma.mat') ,'-ascii');
            [C, ia, ib ] =intersect(mask, mask_missing,'rows');
            fErrMx_part = fErrMx_missing(ib,:);
            lErrMx_part = lErrMx_missing(ib,:);
            fErrMx = [fErrMx_part fErrMx(ia,:)];
            lErrMx = [lErrMx_part lErrMx(ia,:)];
            cmasks{i} = mask(ia,:); 
            [pvals, check] = ubatchftest(lErrMx, fErrMx, nparl, nparf, nsubj); 
            cpvals{i} = pvals;
            worsefits(i) = check;
            nvox(i) = size(fErrMx,1) ;
            
       catch err
           disp(err)
           errfiles{i} = fexpdirs(i).name;
           continue;
       end

    end
    totalnvox = sum(nvox);
    worsefits = worsefits/totalnvox;
%   t2 = clock;
%	fprintf('%d folders (%f) \n',length(fexpdirs),etime(t2,t1));
end
function [pvals, check] = ubatchftest(limitedErrMx, fullErrMx, df_l, df_f, nsubj)
    fdistr = myfstat(limitedErrMx, fullErrMx, df_l, df_f, nsubj);
    check = sum(sum(fdistr < 0,2));
    pvals = pvalperm_fstat(fdistr(:,1) ,  fdistr);
end

function mx = readresult(path)
    ff = dir(fullfile(path,'result*'));
    if strcmp(ff.name(end-2:end),'bin')==1
        mx = fread_arma_binary(fullfile(path,'result.bin'));
    else
        mx = load(fullfile(path,'result.mat'),'-ascii');
    end
end
