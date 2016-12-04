function totalelapsedtime = DTI_condordata_gen_c_GMVL_amyloid(Xin, szjob, datapath, metadata, outputdir)
%DTI_CONDORDATA_GEN_C_GMVL_AMYLOID generats data for condor or parallel computation.
%    
%   DTI_CONDORDATA_GEN_C_GMVL__AMYLOID(Xin, szjob, datapath, metadata, outputdir)
%   
%   Index of meta data checked from the meta data header.
%
%   See also CSVREAD, IND2SUB, DTI_CONDORDATA_GEN_C_SUB,
%   DTI_CONDORDATA_GEN_C_GMVL

%   Hyunwoo J. Kim
%   $Revision: 0.1 $  $Date: 2014/10/22 16:42:00 $

% Navigate data directory

%Xin = 'X_GMVL1';
%szjob = 2;
%szsub = 3;

starttime=clock;
curdir = pwd;


%% Meta data
load(metadata);
%%
metaheader=strtrim(lower(csvdata.colnames))
idxAGE1 = find(strcmp(metaheader,'visit_age_1'))
idxTTAU_AB42 = find(strcmp(metaheader,lower('ttau/ab42')))
idxPTAU_AB42 = find(strcmp(metaheader,lower('ptau/ab42')))

age1 = cell2mat(csvdata.data(:,idxAGE1)); %Numeric.
ttau_ab42 = cell2mat(csvdata.data(:, idxTTAU_AB42)); %Numeric.
ptau_ab42 = cell2mat(csvdata.data(:, idxPTAU_AB42)); %Numeric.

X_GMVL_TAU1 = [age1];
X_GMVL_TAU2 = [age1, ttau_ab42 ];
X_GMVL_TAU3 = [age1, ptau_ab42 ];
%%

%% Filter the dataset.

%% Parameter
eval(sprintf('X = %s;',Xin));
X=X';

subj_ids = csvdata.data(:,2);
Xc =centering(X);
Xs = scaling(Xc);
%Xs = [ones(size(DeltaAge)), Xs];
nsubjects = length(subj_ids);

%% DTI data load
load(datapath);
disp('DTI data loaded')

%% Read Size of Data
fprintf('%d voxels are masked.\n',size(mask,1));
%szjob = 10;
idx = partition(size(mask,1),szjob);
prefix = 'exp_';

if isdir(outputdir)
    cd(outputdir);
else
    mkdir(outputdir);
    cd(outputdir);
end

for i = 1:size(idx,1)
    foldername= strcat([prefix,mat2str(idx(i,1))]);
    exp_name = foldername;
    mkdir(foldername);
    indices = idx(i,1):idx(i,2);
    mask_job = mask(idx(i,1):idx(i,2),:);
    mxstack_job = mxstack(idx(i,1):idx(i,2),1);
    Ys = mxstack_job2mx(mxstack_job);
    save(strcat(['./',foldername,'/','Ys_arma.mat']),'Ys','-ascii');
    save(strcat(['./',foldername,'/','mask_job_arma.mat']),'mask_job', '-ascii');
end
foldername = 'shared';
mkdir(foldername);
save(strcat(['./',foldername,'/','Xs_arma.mat']),'Xs', '-ascii');
system(['cp /home/hyunwoo/Workspaces/matlab_mv/legr_dti ','./',foldername]);
system(['cp /home/hyunwoo/Workspaces/matlab_mv/idx_dti_arma.mat ','./',foldername]);
cd(curdir);
fprintf('check data.\n');
fprintf('cd %s \n',outputdir);
disp('done')
endtime = clock;
totalelapsedtime = etime(endtime,starttime);
