function [errfiles, worsefits, cpvals, fexpdirs] = batchftestv2(fullmodel_dir, limitedmodel_dir, nparf, nparl, nsubj)
%BATCHFTEST calculates p-values for each pair of subdirectories which have permutation results.
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
%   NSUBJ : number of subjects.
%
%   Outputs
%   ERRFILES : error directories in FULLMODEL_DIR.
%   WORSEFITS : worse fit voxel ratio.

%    See Also: FTEST, MYFSTAT, BATCHCOPYFILES

%   $Hyunwoo J. Kim$  $2014/10/25 22:18:53 (CDT) $

    fexpdirs = dir(fullfile(fullmodel_dir, 'exp*'));
    lexpdirs = dir(fullfile(limitedmodel_dir, 'exp*'));

%     if exist(outputdir) ~= 1
%         system(['mkdir -p "',outputdir,'"']);
%     end

    if length(fexpdirs) ~= length(lexpdirs)
        fprintf('There are missing directories.\n');
        fprintf('[%d]: %s \n',length(fexpdirs), fullmodel_dir);
        fprintf('[%d]: %s \n',length(lexpdirs), limitedmodel_dir);
    end

    %% Read, convert and write permutation test results
    k = 1;

    errfiles = cell(length(fexpdirs),1);
    worsefits = zeros(length(fexpdirs),1); %Worse fit of full model than limted model.
    nvox = zeros(length(fexpdirs),1);
    cpvals = cell(length(fexpdirs),1);
    t1 = clock;
    disp('Start')
    parfor i =1:length(fexpdirs)
%         if mod(i,100)==1
%             t2 = clock;
%             fprintf('%s (%f) \n',mat2str(i/length(fexpdirs)), etime(t2,t1));
%             t1 = clock;
%         end
        try
            
%             if isbin==true
%                 fErrMx = fread_arma_binary(fullfile(fullmodel_dir, fexpdirs(i).name,'result.bin'));
%                 lErrMx = fread_arma_binary(fullfile(limitedmodel_dir, fexpdirs(i).name,'result.bin'));
%             else
%                 fErrMx = load(fullfile(fullmodel_dir, fexpdirs(i).name,'result.mat'),'-ascii');
%                 lErrMx = load(fullfile(limitedmodel_dir, fexpdirs(i).name,'result.mat'),'-ascii');
%             end
            fErrMx = readresult(fullfile(fullmodel_dir, fexpdirs(i).name));
            lErrMx = readresult(fullfile(limitedmodel_dir, fexpdirs(i).name));
            
            %system(['mkdir ',fullfile(outputdir,fexpdirs(i).name)]); 
            [pvals, check] = ubatchftest(lErrMx, fErrMx, nparl, nparf, nsubj); 
            %save(fullfile(outputdir,fexpdirs(i).name,'pval.mat'),'pvals');
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
    t2 = clock;
	fprintf('%d folders (%f) \n',length(fexpdirs),etime(t2,t1));
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
