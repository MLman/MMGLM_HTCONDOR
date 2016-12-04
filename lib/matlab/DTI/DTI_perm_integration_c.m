function [proj, mask, errfiles, nerr] = DTI_perm_integration_c(inputdir)
%% script_for_ODF_result_integration. Permutation Test.
rootdir = inputdir;
curdir = pwd;
cd(rootdir);
expdirs = dir('exp*');
%expdirs = expdirs(3:end);
%% Estimate size
total_length = 0;
nerr = 0;
disp('Size Estimation Started.')
i =1;
cd([rootdir,'/',expdirs(i).name])
try
    mask_job = load('mask_job_arma.mat','-ascii');
    ErrMx = load('result.mat','-ascii');
    assert(size(mask_job,1)==size(ErrMx,1));
catch err
    disp(err)
end
total_length = total_length + size(ErrMx,1);
cd(rootdir)

total_length = length(expdirs)*size(ErrMx,1);

disp('Data size estimated.');
ntimes = size(ErrMx,2);
TotalErrMx = zeros(total_length,ntimes);
mask = zeros(total_length,3);

%% Reading Results
k = 1;
nerr = 0;
errfiles = [];
for i = 1:length(expdirs)
    cd([rootdir,'/',expdirs(i).name])
    if mod(i,100)==1
        fprintf('%s\n',mat2str(i/length(expdirs)));
    end
    try
        mask_job = load('mask_job_arma.mat','-ascii');
        ErrMx = load('result.mat','-ascii');
        assert(size(mask_job,1)==size(ErrMx,1));
    catch err
        errfiles{nerr +1} = expdirs(i).name;
        nerr = nerr + 1;
        continue;
    end
    nvox = size(mask_job,1);
    idx = k:(k+nvox-1);

    mask(idx,:) = mask_job;
    TotalErrMx(idx,:) = ErrMx;
    k = k +nvox;

    cd(rootdir)
end
cd(curdir);
fprintf('%d errors.\n',nerr)
proj.TotalErrMx = TotalErrMx(1:k-1,:);
proj.mask = mask(1:k-1,:);
