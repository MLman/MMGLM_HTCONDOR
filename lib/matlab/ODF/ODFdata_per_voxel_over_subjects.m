% Navigate data directory
clear;
close;
addpath('/home/hyunwoo/Workspaces/data/BarbDataForHyunwoo/FreeSurferMatlab');


curdir = pwd;
datadir = '/home/hyunwoo/Workspaces/data/BarbDataForHyunwoo/DTIFiles';
metadata = '/home/hyunwoo/Workspaces/data/BarbDataForHyunwoo/NonImagingInformation/ICTR_Master.mat';
load(metadata);
X = csvdata.data(:,3:4);
X = cell2mat(X);
% Gender ( 1 = female,  2 = male)
% Age
% What else is available?
X = X';
idx = 1:length(X);
subj_ids = csvdata.data(idx,2);
X = X(:,idx);
Xc = X - mean(X,2)*ones(1,size(X,2));

suffix = '_combined.nii.gz';
nsubjects = length(subj_ids);

ix = 40:49;
iy = 40:49;
iz = 37;
tic
tensor_components = cell(nsubjects,1);
for i =1:length(subj_ids)
    id = subj_ids{i};
    nii_master = load_nifti(strcat([datadir,'/',id,suffix]));
    tensor_components{i} = nii_master.vol(ix,iy,iz,1,:);
end
disp('reading data')
elapsedtime_reading = toc
%% Make a matrix
%
% ix iy iz mx*subj
tensor_over_subject = cell([length(ix),length(iy), length(iz)]);

for ixx = 1:length(ix)
    for iyy = 1:length(iy)
        for izz = 1:length(iz)
            mx = zeros(3,3,length(subj_ids));
            for i = 1:length(subj_ids)
                patch = tensor_components{i};
                mx(:,:,i) = dticoef2mx(squeeze(patch(ixx,iyy,izz,1,:)));
            end
            tensor_over_subject{ixx,iyy,izz} = mx;
        end
    end
end

%% DTI coefficients.
% Dxx 1  Dxy 2 Dzx 4
%     2  Dyy 3 Dzy 5
%     4  Dzy5  Dzz 6

%% Geodesic regression
tic
results = cell([length(ix),length(iy), length(iz)]);

k = 0;
for ixx = 1:length(ix)
    for iyy = 1:length(iy)
        for izz = 1:length(iz)
            k/(length(ix)*length(iy)*length(iz))*100
            Y = tensor_over_subject{ixx,iyy,izz};
            tic;
            [p V E gnorm Y_hat ] = GR_linerr_spd(Xc,Y);
            elapsedtime = toc
            res = packresult(p,V,E,gnorm,Y_hat);
            res.pos = [ix(ixx) iy(iyy) iz(izz)]; % Location information
            res.eplasedtime = elapsedtime;
            results{ixx,iyy,izz} = res;
            k = k +1;
        end
    end
end

elapsedtime_gr = toc
save('gr_10by10_1000iter')