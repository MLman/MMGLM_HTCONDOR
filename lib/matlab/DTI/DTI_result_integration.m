function DTI_result_integration(inputdir,outputpath)
% Result Directory

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
    
    for ifile = 1:length(files)
        tmp = load(files(ifile).name);
        total_length = total_length + length(tmp.results);
    end
    cd(rootdir)

end
disp('Data size estimated.');
%%
nV = size(tmp.results{1}.V,3);

%%
positions = zeros(total_length,3); 
E=zeros(total_length,1);
gnorm=zeros(total_length,1);
V =zeros(3,3,total_length,nV);
P=zeros(3,3,total_length);
normV = zeros(nV,total_length);

k = 1;
for i =1:length(expdirs)
    cd([rootdir,'/',expdirs(i).name])
    files = dir;
    files = files(3:end);
    
    for ifile = 1:length(files)
        tmp = load(files(ifile).name);
        
        for ires = 1:length(tmp.results)
            V(:,:,k,1:nV) = tmp.results{ires}.V;
            P(:,:,k) = tmp.results{ires}.p;
            positions(k,:) = tmp.results{ires}.pos;
            E(k) = tmp.results{ires}.E;
            gnorm(k) = tmp.results{ires}.gnorm;
            k = k +1;
        end
    end
    cd(rootdir)

end
cd(curdir);

disp('Result integrated.');
%% Calculate norm

for i = 1:total_length
    Ptmp = P(:,:,i);
    Vtmp = V(:,:,i,:);
    for iV = 1:nV
        normV(iV,i) = norm_TpM_spd(Ptmp,Vtmp(:,:,1,iV));
    end
end
disp('Norm of tangent vectors calculated.');
clear curdir expdirs files i ifile ires k rootdir tmp total_length i Ptmp Vtmp iV
save(outputpath)
fprintf('%s saved\n',outputpath);

