function imgNmeta = mergeimgNmeta(imgdata, csvdata, icolsubjIDinCSV)
%MERGEIMGNMETA merge imgdata and csvdata.
%   
%   Imgdata is a structure.
%   imgdata = 
%     directory: '/data/hdd1/CauchyDeformationTensorProject/NewDataFeb201...'
%          mask: [15455x3 double]
%      maskpath: '/data/hdd1/CauchyDeformationTensorProject/NewDataFeb201...'
%       mxstack: {15455x1 cell}
%     nsubjects: 243
%      subj_ids: {243x1 cell}
%
%
%   csvdata = 
% 
%     colnames: {1x26 cell}
%         data: {124x26 cell}
%       fnames: {1x2 cell}
%
%   See Also: MERGEMETADATA, JOINTABLE

%   $ Hyunwoo J. Kim $  $ 2015/05/29 14:15:02 (CDT) $

    % Intersection
    [~, ia, ib] = intersect(imgdata.subj_ids, csvdata.data(:,icolsubjIDinCSV));

    % imgNmetadata / ReadyToCookData
    imgdata.subj_ids = imgdata.subj_ids(ia);
    imgdata.nsubjects = length(imgdata.subj_ids);
    
    % cellfun(@(c)c(:,:,ia),mxstack,'UniformOutput',false)
    imgdata.mxstack = exsubjsfromcarray(imgdata.mxstack, ia);
    csvdata.data = csvdata.data(ib,:);
    imgNmeta = [];
    imgNmeta.imgdata = imgdata;
    imgNmeta.csvdata = csvdata;
end