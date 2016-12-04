function [pvals, masks, cpvals, cmasks, errfiles] = mergepvalmask(pvaldir, maskdir,varargin)
%MERGEPVALMASK merges mask files and pvalfiles.
%
%    mergepvalmask(pvaldir, maskdir)  % Default pval.mat matlab form
%    mergepvalmask(pvaldir, maskdir, 'p_value.txt') % Ascii by '.txt'.
%
%    MERGEPVALMASK assumes that pvaldir and maskdir have the same structure.  
%
%    ex)
%       maksdir/exp_1
%       pvaldir/exp_1
%
%       Use  BATCHCOPYFILES
%       maksdir/sub/exp_1
%       pvaldir/exp_1

%    See Also: FTEST, MYFSTAT, BATCHCOPYFILES

%   $ Hyunwoo J. Kim $  $ 2016/08/05 14:05:14 (CDT) $

    pexpdirs = dir(fullfile(pvaldir, 'exp*'));
    mexpdirs = dir(fullfile(maskdir, 'exp*'));

    istxt = false;
    pvalfname = 'pval.mat';
    if nargin == 3
        pvalfname = varargin{1};
        [~,~,ext] = fileparts(pvalfname);
        istxt = strcmp('.txt',ext);
    end
    if length(pexpdirs) ~= length(mexpdirs)
        fprintf('There are missing directories.\n');
        fprintf('[%d]: %s \n',length(pexpdirs), pvaldir);
        fprintf('[%d]: %s \n',length(mexpdirs), maskdir);
    end

    %% Read, convert and write permutation test results
    cpvals = cell(length(pexpdirs),1);
    cmasks = cell(length(pexpdirs),1);
    errors  = false(length(pexpdirs),1);

    for i =1:length(pexpdirs)
        i
        try
            if ~istxt
                tmp = load(fullfile(pvaldir, pexpdirs(i).name,pvalfname));
                cpvals{i} = tmp.pvals;
            else
                tmp = load(fullfile(pvaldir, pexpdirs(i).name,pvalfname),'-ascii'); % Text file.
                cpvals{i} = tmp;
            end
            mask = load(fullfile(maskdir, mexpdirs(i).name,'mask_job_arma.mat'),'-ascii');
            cmasks{i} = mask;
        catch err
            disp(err)
            errors(i) = true;
            continue;
        end
    end
    pvals = cell2mat(cpvals(~errors));
    masks = cell2mat(cmasks(~errors));
    errfiles = pexpdirs(errors);
    errratio = sum(errors)/length(errors);
    
end

