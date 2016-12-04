% RUN_GVAR
load('data.mat')
mxstack = mxstack_tmp;
disp('Data Loaded.')
results = cell(size(roi_voxel_indices,1),1);

tic
for imask = 1:size(roi_voxel_indices,1)
%    fprintf('%d/%d\n ',imask,size(roi_voxel_indices,1));
    Y = mxstack{imask};
    res.pos = roi_voxel_indices(imask); % Location information
    res.gvar = geodesic_var([],mxstack{i});
    results{imask} = res;
end
toc

save(strcat([exp_name,'_result_gvar_odf']),'results');