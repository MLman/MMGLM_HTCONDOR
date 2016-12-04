function print_odf_nii(filepath, pvals,roi_vox_idx)
if exist(filepath)
    error([filepath,' exists.']);
    return
end
addpath('/home/hyunwoo/Workspaces/matlab_mv/headers/')
dirlist;
addpath(dlist.niibase_odf);
base_file=sprintf('isotropic_mean_2x2x2_fa.nii');
base_nii=load_nifti(base_file);
base_nii.vol=zeros(base_nii.dim(2),base_nii.dim(3),base_nii.dim(4));
base_nii.vol(roi_vox_idx)=1-pvals; %p-value.
save_nifti(base_nii,filepath);
