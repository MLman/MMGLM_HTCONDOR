%Om Shanti.
%October 31, 2013.
%Nagesh Adluru.

clear all;
close all;

addpath('/home/adluru/TMP_MATLAB_CODE');
root='/scratch/Nagesh/GeodesicRegression_Data/ICTR_DTI_Results';

wm_nii=load_nifti(sprintf('%s/combined_mean_wm_mask_1x1x1_thr_0.5_fa_thr_0.3.nii.gz',root));
wm_idx=find(wm_nii.vol(:)>0);


fa_nii=load_nifti(sprintf('%s/FA_Group_Gender_Age_1x1x1_1-p.nii.gz',root));
fa_smth_nii=load_nifti(sprintf('%s/FA_Group_Gender_Age_smth_1x1x1_1-p.nii.gz',root));
dti_nii=load_nifti(sprintf('%s/DTI_1104_1_1x1x1_1-p.nii.gz',root));
pval_hist_wrapper(dti_nii,fa_nii,fa_smth_nii,wm_idx,'Full model',sprintf('%s/p_val_hist_fm.png',root));

fa_nii=load_nifti(sprintf('%s/FA_Group_Gender_AgeEffect_1x1x1_1-p.nii.gz',root));
fa_smth_nii=load_nifti(sprintf('%s/FA_Group_Gender_AgeEffect_smth_1x1x1_1-p.nii.gz',root));
dti_nii=load_nifti(sprintf('%s/DTI_1105_1_1x1x1_1-p.nii.gz',root));
pval_hist_wrapper(dti_nii,fa_nii,fa_smth_nii,wm_idx,'Age effect',sprintf('%s/p_val_hist_age.png',root));

fa_nii=load_nifti(sprintf('%s/FA_GroupEffect_Gender_Age_1x1x1_1-p.nii.gz',root));
fa_smth_nii=load_nifti(sprintf('%s/FA_GroupEffect_Gender_Age_smth_1x1x1_1-p.nii.gz',root));
dti_nii=load_nifti(sprintf('%s/DTI_1107_1_1x1x1_1-p.nii.gz',root));
pval_hist_wrapper(dti_nii,fa_nii,fa_smth_nii,wm_idx,'Group effect',sprintf('%s/p_val_hist_group.png',root));