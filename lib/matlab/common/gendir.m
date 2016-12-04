% Generate directories
load('shareddata.mat')
curdir = pwd;
%% Get indices
output_dir = '/Users/hwkim/Dropbox/Workspace/Manifold/src/condor_run';
szNII = size(nii_master.vol);
szNII = szNII(1:3);
[ix iy iz] = meshgrid(1:szNII(1),1:szNII(2),1:szNII(3));
pos = [ix(:) iy(:) iz(:)];

%% Divide jobs
N = length(pos);
k = 50; %nvoxels per each job
idx = partition(N,k);
idx = idx(1:3,:);
prefix = 'exp_';
cd(output_dir);
for i = 1:size(idx,1)
    foldername= strcat([prefix,mat2str(idx(i,1))]);
    exp_name = foldername;
    mkdir(foldername);
    mask = pos(idx(i,1):idx(i,2),:);
    mxstack_tmp = mxstack(idx(i,1):idx(i,2));
    save(strcat(['./',foldername,'/','data.mat']),'mask','exp_name',...
        'Xc','mxstack_tmp');
end
cd(curdir);