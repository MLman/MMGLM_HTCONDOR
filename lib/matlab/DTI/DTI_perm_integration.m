function [proj mask errfiles nerr] = DTI_perm_integration(inputdir)
%% script_for_ODF_result_integration. Permutation Test.
rootdir = inputdir;
curdir = pwd;
cd(rootdir);
expdirs = dir;
expdirs = expdirs(3:end);
%% Estimate size
total_length = 0;
errfiles = [];
nerr = 0;
disp('Size Estimation Started.')
for i =1:length(expdirs)
    cd([rootdir,'/',expdirs(i).name])
%    fprintf('%s\n', expdirs(i).name);
    files = dir;
    files = files(3:end);

    for ifile = 1:length(files)
	try
	    tmp = load(files(ifile).name);
	catch err
	    disp(err)
            errfiles{nerr +1} = files(ifile).name
	    nerr = nerr + 1;
	end
        total_length = total_length + size(tmp.ErrMx,1);
    end
    cd(rootdir)

end
disp('Data size estimated.');
ntimes = size(tmp.ErrMx,2);
TotalErrMx = zeros(total_length,ntimes);
mask = zeros(total_length,3);

%% Reading Results
k = 1;
nerr = 0;
for i =1:length(expdirs)
    cd([rootdir,'/',expdirs(i).name])
    files = dir;
    files = files(3:end);
    if mod(i,100)==1
        fprintf('%s\n',mat2str(i/length(expdirs)));
    end
    for ifile = 1:length(files)
        try
            tmp = load(files(ifile).name);
        catch err
	    nerr = nerr + 1;
	    continue;
        end
        nvox = size(tmp.mask_job,1);
        idx = k:(k+nvox-1);
        
        mask;
        tmp.mask_job;
        mask(idx,:) = tmp.mask_job;
        TotalErrMx(idx,:) = tmp.ErrMx;
        k = k +nvox;
    end
    cd(rootdir)
end
cd(curdir);
proj.TotalErrMx = TotalErrMx;
proj.mask = mask;
