function elapsedtime = ODF_condordata_gen(Xin, szjob, datapath, metapath,outputdir)
%ODF_CONDORDAT_GEN generates data for condor.
starttime=clock;
curdir = pwd;
%datapath
%='/home/hyunwoo/Workspaces/data/ODF_cvpr2013/NCCAM_WM_2x2x2_spatially_norm
%alized_data_v1.mat';
%metapath='/home/hyunwoo/Workspaces/data/ODF_cvpr2013/non_imaging_csv_nccam.
%mat'
%outputdir = '/home/hyunwoo/Workspaces/data/ODF_condor_cvpr2013';

odfdata = load(datapath);
metadata = load(metapath);


Age = cell2mat(metadata.csvdata.data(:,2));
Gender = cell2mat(metadata.csvdata.data(:,4));
idxsubj = cell2mat(metadata.csvdata.data(:,3));
X = [Gender Age]';
X = X(:,idxsubj==1);
disp('Data Loaded.')



%% 
non_img_subj_ids=cell2mat(metadata.csvdata.data(:,1));%Numeric.
age=cell2mat(metadata.csvdata.data(:,2));%Numeric.
has_DTI=cell2mat(metadata.csvdata.data(:,3));
gender=cell2mat(metadata.csvdata.data(:,4));%Numeric.%0=Female, 1=Male.
group=metadata.csvdata.data(:,5);%String.
group_var=[strcmp('WL',group) strcmp('LTM',group)];%Over parameterization.
group=strcmp('LTM',group);
yom=cell2mat(metadata.csvdata.data(:,7));%Numeric.
tlph=cell2mat(metadata.csvdata.data(:,8));%Numeric.

%Filtering samples based on missing data.
%Getting the indices of the subjects/rows to be removed.
rm_idx=find(has_DTI==0 | strcmp('NA',group)==1);
%Removing.
non_img_subj_ids(rm_idx)=[];
age(rm_idx)=[];
has_DTI(rm_idx)=[];
group(rm_idx)=[];
group_var(rm_idx,:)=[];
gender(rm_idx)=[];
%LTM only measures.
yom(rm_idx)=[];%years of meditation (yom)
tlph(rm_idx)=[];%total life-time practice hours (tlph)
%ltm_idx=find(strcmp('LTM',group)==1);
ltm_idx=find(group==1);

%% Models.
%Fletcher

%Ours

X1=[group age gender];%RSS2. %# of samples (n=49). %Group difference model controlling for age and gender.
X11=[age gender];%RSS1.


X2=[group age group_var.*repmat(age,1,2) gender];%RSS2. %# of samples (n=49). %Age and group interaction model controlling for age and gender.
X21=[group age gender];%RSS1.

X3=[tlph(ltm_idx) age(ltm_idx) gender(ltm_idx)];%RSS2. %LTM ONLY. LTM=long term meditators %# of samples (n=23). %Effect of meditation practice hours controlling for age and gender.
X31=[age(ltm_idx) gender(ltm_idx)];%RSS1.

X4=[yom(ltm_idx) age(ltm_idx) gender(ltm_idx)];%RSS2. %LTM ONLY. %# of samples (n=23).%Effect of length of practice controlling for age and gender.
X41=X31;%RSS1.

X5=[tlph(ltm_idx)./yom(ltm_idx) age(ltm_idx) gender(ltm_idx)];%RSS2. %LTM ONLY. %# of samples (n=23).%Effect of "density" of practice (rate of practice) controlling for age and gender.
X51=X31;%RSS1.

X6=group;
X7=[group gender];
X8=[group gender age];
X9=[group age];
X10 = [gender age];

%% Choose X by string Xin.
eval(sprintf('X = %s;',Xin));
X=X';

%%  Make Independent variable.
Xc = centering(X);
Xs = scaling(Xc);

[nsubjects nvoxel ncoeff ] = size(odfdata.nccam_wm_sqrt_odfs);

%% Read Size of Data
fprintf('%d voxels are masked.\n',nvoxel);
%szjob = 100;
idx = partition(nvoxel,szjob);

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
    roi_voxel_indices = odfdata.roi_voxel_indices(idx(i,1):idx(i,2));
    k = 1;
    mxstack_tmp = cell(length(idx(i,1):idx(i,2)),1);
    for t = idx(i,1):idx(i,2)
        mx = reshape(odfdata.nccam_wm_sqrt_odfs(:,t,:), nsubjects, ncoeff)';
        mxstack_tmp{k} = mx;
        k = k+1;
    end
    save(strcat(['./',foldername,'/','data.mat']),'indices','roi_voxel_indices','exp_name',...
        'Xs','mxstack_tmp');
end
cd(curdir);
disp(outputdir);
disp('done')
endtime = clock;
elapsedtime = etime(endtime,starttime);
