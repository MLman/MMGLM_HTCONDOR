function PackageJacMatData_hw(dataroot, mask, outputfname, cauchy)   
%PackageJacMatData_hw integrates brain images in dataroot into one mat file. Also it applies ROI (mask).
%
%   PackageJacMatData_hw packages JacMat files to one mat file converting them into CauchyTensor.
%   The format I want
%
%    tmp = 
%      directory
%      subj_ids: {343x1 cell}
%     nsubjects: 343
%          mask: [49584x3 double]
%       mxstack: {49584x1 cell}
%
%    "FreeSurferMatlab" is required.

% Hyunwoo J. Kim
% $Revision:0.1 $ $Date:2014/10/18 23:43:00$

    if nargin  <= 3
        cauchy = 0;
    end
    


    roiMask=load_nifti(mask);
    roiIdx=find(roiMask.vol(:)>0);
    [ix,iy,iz]=ind2sub(size(roiMask.vol),roiIdx);
    cd(dataroot);
    fileNames=dir(fullfile(dataroot,'*.nii.gz'));
    numSubjs=length(fileNames);
    CauchyTensors=zeros(numSubjs,length(roiIdx),3,3);
    %matlabpool open;
    for subjId=1:numSubjs
        tic;
        fprintf('\nReading %s',fileNames(subjId).name);
        nii=load_nifti(fileNames(subjId).name);
        vol=squeeze(nii.vol);
        %Column ordering.
        parfor r=1:length(roiIdx)
            mat=zeros(3,3);
            vidx=1;
            for row=1:3
                for col=1:3
                    mat(row,col)=vol(ix(r),iy(r),iz(r),vidx);
                    vidx=vidx+1;
                end
            end
            if cauchy
                CauchyTensors(subjId,r,:,:)= sqrtm(mat'*mat);
            else
                CauchyTensors(subjId,r,:,:) = mat;
            end
        end
        fprintf('\nFinished %d/%d in %f sec.',subjId,numSubjs,toc);
    end
    subj_ids = cell(numSubjs,1);
    for isubj = 1:numSubjs
        subj_ids{isubj} = fileNames(isubj).name(1:8);
    end

    disp('numSubjs');
    disp(numSubjs)
    nsubjects = numSubjs;
    mask = [ix, iy, iz];
    numvox = length(ix);
    mxstack = cell(numvox,1);
    %%
    parfor ivox = 1:numvox
        amxstack = zeros(3,3,numSubjs);
        for isubj = 1:numSubjs
            amxstack(:,:,isubj) = squeeze(CauchyTensors(isubj,ivox,:,:));
        end
        mxstack{ivox} = amxstack;
    end

    directory = dataroot;
%    matlabpool close force local;

    save(outputfname,'subj_ids','nsubjects','mask','mxstack','directory','-v7.3');
end

