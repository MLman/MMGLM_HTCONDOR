function mx = cube2mat(cube, elements)
%CUBE2MAT convert stack
nrows = size(elements,1);
ncols = size(cube,3);

mx = zeros(nrows,ncols);

for ipos = 1:nrows
    mx(ipos,:) = cube(elements(ipos,1),elements(ipos,2),:);
end
