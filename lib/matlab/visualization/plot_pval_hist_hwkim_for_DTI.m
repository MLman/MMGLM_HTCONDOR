%Om Shanti.
%October 31, 2013.
%Nagesh Adluru.

%clear all;
%close all;

root='/home/hyunwoo/Workspaces/brain_image/dti/base';

wm_nii=load_nifti(sprintf('%s/combined_mean_fa.nii.gz',root));
wm_idx=find(wm_nii.vol(:)>0);



%dti_nii=load_nifti(sprintf('%s/../APOE_effect_new_vectorization_no_smoothing.nii',root));
dti_nii=load_nifti(sprintf('%s/../proj53_proj55c_sz5.nii',root));
fa_smth_nii = dti_nii;
fa_nii = fa_smth_nii;
pval_hist_wrapper(dti_nii,fa_nii,fa_smth_nii,wm_idx,'APOE effect model',sprintf('%s/p_val_hist_fm.png',root));
