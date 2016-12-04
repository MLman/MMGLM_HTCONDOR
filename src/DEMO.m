curpath = pwd;
addpath(genpath(fullfile(curpath,'../lib/matlab')));

jtdir='/data/hdd1/MGLM_demo/data/images_jt';
cdtdir='/data/hdd1/MGLM_demo/data/images_cdt';
maskpath='/data/hdd1/MGLM_demo/data/PDRMRTLongitudinalT1WOneSliceMask.nii.gz';
%jtdir='/data/hdd1/CauchyDeformationTensorProject/NewDataFeb2015/PDTMRTLongJacMats/Feb2015Set'
%cdtdir ='/data/hdd1/CauchyDeformationTensorProject/NewDataFeb2015/PDTMRTLongJacMats/Feb2015Set_CDT' 
%For full data mask is not found.
%maskpath = '/data/hdd1/CauchyDeformationTensorProject/PDRMRTLongitudinalT1W_templateBET_pve_1_GMV2.nii.gz';  

% Step 0: Read Jacobi tensor (PD) images and convert it into CDTs (SPD)
% If you run analysis for DTI (SPD) images, this step is not needed.
jt2cdt(jtdir, maskpath, cdtdir);

% Step 1: Reads DTI images (nifti files) and meta data (CSV file)
% Save imgage and meta data in a unified MAT file.
% WARNING: CSV Files have all numeric values except the first column (Subject IDs).

nperms = 2e4; % Number of permutations
imgindir =cdtdir;
metadatapath='/data/hdd1/MGLM_demo/data/metadata.csv';
imgNmetapath='/data/hdd1/MGLM_demo/data/imgNmeta_MGLM_DEMO';
save_imgNmeta(imgindir, imgNmetapath, metadatapath, maskpath, nperms);

% Step 2: Read imgNmeta file (img, meta and idx_perm file).
% Make multiple jobs for parallel computing (e.g. AWS or CONDOR).

condorinroot='/data/hdd1/MGLM_demo/data/condorin';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example
% MMGLMs
% Model 1 :  Y = b0+ b1*sex
% Model 2 :  Y = b0+ b1*sex + b2*age

% All elements before the last one (age) are controlled.
%Xftrnames = {'sex','age'}; % sex is controlled. 
%csvdata.colnames: {'enum'  'FH'  'sex'  'age'}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Xftrnames = {'sex', 'age'}; % {nuisance variables, independent variable}. 
option.njobs = 20; % Number of your servers in AWS.
%szjob=20;  % Number of voxels for each job. <- Working on it.
nperms=2e4; % For DEMO. neprms needs to be big enough e.g., 2e4.
binpath='/home/hyunwoo/Workspaces/2_working_projects/research/0_mmglm_neuroimage_private/lib/c++/bin/mmglm_spd_par';
outdir='/data/hdd1/MGLM_demo/condorin/run_aws_3';
gen_parallel_jobs(imgNmetapath,outdir,Xftrnames,binpath,nperms,option);
