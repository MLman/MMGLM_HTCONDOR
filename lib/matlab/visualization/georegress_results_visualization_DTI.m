%Om Shanti.
%October 8, 2013.
%Nagesh Adluru.
%Sample code to visualize SH coefficients.

clear all;
close all;
addpath ../headers
addpath ../
addpath ../STAT
dirlist;
addpath(dlist.freesurf);
%% Initializing variables.
base_nii=load_nifti(dlist.niibase_dti);

%% Load data
load proj45_integrated_result
base_nii.vol=zeros(base_nii.dim(2),base_nii.dim(3),base_nii.dim(4));
pvals = pvalperm(proj.TotalErrMx(:,1),  proj.TotalErrMx(:,2:end));
pos = proj.mask;

%% !!! For two missing pixels
for i =1:length(pos)
    base_nii.vol(pos(i,1),pos(i,2),pos(i,3))=1-pvals(i);%p-value.
end
%% Write Files
save_nifti(base_nii,sprintf('%s/%s.nii',dlist.nii_dti,'proj45'));
%%

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
%     models{i} = ftest_wrap(sprintf('./results/DTI_res_%s.mat',res{2*(i-1)+1}),...
%         sprintf('./results/DTI_res_%s.mat',res{2*i}),N);
% end
% 
% base_nii.vol=zeros(base_nii.dim(2),base_nii.dim(3),base_nii.dim(4));
% for i =1:length(pos)
%     base_nii.vol(pos(i,1),pos(i,2),pos(i,3))=res.model4_p(i);%p-value.
% end
% save_nifti(base_nii,sprintf('%s/%s.nii',dlist.nii_dti,'proj44'));