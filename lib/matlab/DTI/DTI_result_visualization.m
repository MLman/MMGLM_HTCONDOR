%Om Shanti.
%October 8, 2013.
%Nagesh Adluru.
%Sample code to visualize SH coefficients.

clear all;
close all;

%% Adding paths.
%addpath('/home/adluru/SoftwarePackages/my_mrtrix-0.2.11/matlab');
addpath('/home/hyunwoo/Workspaces/data/BarbDataForHyunwoo/FreeSurferMatlab');
%% Initializing variables.

results_root='/Users/hwkim/Dropbox/Workspace/Manifold/src/matlab_mv/masks';
base_file=sprintf('%s/combined_mean_wm_mask.nii',results_root);
base_nii=load_nifti(base_file);



%% Loading and writing the output files.
%Model 1.
prefix='ODF_AGE_GENDER_PROJ4';
load(sprintf('%s/%s.mat',results_root,prefix));
base_nii.vol=zeros(base_nii.dim(2),base_nii.dim(3),base_nii.dim(4));
base_nii.vol(roi_vox_idx)=normVage;%p-value.
%save_nifti(base_nii,sprintf('%s/%s.nii',results_root,prefix));