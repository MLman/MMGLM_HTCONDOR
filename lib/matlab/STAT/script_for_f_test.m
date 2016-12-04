% N = 343;
% model1_p = Ftest('DTI_res_X1.mat','DTI_res_X11.mat',N);
% model2_p = Ftest('DTI_res_X2.mat','DTI_res_X21.mat',N);
% model3_p = Ftest('DTI_res_X3.mat','DTI_res_X31.mat',N);
% model4_p = Ftest('./results/DTI_res_X4.mat','./results/DTI_res_X41.mat',N);
% model5_p = Ftest('DTI_res_X5.mat','DTI_res_X51.mat',N);
% positions = X1.positions;

%% ODF
clear all;
close all;

addpath('/home/hyunwoo/Workspaces/data/BarbDataForHyunwoo/FreeSurferMatlab');
results_root='/home/hyunwoo/Dropbox/Workspace/Manifold/src/matlab_mv/ODF_RESULT_VISUALIZATION';
base_file=sprintf('%s/isotropic_mean_2x2x2_fa.nii',results_root);
base_nii=load_nifti(base_file);

% %% f-test
% N = 49; % Number of subjects
% res = {'X1','X11','X2','X21','X3','X31','X4','X41','X5','X51'};
% models={};
% for i = 1:length(res)/2
%     models{i} = Ftest(sprintf('./results/ODF_res_%s.mat',res{2*(i-1)+1}),...
%         sprintf('./results/ODF_res_%s.mat',res{2*i}),N);
% end
% 
% %% Write nii
% %load([results_root,'/ROI.mat']);
% odfdata = load(datapath);
% roi_vox_idx
% for id=1:5
%     base_nii.vol=zeros(base_nii.dim(2),base_nii.dim(3),base_nii.dim(4));
%     base_nii.vol(roi_vox_idx)=models{id};%p-value.
%     save_nifti(base_nii,sprintf('ODF_Model%s.nii',mat2str(id)));
%end

%
% N = 49;
% %load('ODF_RESULT_VISUALIZATION/ROI')
% model = Ftest('ODF_RESULT_VISUALIZATION/ODF_AGE_GENDER_PROJ4.mat','ODF_RESULT_VISUALIZATION/ODF_GENDER_PROJ6.mat',N);
% base_nii.vol=zeros(base_nii.dim(2),base_nii.dim(3),base_nii.dim(4));
% base_nii.vol(roi_vox_idx)=1-model;%p-value.
% save_nifti(base_nii,'ODF_RESULT_VISUALIZATION/ODF_AGE_control_GENDER_proj4_6.nii');


% %% DTI
% %% Adding paths.
% addpath('/home/hyunwoo/Workspaces/data/BarbDataForHyunwoo/FreeSurferMatlab');
% 
% %% Initializing variables.
% mask_root='/home/hyunwoo/Dropbox/Workspace/Manifold/src/matlab_mv/masks';
% base_file=sprintf('%s/combined_mean_wm_mask.nii.gz',mask_root);
% base_nii=load_nifti(base_file);
% results_root='/home/hyunwoo/Dropbox/Workspace/Manifold/src/matlab_mv/ODF_RESULT_VISUALIZATION';
% 
% 
% %% Loading and writing the output files.
% %Model 1.
% prefix='DTI_results_1024';
% res = load(sprintf('%s/%s.mat',results_root,prefix));
% pos = res.positions;
% %%
% N = 343;
% res = {'X1','X11','X2','X21','X3','X31','X4','X41','X5','X51'};
% models={};
% for i = 1:length(res)/2
%     models{i} = Ftest(sprintf('./results/DTI_res_%s.mat',res{2*(i-1)+1}),...
%         sprintf('./results/DTI_res_%s.mat',res{2*i}),N);
% end
% %%
% for id = 1:length(res)/2
%     base_nii.vol=zeros(base_nii.dim(2),base_nii.dim(3),base_nii.dim(4));
%     for i =1:length(pos)
%         base_nii.vol(pos(i,1),pos(i,2),pos(i,3))=1-models{id}(i);%p-value.
%     end
%     save_nifti(base_nii,sprintf('%s/%s%s.nii',results_root,'DTI_Model',mat2str(id)));
% end