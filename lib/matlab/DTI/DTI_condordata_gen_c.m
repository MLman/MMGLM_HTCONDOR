function totalelapsedtime = DTI_condordata_gen_c(Xin, szjob, datapath, metadata, outputdir)
%DTI_CONDORDATA_GEN_C generats data for condor or parallel computation.
%    
%   DTI_CONDORDATA_GEN_C(Xin, szjob, datapath, metadata, outputdir)
%
%   See also CSVREAD, IND2SUB

%   Hyunwoo J. Kim
%   $Revision: 0.1 $  $Date: 2014/10/2 16:27:00 $

% Navigate data directory
starttime=clock;
curdir = pwd;

%datapath = '/home/hyunwoo/Workspaces/data/DTI_mat_cvpr2013/DTI_masked_data.mat';
%metadata = '/home/hyunwoo/Workspaces/data/BarbDataForHyunwoo/NonImagingInformation/ICTR_Master.mat';
%outputdir ='/home/hyunwoo/Workspaces/data/DTI_X21_condor_cvpr2013';
%% DTI data load
load(datapath);
disp('DTI data loaded')

%% Meta data
load(metadata);
gender=cell2mat(csvdata.data(:,3));%Numeric. 1=Female, 2=Male.
age=cell2mat(csvdata.data(:,4));%Numeric.
FH=cell2mat(csvdata.data(:,5));%Numeric. 1=Family history positive, 0=Family history negative.
FH_var=zeros(size(FH,1),2);
FH_var(find(FH==0),1)=1;
FH_var(find(FH==1),2)=1;
APOE=cell2mat(csvdata.data(:,8));%Numeric. 1=APOE4 positive, 0=APOE4 negative.
APOE_var=zeros(size(APOE,1),2);
APOE_var(find(APOE==0),1)=1;
APOE_var(find(APOE==1),2)=1;

%% Models.
%Statistic inference
%Fletcher

%Ours
X1=[APOE age gender FH];%RSS2. %APOE group differences controlling for age gender and FH.
X11=[age gender FH];%RSS1.

X2=X1;
X21=[APOE age gender];%FH group differences controlling for age, gender and APOE.

X3=[APOE age gender repmat(age,1,2).*APOE_var FH];
X31=[APOE age gender FH];

X4=[APOE age gender repmat(age,1,2).*FH_var FH];
X41=[APOE age gender FH];

X5=[APOE age gender FH APOE_var.*FH_var];
X51=[APOE age gender FH];

X6 = APOE;
X7 = [APOE gender];
X8 = [APOE gender age];
X9 = [gender age];
X10 = [APOE age];


%% Parameter
eval(sprintf('X = %s;',Xin));
X=X';

%subj_ids = csvdata.data(:,2);

% Subj Ids varification.
enum8 = cellfun(@(str)str(1:8),csvdata.data(:,2),'UniformOutput',false);
assert(length(subj_ids) == length(idx));
disp('All meta are avilable for all brain images.');
subj_ids8 = cellfun(@(str)str(1:8), subj_ids,'UniformOutput',false);

% Id match check
for i=1:length(subj_ids8)
    assert(strcmp(subj_ids8{i},enum8{i})
end
disp('All ids match');

Xc =centering(X);
Xs = scaling(Xc);
suffix = '_combined.nii.gz';
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
cd(curdir);
fprintf('check data.\n');
fprintf('cd %s \n',outputdir);
disp('done')
endtime = clock;
totalelapsedtime = etime(endtime,starttime);
