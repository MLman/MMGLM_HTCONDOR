function [detnii, mask] = det_nii(inpath, varargin)
%DET_NII calculates determinant from nifti (nii) files.
%
%
%   det_nii(inpath)
%   det_nii(inpath, outpath)
%   det_nii(inpath, outpath, maskpath)
%   det_nii(inpath, outpath, mask)
%
%   See Also: 

%   $ Hyunwoo J. Kim $  $ 2014/11/19 18:37:20 (CST) $

    if isempty(varargin)
        [d, fn, ext] = fileparts(inpath);
        outpath = fullfile(d,[fn,'_det',ext]);
    else
        outpath = varargin{1};
    end
    if length(varargin) == 2 
        if isstruct(varargin{2})
            mask = varargin{2};
            irows = mask.irows;
            icols = mask.icols;
            ipages = mask.ipages;
            mask_idx = mask.mask_idx;
        else
            maskpath = varargin{2};
            mask = load_nifti(maskpath);
        end
    end
    anii = load_nifti(inpath);
    detnii = anii;
    detnii.dim(1) = 3;
    detnii.dim(5:end) = 0;
    detnii.vol = zeros(detnii.dim(2),detnii.dim(3), detnii.dim(4));
    
    if length(varargin) == 2
        if ~isfield(mask,'irows') || ~isfield(mask,'icols') || ~isfield(mask,'ipages')
            mask_idx = find(mask.vol(:) == 1);
            [irows, icols, ipages]=arrayfun(@(i)ind2sub(size(mask.vol),mask_idx(i)),1:length(mask_idx));
            mask.irows = irows;
            mask.icols = icols;
            mask.ipages = ipages;
            mask.mask_idx = mask_idx;
        end
    else
        mask_idx = 1:prod(detnii.dim(2:4));
        [irows, icols, ipages]=arrayfun(@(i)ind2sub(detnii.dim(2:4)',mask_idx(i)),1:length(mask_idx));
    end
    tic;
    for i = 1:length(mask_idx)
        detnii.vol(irows(i), icols(i), ipages(i)) = ...
            det(dticoef2mx(anii.vol(irows(i), icols(i), ipages(i),1,:)));
    end
    toc;
    if nargin >= 2
        fprintf('save : %s\n',outpath);
        save_nifti(detnii, outpath);
    end
end