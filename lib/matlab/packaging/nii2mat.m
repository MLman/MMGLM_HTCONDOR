function imgdata=nii2mat(dataroot, maskpath, varargin)   
%PackageJacMatData_hw integrates brain images in dataroot into one mat file. Also it applies ROI (mask).
%
%   NII2MAT returns imgdata or save imgdata at outputfname.
%   PackageJacMatData_hw packages JacMat files to one mat file converting them into CauchyTensor.
%   Single precision.
%   
%
%  options.id_length the length of ids %IDs MUST be the prefix of all image files in dataroot.
%  options.outputfname % Save imgdata at outputfname.
%
%  nii2mat(dataroot, maskpath); % No return value. 
%  imgdata=nii2mat(dataroot, maskpath)   
%  imgdata=nii2mat(dataroot, maskpath, options)
%  nii2mat(dataroot, maskpath, options) % No return value but saving.

%   MAT file format 
%
%    tmp = 
%      directory
%      subj_ids: {343x1 cell}
%     nsubjects: 343
%          mask: [49584x3 double]
%       mxstack: {49584x1 cell}

%   $ Hyunwoo J. Kim $  $ 2016/06/20 00:19:34 (CDT) $
%   $ Hyunwoo J. Kim $  $ 2016/06/19 23:48:25 (CDT) $
%   $ Hyunwoo J. Kim $  $ 2016/06/19 23:17:39 (CDT) $

    curdir = pwd;
    roiMask=load_nifti(maskpath);
    assert(length(unique(roiMask.vol(:))) == 2)
    roiIdx=find(roiMask.vol(:)>0);
    [ix,iy,iz]=ind2sub(size(roiMask.vol),roiIdx);
    cd(dataroot);
    fileNames=dir(fullfile(dataroot,'*.nii.gz'));
    numSubjs=length(fileNames);
    Tensors=zeros(numSubjs,length(roiIdx),3,3);

    % Options.
    outputfname=[];
    if nargin ==3
        options=varargin{1};
        if isfield(options,'id_length')
            id_length = options.id_length;
        end
        if isfield(options,'outputfname');
            outputfname=options.outputfname;
        end
    end
%    matlabpool open;
    id_length = 8;
    for subjId=1:numSubjs
        tic;
        fprintf('\nReading %s',fileNames(subjId).name);
        nii=load_nifti(fileNames(subjId).name);
        vol=squeeze(nii.vol);
        %Column ordering.
%        parfor r=1:length(roiIdx)
        for r=1:length(roiIdx)
            Tensors(subjId,r,:,:) = dticoef2mx(squeeze(vol(ix(r),iy(r),iz(r),:)));
        end
        fprintf('\nFinished %d/%d in %f sec.\n',subjId,numSubjs,toc);
    end
    subj_ids = cell(numSubjs,1);

    for isubj = 1:numSubjs
        subj_ids{isubj} = fileNames(isubj).name(1:id_length);
    end

    disp(['NumSubjs: ',mat2str(numSubjs)]);
    mask = [ix, iy, iz];
    numvox = length(ix);
    mxstack = cell(numvox,1);
    %%
    parfor ivox = 1:numvox
        amxstack = zeros(3,3,numSubjs);
        for isubj = 1:numSubjs
            amxstack(:,:,isubj) = squeeze(Tensors(isubj,ivox,:,:));
        end
        mxstack{ivox} = single(amxstack);
    end

    directory = dataroot;
%    matlabpool close force local;

    nsubjects = numSubjs;
    if ~isempty(outputfname)
        save(outputfname,'subj_ids','nsubjects','mask','maskpath','mxstack','directory','-v7.3');
    end
    if nargout ==1
        imgdata=[];
        imgdata.subj_ids=subj_ids; 
        imgdata.nsubjects=nsubjects;
        imgdata.mask=mask;
        imgdata.maskpath=maskpath;
        imgdata.mxstack=mxstack;
        imgdata.directory=directory;
    end
    cd(curdir);
end


