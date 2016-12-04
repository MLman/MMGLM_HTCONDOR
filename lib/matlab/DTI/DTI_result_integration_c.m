%function DTI_result_integration_c(inputdir,outputpath)
% Result Directory
inputdir = '/home/hyunwoo/Workspaces/results_raw/GMVL_v2_model_3_sub';
outputpath = '/home/hyunwoo/Workspaces/results/GMVL_v2_model_3_sub.mat';
% rootdir is a root dirctory of result
%rootdir = '/Users/hwkim/workspace/totalresult';
%rootdir = '/home/hyunwoo/Workspaces/condor/exp_DTI_X1_res';
% targetdir
% targetdir = '/home/hyunwoo/Workspaces/condor/exp_odf_1_res_sub_summary';
rootdir = inputdir;

curdir = pwd;
addpath(curdir);
cd(rootdir);
expdirs = dir;

expdirs = fileswithpattern(expdirs, 'exp');

%% Estimate size
total_length = 0;
for i =1:length(expdirs)
    cd([rootdir,'/',expdirs(i).name])
    files = dir;
    files = files(3:end);
    tmp = load('mask_job_arma.mat','-ascii'); 
    if i == 1
        res = load('result.mat','-ascii');
        [~, nperm] =size(res);
    end
    total_length = total_length + length(tmp);
    cd(rootdir)
end
disp(['Data size estimated. ',mat2str(total_length)]);
%%
positions = zeros(total_length,3); 
E=zeros(total_length,nperm);

k = 1;
for i =1:length(expdirs)
    cd([rootdir,'/',expdirs(i).name])
    files = dir;
    files = files(3:end);
    tmp = [];
    tmp.results = load('results.mat','-ascii');
    tmp.pos = load('mask_job_arma.mat','-ascii'); 
    for ires = 1:size(tmp.results,1)
        positions(k,:) = tmp.pos(ires,:);
        E(k,:) = tmp.results(ires,:);
        k = k +1;
    end
    cd(rootdir)

end
cd(curdir);

disp('Result integrated.');
%% Calculate norm
save(outputpath)
fprintf('%s saved\n',outputpath);
