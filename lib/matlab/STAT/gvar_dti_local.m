% RUN_GVAR_SPD
matlabpool 4
dtidata = load(dlist.datapath_dti);
disp('Data Loaded.')
mask = dtidata.mask;
mxstack = dtidata.mxstack;
clear dtidata;


%%
tic
pos = zeros(size(mask,1),3);
gvar = zeros(size(mask,1),1);
parfor imask = 1:size(mask,1)
%    imask
    ix = mask(imask,1);
    iy = mask(imask,2);
    iz = mask(imask,3);
    pos(imask,:) = [ix iy iz]; % Location information
    gvar(imask) = geodesic_var_spd([],mxstack{imask});
end
toc
disp('Done.')
save('gvar_dti.mat','pos','gvar');
disp('Saved.')
matlabpool close