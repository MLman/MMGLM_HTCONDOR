% Result Directory
addpath ../headers/
header_odf;

% rootdir is a root dirctory of result
%rootdir = '/home/hyunwoo/Workspaces/condor/exp_odf_4_res_gender_age';
projid = 'project38_res';
resdir = [rawdir,'/',projid];
% targetdir
%targetdir = '/home/hyunwoo/Workspaces/condor/exp_odf_1_res_sub_summary';

curdir = pwd;
cd(resdir);
expdirs = dir;
expdirs = expdirs(3:end);
suffix='.mat';
%% Estimate size
total_length = 0;
for i =1:length(expdirs)
    i
    cd([rootdir,'/',expdirs(i).name])
    files = dir;
    files = files(3:end);
    
    for ifile = 1:length(files)
        tmp = load(files(ifile).name);
        total_length = total_length + length(tmp.results);
    end
    cd(rootdir)

end

ndimV = numel(tmp.results{1}.V);
ndimP = numel(tmp.results{1}.p);
%%
roi_vox_idx = zeros(total_length,1); 
E=zeros(total_length,1);
gnorm=zeros(total_length,1);
V =zeros(ndimV,total_length);
P=zeros(ndimP,total_length);


k = 1;
for i =1:length(expdirs)
    i
    cd([rootdir,'/',expdirs(i).name])
    files = dir;
    files = files(3:end);
    
    for ifile = 1:length(files)
        tmp = load(files(ifile).name);
        
        for ires = 1:length(tmp.results)
            V(:,k) = reshape(tmp.results{ires}.V,[],1);
            P(:,k) = tmp.results{ires}.p;
            roi_vox_idx(k) = tmp.results{ires}.pos;
            E(k) = tmp.results{ires}.E;
            k = k +1;
        end
        
    end
    cd(rootdir)

end
cd(curdir);
clear tmp rootdir total_length k ires ifile i files expdirs curdir ans suffix
%normVgender = sqrt(sum(V(1:15,:).^2,1));
%normVage = sqrt(sum(V(16:30,:).^2,1));