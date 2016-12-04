function totalelapsedtime = DTI_condordata_gen_c_GMVL(Xin, szjob, datapath, metadata, outputdir)
%DTI_CONDORDATA_GEN_C_GMVL generats data for condor or parallel computation.
%    
%   DTI_CONDORDATA_GEN_C_GMVL(Xin, szjob, datapath, metadata, outputdir)
%   
%   Index of meta data checked from the meta data header.
%
%   See also CSVREAD, IND2SUB, DTI_CONDORDATA_GEN_C_SUB

%   Hyunwoo J. Kim
%   $Revision: 0.1 $  $Date: 2014/10/22 16:42:00 $

% Navigate data directory

%Xin = 'X_GMVL1';
%szjob = 2;
%szsub = 3;

starttime=clock;
curdir = pwd;

%datapath = '/home/hyunwoo/Workspaces/data/GMVLongitudinal/GMVL_CauchyTensorDataV1_242subj_test.mat';
%metadata = '/home/hyunwoo/Workspaces/data/GMVLongitudinal/Longitudinal_20140707_meta.mat';
%outputdir ='/home/hyunwoo/Workspaces/data/GMVL_test1';
%% DTI data load
load(datapath);
disp('DTI data loaded')

%% Meta data
load(metadata);
%%
metaheader=lower(csvdata.colnames)
idxGENDER = find(strcmp(metaheader,'gender'))
idxAGE1 = find(strcmp(metaheader,'visit_age_1'))
idxAGE2 = find(strcmp(metaheader,'visit_age_2'))
idxFH = find(strcmp(metaheader,'fh'))
idxAPOE1 = find(strcmp(metaheader,'apoe1'))
idxAPOE2 = find(strcmp(metaheader,'apoe2'))
DeltaAge = find(strcmp(metaheader,'v1_v2_interval'))


gender = cell2mat(csvdata.data(:,idxGENDER)); %Numeric. (1=male, 2= female)
age1 = cell2mat(csvdata.data(:,idxAGE1)); %Numeric.
age2 = cell2mat(csvdata.data(:,idxAGE2)); %Numeric.
FH = cell2mat(csvdata.data(:,idxFH)); %Numeric. FH (1=Maternal, 2=Paternal, 3=Both, 4=Neither)
FH_M = FH==1 | FH==3;
FH_P = FH==2 | FH==3;
FH_B = FH==1 | FH==2 | FH==3; % Binary variable for family history.
APOE1 = cell2mat(csvdata.data(:,idxAPOE1)); %Numeric. APOE1 (2,3,4), 
APOE2 = cell2mat(csvdata.data(:,idxAPOE2)); %Numeric. APOE2 (2,3,4), 
APOE = APOE1 == 4 & APOE2 ==4; % IF  APOE1 < 4 and APOE2 < 4, APOE4status=neg.  IF  APOE1 = 4 or APOE2 = 4, APOE4status=pos.

DeltaAge = cell2mat(csvdata.data(:,DeltaAge)); %Numeric. V1_V2_interval, 
%% Models.
%Ours
X_GMVL1 = [DeltaAge age1 gender FH_B]; %RSS2. Family history exists or not.
X_GMVL1_nested = [DeltaAge age1 gender]; %RSS1. Controlled model.
%1) Y=1+DeltaAge+Gender
%2) Y=1+DeltaAge+Gender+APOE(+ or -)
%3) Y=1+DeltaAge+Gender+FH(+ or -)
%4) Y=1+Gender
X_GMVL_v2_model1 = [DeltaAge, gender];
X_GMVL_v2_model2 = [DeltaAge, gender, APOE];
X_GMVL_v2_model3 = [DeltaAge, gender, FH_B];
X_GMVL_v2_model4 = [gender];

X_GMVL_v2_model5 = [DeltaAge, gender, age1];
X_GMVL_v2_model6 = [DeltaAge, gender, APOE, age1];
X_GMVL_v2_model7 = [DeltaAge, gender, FH_B, age1];
X_GMVL_v2_model8 = [gender, age1];
X_GMVL_v2_model9 = [gender, APOE, age1];
X_GMVL_v2_model10 = [gender, FH_B, age1];
X_GMVL_v2_model11 = [age1];

%% New GMVL 2015
X_GMVL_2015_model1 = [gender, age1];
X_GMVL_2015_model2 = [gender];
X_GMVL_2015_model3 = [age1];
X_GMVL_2015_model4 = [gender, age1, APOE];

%% Parameter
eval(sprintf('X = %s;',Xin));
X=X';

%subj_ids = csvdata.data(:,2); % is in data set already

% Subj Ids varification.
enum8 = cellfun(@(str)str(1:8),csvdata.data(:,2),'UniformOutput',false);
assert(length(subj_ids) == length(enum8));
disp('All meta are avilable for all brain images.');
subj_ids8 = cellfun(@(str)str(1:8), subj_ids,'UniformOutput',false);

% Id match check
for i=1:length(subj_ids8)
    assert(strcmp(subj_ids8{i},enum8{i}));
end
disp('All ids match.');

Xc =centering(X);
Xs = scaling(Xc);
%Xs = [ones(size(DeltaAge)), Xs];
nsubjects = length(subj_ids);

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
