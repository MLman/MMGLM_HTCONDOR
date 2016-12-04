%Om Shanti.
%September 30, 2013.
%Nagesh Adluru.
%Computing sqrtODFs from DWI using code from Anqi Qiu's group.

clear all;
close all;

%% Adding the paths.
addpath('/home/adluru/SoftwarePackages/my_mrtrix-0.2.11/matlab');
addpath('/home/adluru/HARDI_Processing_Scripts/Archive');
addpath('/home/adluru/TMP_MATLAB_CODE/matlab');

%% Initializing the variables.
out_root='/scratch/Nagesh/GeodesicRegression_Data/NCCAM_ODF';
load(sprintf('%s/NCCAM_WM_2x2x2_spatially_normalized_data_v1.mat',out_root));
num_voxels=length(roi_voxel_indices);
cd /scratch/Nagesh/GeodesicRegression_Data/SubjMIFs_smoothed
mifs=dir('*smoothed.mif');
num_subjs=length(mifs);
for subj_id=1:num_subjs
    tic;
    sqrt_ODF=read_mrtrix(mifs(subj_id).name);
    if(subj_id==1)
        xdim=sqrt_ODF.dim(1);
        ydim=sqrt_ODF.dim(2);
        zdim=sqrt_ODF.dim(3);
        num_SH_parameters=sqrt_ODF.dim(4);
        nccam_wm_sqrt_odfs=zeros(num_subjs,num_voxels,num_SH_parameters);
    end
    for j=1:num_voxels
        [vx,vy,vz]=ind2sub([xdim ydim zdim],roi_voxel_indices(j));
        nccam_wm_sqrt_odfs(subj_id,j,:)=sqrt_ODF.data(vx,vy,vz,:);
    end
    fprintf('\nCompleted subj %d in %f sec.',subj_id,toc);
end
save(sprintf('%s/NCCAM_WM_2x2x2_normalized_smoothed_v1.mat',out_root),'nccam_wm_sqrt_odfs','roi_voxel_indices');