function mask = getmaskarray(nii_master)
vol = nii_master.vol;
dim = nii_master.dim;
if dim(1) ~= 3
    error('Vol should be a 3 dimensional matrix. Wrong input file');
end

% number of nonzero elements
nnz = sum(sum(sum(nii_master.vol)));

% Row vectors of location of voxel

mask = zeros(nnz,3);
k = 1;
for ix = 1:dim(2)
    for iy = 1:dim(3)
        for iz = 1:dim(4)
            if vol(ix,iy,iz) == 1   
                mask(k,:) = [ix, iy, iz];
                k = k + 1;
            end
        end
    end
end

