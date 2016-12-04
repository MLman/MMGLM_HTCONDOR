addpath ../common

% %% For real data
Xmask_sorted = p32.roi_voxel_indices;
XTotalErrMx_sorted = p32.TotalErrMxSorted;
XModel = p32.ourErr;
%XTotalErrMx = XTotalErrMx(:,2:end);

Xcmask_sorted = p38.roi_voxel_indices;
XcTotalErrMx_sorted = p38.TotalErrMxSorted;
XcModel = p38.ourErr;
%XcTotalErrMx = XcTotalErrMx(:,2:end);
% % 
% % clear p44 p45
% %
% [Xmask_sorted Xidx] = sortrows(Xmask);
% XTotalErrMx_sorted = XTotalErrMx(Xidx,:);
% XModel = XModel(Xidx,:);
% clear Xidx XTotalErrMx Xmask
% [Xcmask_sorted Xcidx] = sortrows(Xcmask);
% XcTotalErrMx_sorted = XcTotalErrMx(Xcidx,:);
% XcModel = XcModel(Xcidx,:);
% clear Xcidx XcTotalErrMx Xcmask
% 
% %% Debugging
% % XModel = XModel(1:10);
% % XcModel = XcModel(1:10);
% % Xmask_sorted = Xmask_sorted(1:10,:);
% % Xcmask_sorted = Xcmask_sorted(1:10,:);
% %XTotalErrMx_sorted =  XTotalErrMx_sorted(1:10,:);
% %XcTotalErrMx_sorted =  XcTotalErrMx_sorted(1:10,:);
% 
% % % Reproduce Error
% % XTotalErrMx_sorted(3,:)=[];
% % XModel(3,:) = [];
% % Xmask_sorted(3,:) = [];
% % Xmask_sorted = [Xmask_sorted; [0 0 0] ];
% % XModel = [ XModel;0];
% % XTotalErrMx_sorted=[XTotalErrMx_sorted;zeros(1,20000)];


%% Data Ready
fm = zeros(size(Xmask_sorted,1),1);
pos = zeros(size(Xmask_sorted,1),3);
pvals = zeros(size(Xmask_sorted,1),1);

iXc = 1;
nentry = 1;
%% For test
fdistrmx = zeros(1000,20000);
for iX = 1:1000 %size(Xmask_sorted,1)
    if iX > size(Xmask_sorted,1) || iXc > size(Xcmask_sorted,1) 
        break
    end
%    fprintf('1 : %s %s\n',mat2str(iX),mat2str(iXc));
    
%    X_cmp_Xc = comparearray(Xmask_sorted(iX,:), Xcmask_sorted(iXc,:));

%     if  X_cmp_Xc < 0 
%         disp('here')
%         iX
%         continue
%     else
%         while comparearray(Xmask_sorted(iX,:), Xcmask_sorted(iXc,:)) > 0
%             iXc = iXc+1;
%             disp('here2')
%             iXc
%         end
%     end
    if comparearray(Xmask_sorted(iX,:), Xcmask_sorted(iXc,:)) == 0
%        fprintf('2 : %s %s\n',mat2str(iX),mat2str(iXc));
        fm(nentry) = myfstat(XcModel(iXc), XModel(iX), 2,3,343);
        fdistr = myfstat(XcTotalErrMx_sorted(iXc,:), XTotalErrMx_sorted(iX,:), 2,3,343);
        %% For test
        fdistrmx(nentry,:) = fdistr ;
        
        pvals(nentry) = pvalperm_fstat(fm(nentry) ,  fdistr);
        pos(nentry,:) = Xmask_sorted(iX,:);
        
        nentry = nentry + 1;
        iXc = iXc + 1;

    end
end

%% Write files
addpath(dlist.my_mrtrix)
base_nii=load_nifti(dlist.niibase_dti);
base_nii.vol=zeros(base_nii.dim(2),base_nii.dim(3),base_nii.dim(4));

for i = 1:size(pos,1)
    if sum(pos(i,:) ==0) > 0 
        continue;
    end
    base_nii.vol(pos(i,1), pos(i,2), pos(i,3)) = 1-pvals(i);
end
save_nifti(base_nii,sprintf('%s/%s.nii',dlist.nii_odf,'proj32_proj38_age_odf'));