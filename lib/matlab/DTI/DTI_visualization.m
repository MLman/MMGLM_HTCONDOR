addpath('/home/hyunwoo/Workspaces/data/BarbDataForHyunwoo/FreeSurferMatlab');
datadir = '/home/hyunwoo/Workspaces/data/BarbDataForHyunwoo/DTIFiles';
header = 'tbss_ID, subj_ID, gender (1=female; 2=male), age @ scan, Fam His , APOE all1, APOE all2,APOE discrete,Fam Hist discrete txt,APOE 3 group,APOE';





%% Synthesize Ground Truth
Y1 = eye(3);
Y1(1) = 2;
Y2 = eye(3);
Y2(2,2) = 3;
v = logmap_spd(Y1,Y2);

t = 0.2:0.2:0.8;
Yt = zeros(3,3,length(t));
for i = 1:length(t)
    Yt(:,:,i) = expmap_spd(Y1,t(i)*v);
end
X = [0 t 1];
Xc = X- mean(X);
Y =zeros(3,3,length(t)+2);
Y(:,:,1) = Y1;
Y(:,:,2:end-1) = Yt;
Y(:,:,end) = Y2;

%% Sample Data
% data 4
Ysample = [];
Xsample = repmat(Xc,1,ndata);
ndata = 40;
noise = 0.1;
kdata = 4;
Ysample = zeros(3,3,ndata*length(X));

for i = 1:ndata
    Ysample(:,:,(length(X)*(i-1)+1):(length(X)*i)) = (Y + noise*(randn(size(Y))));
end

%% Y samples projection onto SPD
for i = 1:size(Ysample,3)
    Ysample(:,:,i) = proj_M_spd(Ysample(:,:,i));
end

%% Geodesic Regression
[p, V, E, gnorm, Y_hat] = GR_linerr_spd(Xsample,Ysample);

%% Load Template for visualization
nii_master=load_nifti(strcat([datadir,'/','mets00002_combined.nii.gz']));
ix = 1:6;
iy = 1:6;
iz = 37;
tensor_components = nii_master.vol(ix,iy,iz,1,:);

%% Changing the header info.
patch=nii_master;
patch.dim(2:6) = [length(ix) length(iy) length(iz) 1 6];
patch.vol = zeros(patch.dim(2),patch.dim(3),patch.dim(4),patch.dim(5),patch.dim(6));
patch.vol = tensor_components;
%%
%tensor_components is a 10x10x6 matrix. Dxx, Dyx, Dyy, Dzx, Dzy, and Dzz in that order.
save_nifti(patch,'patch_tensors.nii');

%At the terminal.
%TVglyphview -in patch_tensors.nii;
patch=load_nifti('patch_tensors.nii');