function totalelapsedtime = DTI_condordata_gen_c_sub(Xin, szjob, datapath, metadata, outputdir,szsub)
%DTI_CONDORDATA_GEN_C_SUB generats data for condor or parallel computation.
%    
%   DTI_CONDORDATA_GEN_C_SUB(Xin, szjob, datapath, metadata, outputdir)
%   
%   Subdirectories
%
%   See also CSVREAD, IND2SUB, DTI_CONDORDATA_GEN_C

%   Hyunwoo J. Kim
%   $Revision: 0.1 $  $Date: 2014/07/17 21:19:00 $

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
gender = cell2mat(csvdata.data(:,9)); %Numeric. (1=male, 2= female)
age1 = cell2mat(csvdata.data(:,7)); %Numeric.
age2 = cell2mat(csvdata.data(:,8)); %Numeric.
FH = cell2mat(csvdata.data(:,10)); %Numeric. FH (1=Maternal, 2=Paternal, 3=Both, 4=Neither)
FH_M = FH==1 | FH==3;
FH_P = FH==2 | FH==3;
FH_B = FH==1 | FH==2 | FH==3; % Binary variable for family history.
APOE1 = cell2mat(csvdata.data(:,11)); %Numeric. APOE1 (2,3,4), 
APOE2 = cell2mat(csvdata.data(:,12)); %Numeric. APOE2 (2,3,4), 
APOE = APOE1 == 4 & APOE2 ==4; % IF  APOE1 < 4 and APOE2 < 4, APOE4status=neg.  IF  APOE1 = 4 or APOE2 = 4, APOE4status=pos.

DeltaAge = cell2mat(csvdata.data(:,5)); %Numeric. V1_V2_interval, 
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

%% New GMVL 2015
X_GMVL_2015_model1 = [gender, age1];
X_GMVL_2015_model2 = [gender];
X_GMVL_2015_model3 = [age1];


%% Parameter
eval(sprintf('X = %s;',Xin));
X=X';

subj_ids = csvdata.data(:,2);
Xc =centering(X);
Xs = scaling(Xc);
%Xs = [ones(size(DeltaAge)), Xs];
nsubjects = length(subj_ids);

%% Read Size of Data
fprintf('%d voxels are masked.\n',size(mask,1));
%szjob = 10;
ids = partition(size(mask,1),szjob);
prefix = 'exp_';

if isdir(outputdir)
    cd(outputdir);
else
    mkdir(outputdir);
    cd(outputdir);
end

subprefix = 'sub_'; % Prefix for subsets.
nexp = size(ids,1);
nsub = ceil(nexp/szsub);
iexp = 1;
isub = 1;

while iexp <= nexp
    fprintf('%f\n',isub/nsub);
    expcounter_per_sub = 0;

    % Shell script
    shname = sprintf('run_sub_%d.sh',isub);
    fp = fopen(shname,'w');
    fprintf(fp,'#!/bin/bash\n');
    fprintf(fp,'# Excutable_file_path input_dir output_dir shared_dir\n');

    while iexp <= nexp
        foldername = strcat([subprefix,mat2str(isub),'/',prefix,mat2str(ids(iexp,1))]);
        exp_name = foldername;
        mkdir(foldername);
        indices = ids(iexp,1):ids(iexp,2);
        mask_job = mask(ids(iexp,1):ids(iexp,2),:);
        mxstack_job = mxstack(ids(iexp,1):ids(iexp,2),1);
        Ys = mxstack_job2mx(mxstack_job);
        save(strcat(['./',foldername,'/','Ys_arma.mat']),'Ys','-ascii');
        save(strcat(['./',foldername,'/','mask_job_arma.mat']),'mask_job', '-ascii');

        %Shell script
        input_dir = sprintf('sub_%d/exp_%d',isub,ids(iexp));
        output_dir = ['totalresults/exp_',mat2str(ids(iexp))];
        fprintf(fp,'shared/legr_dti %s %s shared\n',input_dir,output_dir);

        iexp = iexp + 1;
        expcounter_per_sub =  expcounter_per_sub + 1; 
        if expcounter_per_sub >= szsub
            break;
        end 
    end

    fclose(fp); 
    isub = isub + 1;
end

foldername = 'shared';
mkdir(foldername);
save(strcat(['./',foldername,'/','Xs_arma.mat']),'Xs', '-ascii');
system(['cp /home/hyunwoo/Workspaces/matlab_mv/legr_dti ','./',foldername]);
system(['cp /home/hyunwoo/Workspaces/matlab_mv/idx_dti_arma.mat ','./',foldername]);
system('chmod 755 *.sh');
cd(curdir);
fprintf('check data.\n');
fprintf('cd %s \n',outputdir);
disp('done')
endtime = clock;
totalelapsedtime = etime(endtime,starttime);
