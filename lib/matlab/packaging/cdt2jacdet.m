function elapsedtime = cdt2jacdet(imgNmetapath, jdimgNmetapath)
%CDT2JACDET converts a Cauchy deformation tensor imgNmeta file to a jacobin determinant imgNmeta file.
%
%
%   detCDT.imgdata.img = imgdata; % jacdet images
%
%   Additional meta data 
%   detCDT.csvdata = imgNmeta.csvdata; 
%   detCDT.imgdata.mask = imgNmeta.imgdata.mask;
%   detCDT.imgdata.directory = imgNmeta.imgdata.directory;
%   detCDT.imgdata.nsubjects = imgNmeta.imgdata.nsubjects;
%	detCDT.imgdata.subj_ids = imgNmeta.imgdata.subj_ids;
% 
%   See Also:

%   $ Hyunwoo J. Kim $  $ 2015/08/16 21:19:58 (CDT) $

    t1 = clock;
    load(imgNmetapath);
    fprintf('Brain Data Loaded : %s \n', imgNmetapath);
    nsubjects = imgNmeta.imgdata.nsubjects;
    fprintf('nsubjects : %d \n', nsubjects);


    %% Jacdeterminant
    detCDT = zeros(nsubjects, size(imgNmeta.imgdata.mxstack,1));
    nvox = size(imgNmeta.imgdata.mxstack,1)
    for j = 1:nvox
        if mod(j,100)==1
            fprintf('%f (%d/%d)\n',j/nvox*100, j, nvox);
        end
        mxs = imgNmeta.imgdata.mxstack{j};
        for i = 1:nsubjects
            detCDT(i,j) = det(mxs(:,:,i));
        end
    end
    mask = imgNmeta.imgdata.mask;
    subj_ids = imgNmeta.imgdata.subj_ids;
    directory = imgNmeta.imgdata.directory;
    imgdata=detCDT;
    detCDT=[];
    detCDT.csvdata = imgNmeta.csvdata;
    detCDT.imgdata.img = imgdata;
    detCDT.imgdata.mask = imgNmeta.imgdata.mask;
    detCDT.imgdata.directory = imgNmeta.imgdata.directory;
    detCDT.imgdata.nsubjects = imgNmeta.imgdata.nsubjects;
    detCDT.imgdata.subj_ids = imgNmeta.imgdata.subj_ids;
    save(jdimgNmetapath, 'detCDT', 'mask', 'subj_ids', 'directory','-v7.3');
    fprintf('JacDet imgNmeta saved at %s.', jdimgNmetapath);
    t2 = clock;
    elapsedtime = etime(t2,t1);
end

