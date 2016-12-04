%Om Shanti.
%October 8, 2013.
%Nagesh Adluru.
%Sample code to visualize SH coefficients.

clear all;
close all;

addpath('/home/hyunwoo/Workspaces/matlab_mv/headers/')
dirlist;
%% Adding paths.
%addpath('/home/hyunwoo/Workspaces/data/BarbDataForHyunwoo/FreeSurferMatlab');
%% Initializing variables.
%results_root='/home/hyunwoo/Dropbox/Workspace/Manifold/src/matlab_mv/ODF_RESULT_VISUALIZATION';
addpath(dlist.niibase_odf);
base_file=sprintf('isotropic_mean_2x2x2_fa.nii');
base_nii=load_nifti(base_file);

%% Loading and writing the output files.
%Model 1.


%%

base_nii.vol=zeros(base_nii.dim(2),base_nii.dim(3),base_nii.dim(4));
base_nii.vol(roi_vox_idx)=1-pvals; %p-value.
pid = 40;
save_nifti(base_nii,sprintf('%s/project%s.nii',dlist.nii_odf,mat2str(pid)));
