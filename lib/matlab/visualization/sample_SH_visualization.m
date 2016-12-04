%Om Shanti.
%October 8, 2013.
%Nagesh Adluru.
%Sample code to visualize SH coefficients.

clear all;
close all;


addpath('/home/hyunwoo/Dropbox/Workspace/Manifold/lib/my_mrtrix-0.2.11/matlab');
load('/home/hyunwoo/Workspaces/data/HARDI_DTI_Waisman/sample_sqrt_ODF_data.mat');

sqrt_ODF.vox=[1 1 1 nan];
for i=1:length(all_sqrt_ODFs)
    sodf=all_sqrt_ODFs{i};
    num_voxels=size(sodf,1);
    num_SH_coefficients=size(sodf,2);

    xdim=ceil(num_voxels/(sqrt(num_voxels)));
    ydim=ceil(sqrt(num_voxels));

    sqrt_ODF.data=zeros(xdim,ydim,1,num_SH_coefficients);
    num_extra=(xdim*ydim)-num_voxels;
    sodf(end+1:end+num_extra,:)=zeros(num_extra,num_SH_coefficients);
    %     [ix,iy]=ind2sub([xdim ydim],1:num_voxels);
    %     idx=sub2ind([xdim ydim 1 num_SH_coefficients],ix,iy);
    %     sqrt_ODF.data(idx)=all_sqrt_ODFs{i};
    fprintf('\nWorking on ROI %d (%d x %d).',i,xdim,ydim);
    sqrt_ODF.data=reshape(sodf,[xdim ydim 1 num_SH_coefficients]);
    sqrt_ODF.dim=size(sqrt_ODF.data);
    write_mrtrix(sqrt_ODF,sprintf('sqrt_ODF_ROI_%d.mif',i));
end
fprintf('\n');

%%
xdim=10;
ydim=10;
sqrt_ODF.data=zeros(xdim,ydim,1,num_SH_coefficients);
sqrt_ODF.data=reshape(sodf(1:100,:),[xdim ydim 1 num_SH_coefficients]);
sqrt_ODF.dim=size(sqrt_ODF.data);
write_mrtrix(sqrt_ODF,sprintf('patch_ODF.mif'));