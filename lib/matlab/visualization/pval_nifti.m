function pval_nifti(baseniipath, outputpath, pvals, pos)
%PVAL_NIFTI prints p-values (PVALS) on BASENIIPATH according to POS.
%
%   See Also: LOAD_NIFTI

%   $ Hyunwoo J. Kim $  $ 2014/10/27 12:42:28 (CDT) $

base_nii=load_nifti(baseniipath);
base_nii.vol=zeros(base_nii.dim(2),base_nii.dim(3),base_nii.dim(4));
for i = 1:size(pos,1)
    if sum(pos(i,:) ==0) > 0 
        continue;
    end
    base_nii.vol(pos(i,1), pos(i,2), pos(i,3)) = 1-pvals(i);
end
save_nifti(base_nii,outputpath);