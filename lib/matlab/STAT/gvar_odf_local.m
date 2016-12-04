% RUN_GVAR
clear 
close
matlabpool 4
odfdata = load('/home/hyunwoo/Workspaces/data/ODF_cvpr2013/NCCAM_WM_2x2x2_spatially_normalized_data_v2.mat');
disp('Data Loaded.')
%%
[nsubjects nvoxels ncoeffs ] =size(odfdata.nccam_wm_sqrt_odfs);
gvar = zeros(nvoxels,1);
tic;
parfor imask = 1:nvoxels
%     if mod(imask,1000)
%         fprintf('%d/%d\n ',imask,nvoxels);
%     end
    mx = reshape(odfdata.nccam_wm_sqrt_odfs(:,imask,:), nsubjects, ncoeffs)';
    gvar(imask) = geodesic_var([],mx);
end
toc;

save('gvar_odf_v2.mat','gvar');
%%
matlabpool close
