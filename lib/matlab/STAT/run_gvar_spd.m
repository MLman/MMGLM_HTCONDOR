% RUN_GVAR_SPD
%load('../datafolder/data_dti.mat')
load('data.mat')
mxstack = mxstack_job;
disp('Data Loaded.')
mask = mask_job;


results = cell(size(mask,1),1);
tic
for imask = 1:size(mask,1)
    imask
    ix = mask(imask,1);
    iy = mask(imask,2);
    iz = mask(imask,3);
    res.pos = [ix iy iz]; % Location information
    res.gvar = geodesic_var_spd([],mxstack{imask});
    results{imask} = res;
end
toc
disp('Done.')
save(strcat([exp_name,'_result_gvar_spd']),'results');
disp('Saved.')