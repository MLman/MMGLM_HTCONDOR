function jt2cdt(jtdir, maskpath, cdtdir)
% Read Jacobi tensor images and convert it into CDT (Cauchy deformation tensors)
% Jacobi tensor is a 3x3 PD but it is not symmetric.
% CDT is a 3x3 SPD (symmetric positive definite).
% If you run analysis for input images which are already in DTI format, this preprocessing step is not needed.
% DTI is already a 3x3 SPD - hmmm

%   $ Hyunwoo J. Kim $  $ 2015/10/16 11:41:33 (CDT) $
%   $ Anmol Mohanty $  $ 2015/10/17 8:41:33 (CDT) $

%dataroot='/home/anmol/Desktop/RA_799_Vikas/data/DTI_FULL_489';
%Note this file/step isn't required as the images are already DTI.

% Input files
%jtdir = fullfile(dataroot,'images_jt');
%maskpath = fullfile(dataroot,'crispMeanIso_fa.nii');

% Output directory
mkdir(cdtdir);
%% Load DTI data
suffix = '_cdt.nii.gz';
curdir=pwd;
inputdir = jtdir;
outputdir = cdtdir;
fnames = dir(strcat([inputdir,'/','*.nii.gz']));

%???where is this function located?

mask = load_nifti(maskpath);
fprintf('%d image files will be converted into CDT images.\n', length(fnames));
for ifile = 1:length(fnames)
    nii_master = load_nifti(strcat([inputdir,'/',fnames(ifile).name]));
    fprintf('[LOAD] %s \n',strcat([inputdir,'/',fnames(ifile).name]));
    nii_master_CT = nii_master; % CT Cauchy tensor 
    nii_master_CT.dim(6) = 6; % We need only six numbers.   
    dims = nii_master_CT.dim;
    
    nii_master_CT.vol = zeros(dims(2),dims(3),dims(4), dims(5),dims(6));   
    
    %% Dimension check
    assert(sum(nii_master.dim(2:(1+nii_master.dim(1)))' ~= size(nii_master.vol)) == 0, ...
        'Header''s dimension doesn''t agree with data.')
    dimx = uint8(nii_master.dim(2));
    dimy = uint8(nii_master.dim(3));
    dimz = uint8(nii_master.dim(4));

    tic
    for ix = 1:dimx
        for iy = 1:dimy
            for iz = 1:dimz
                if mask.vol(ix,iy,iz) == 1
                    J = reshape(squeeze(nii_master.vol(ix,iy,iz,1,:)),3,[])'; %creating the imp matrix J
                    CT = sqrtm(J'*J);
                    assert(isspd(CT)==1);
                    nii_master_CT.vol(ix,iy,iz,1,:) = spd2vec(CT);
                end
            end
        end
    end
    save_nifti(nii_master_CT,[outputdir,'/',fnames(ifile).name(1:end-13),'_cdt.nii.gz']);
    toc
end

