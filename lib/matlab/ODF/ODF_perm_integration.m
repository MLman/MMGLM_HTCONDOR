function proj  = ODF_perm_integration(inputdir)
%% script_for_ODF_result_integration. Permutation Test.
rootdir = inputdir;
curdir = pwd;
cd(rootdir);
expdirs = dir;
expdirs = expdirs(3:end);
%% Estimate size
total_length = 0;
for i =1:length(expdirs)
    cd([rootdir,'/',expdirs(i).name])
    files = dir;
    files = files(3:end);

    for ifile = 1:length(files)
        tmp = load(files(ifile).name);
        total_length = total_length + size(tmp.ErrMx,1);
    end
    cd(rootdir)

end
disp('Data size estimated.');
ntimes = size(tmp.ErrMx,2);
TotalErrMx = zeros(total_length,ntimes);
roi_vox_idx = zeros(total_length,1);

%% Reading Results
k = 1;
for i =1:length(expdirs)
    cd([rootdir,'/',expdirs(i).name])
    files = dir;
    files = files(3:end);
    if mod(i,100)==1
        fprintf('%s\n',mat2str(i/length(expdirs)));
    end
    for ifile = 1:length(files)
        tmp = load(files(ifile).name);
        nvox = length(tmp.roi_voxel_indices);
        idx = k:(k+nvox-1);
        roi_vox_idx(idx) = tmp.roi_voxel_indices;
        TotalErrMx(idx,:) = tmp.ErrMx;
        k = k +nvox;
    end
    cd(rootdir)
end
cd(curdir);
proj.TotalErrMx = TotalErrMx;
proj.roi_voxel_indices = roi_vox_idx;