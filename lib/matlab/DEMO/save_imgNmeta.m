function imgNmeta=save_imgNmeta(imgindir, imgNmetapath, metadatapath, maskpath, nperms)
%
% Reads DTI iamges (nifti files) and meta data (CSV file)
% Save images and meta data in a unified MAT file.
%
% Input : CDT or DTI nifti images (SPDs) in a directory 
%       : CSV file (metadata), 1 column is enum (string). 2:end numeric.
% Output: a mat file with DTI images, metadata, and permutation index.
%         fused together.
%
%   $ Hyunwoo J. Kim $  $ 2016/06/19 23:59:22 (CDT) $
%   $ Hyunwoo J. Kim $  $ 2015/10/14 22:52:26 (CDT) $
%   $ Anmol Mohanty  $

% Read nifti files from a directory
% Apply mask and save in a mat file.
% The first 8 characters of image file names MUST be subject IDs.
disp('NIFTI -> MAT');
imgdata=nii2mat(imgindir, maskpath);   

%% Read CSV file and save it in a MAT file.
disp('CSV read');
csvdata = mycsvread(metadatapath);
% Column 2 to end are numeric. 
disp('CSV type conversion. Except the first column, covert string to numeric.');
csvdata  = csvstr2num(csvdata, 2:size(csvdata.data,2));  
%save(metamatpath, 'csvdata');

%	  Example of the structure of csvdata
%     csvdata =
%     colnames: {'enum'  'FH'  'sex'  'age'}
%         data: {10x4 cell}
%% Merge image data and csvdata

%Xftrnames = 'enum';
%icolsubjIDinCSV = mystrfindi(Xftrnames, csvdata.colnames);
icolsubjIDinCSV = 1;
imgNmeta = mergeimgNmeta(imgdata, csvdata, icolsubjIDinCSV);

%% Add index for permutations
idx_perm = myrandperm(nperms, imgNmeta.imgdata.nsubjects);
imgNmeta.idx_perm = idx_perm;
%% unfold struct to save 
imgdata = imgNmeta.imgdata; % Subjects in the intersection 
csvdata = imgNmeta.csvdata; % between imaga data and csvdata
save(imgNmetapath,'imgdata','csvdata','idx_perm', '-v7.3');

