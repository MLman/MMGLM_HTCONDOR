function ascii2mat(inputdir,outputdir)
%ASCII2MAT converts ascii files to matlab mat file.
%

%   See also DTI_CONDORDATA_GEN, DTI_CONDORDATA_GEN_C

%   $Hyunwoo J. Kim$  $2014/10/25 02:33:20 (CDT) $

expdirs = dir(fullfile(inputdir,'exp*'));



%% Estimate size
total_length = 0;
system(['mkdir ',outputdir]);
disp('Size Estimation Started.');

t1 = clock;
mask_job = load(fullfile(inputdir, expdirs(i).name,'mask_job_arma.mat'),'-ascii');
ErrMx = load(fullfile(inputdir, expdirs(i).name,'result.mat'),'-ascii');
assert(size(mask_job,1)==size(ErrMx,1));
total_length = size(ErrMx,1)*length(expdirs);
t2 = clock;
estimated_etime = etime(t2,t1)*length(expdirs);
fprintf('Estimated_etime : %f', estimated_etime);
disp('Data size estimated.');

%% Read, convert and write permutation test results
k = 1;
nerr = 0;
errfiles = [];
for i =1:length(expdirs)
    if mod(i,100)==1
        fprintf('%s\n',mat2str(i/length(expdirs)));
    end
    try
        mask_job = load(fullfile(inputdir, expdirs(i).name,'mask_job_arma.mat'),'-ascii');
        ErrMx = load(fullfile(inputdir, expdirs(i).name,'result.mat'),'-ascii');

        system(['mkdir ',fullfile(outputdir,expdirs(i).name)]); 
        save(fullfile(outputdir,expdirs(i).name,'result.mat'),'mask_job','ErrMx');
        assert(size(mask_job,1)==size(ErrMx,1));
    catch err
        disp(err)
        errfiles{nerr +1} = expdirs(i).name;
        nerr = nerr + 1;
        continue;
    end
end

