function ODF_result_integration(inputdir,outputpath,ncoeff)

% rootdir is a root dirctory of result
%rootdir = '/home/hyunwoo/Workspaces/condor/exp_odf_4_res_gender_age';
rootdir = inputdir;

% targetdir
%targetdir = '/home/hyunwoo/Workspaces/condor/exp_odf_1_res_sub_summary';

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
        total_length = total_length + length(tmp.results);
    end
    cd(rootdir)

end
disp('Data size estimated.');
ndimV = numel(tmp.results{1}.V);
ndimP = numel(tmp.results{1}.p);
nV = ndimV/ncoeff;
%%
roi_vox_idx = zeros(total_length,1); 
E=zeros(total_length,1);
gnorm=zeros(total_length,1);
V =zeros(ndimV,total_length);
P=zeros(ndimP,total_length);


k = 1;
for i =1:length(expdirs)
    cd([rootdir,'/',expdirs(i).name])
    files = dir;
    files = files(3:end);
    
    for ifile = 1:length(files)
        tmp = load(files(ifile).name);
        
        for ires = 1:length(tmp.results)
            V(:,k) = reshape(tmp.results{ires}.V,[],1);
            P(:,k) = tmp.results{ires}.p;
            roi_vox_idx(k) = tmp.results{ires}.pos;
            E(k) = tmp.results{ires}.E;
%            gnorm(k) = tmp.results{ires}.gnorm;
            k = k +1;
        end
        
    end
    cd(rootdir)

end
disp('Result integrated.');
cd(curdir);
clear tmp rootdir total_length k ires ifile i files expdirs curdir ans ndimV
save(outputpath)
fprintf('%s saved\n',outputpath);