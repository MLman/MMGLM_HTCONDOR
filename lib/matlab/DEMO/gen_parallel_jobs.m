function gen_parallel_jobs(imgNmetapath,outdir,Xftrnames,binpath,nperms,varargin)
%
% gen_parallel_jobs(imgNmetapath,outdir,Xftrnames,nperms)
% gen_parallel_jobs(imgNmetapath,outdir,Xftrnames,nperms,option)
%
% option.szjob % number of voxels in a job (1 hour job for CONDOR)
% option.njobs % number of jobs (= the number of servers in AWS)
% Read MAT file (img, meta and idx_perm file).
% Make multiple jobs for parallel computing (e.g. CONDOR).
% Due to the ceiling, the number of jobs <= option.njobs.
% ex) ceil(7 voxels/6 jobs) = 2 -> 7 vox / 2 vox = 4 jobs (<= 6 jobs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Innput : DTI images.
%        : CSV file (metadata)
% Output: a mat file with DTI images, metadata, and permutation index.
%   $ Hyunwoo J. Kim $  $ 2016/06/20 01:07:23 (CDT) $
%   $ Hyunwoo J. Kim $  $ 2015/10/14 22:52:26 (CDT) $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imgNmeta = load(imgNmetapath);

szjob = 20;   % Number of voxels per job

if nargin==6
   option=varargin{1};
   assert(~isfield(option,'szjob') || ~isfield(option,'njobs'),'Option Conflict.');
   if isfield(option,'szjob')
       szjob = option.szjob;
   elseif isfield(option,'njobs')
       njobs = option.njobs;
       szjob = ceil(length(imgNmeta.imgdata.mxstack)/njobs);
   end
end
szjob
assert(size(imgNmeta.csvdata.data,1)==imgNmeta.imgdata.nsubjects && ...
imgNmeta.imgdata.nsubjects==length(imgNmeta.imgdata.subj_ids) && ...
max(max(imgNmeta.idx_perm)) == imgNmeta.imgdata.nsubjects);

%% Check ID matching
idxftrs = mystrfindi(Xftrnames,imgNmeta.csvdata.colnames);
X = cellfun(@double, imgNmeta.csvdata.data(:,idxftrs));

totalelapsedtime=DTI_condordata_gen(X,szjob,imgNmeta.imgdata.mxstack, ...
    imgNmeta.imgdata.mask,outdir);

% Save the file for c++ code.
idx_perm=imgNmeta.idx_perm(1:(nperms+1),:);
dlmwrite(fullfile(outdir,'/shared/','idx_perm_arma.mat'), idx_perm,' ');
system(sprintf('cp %s %s',binpath,fullfile(outdir,'/shared/')),'-echo');
