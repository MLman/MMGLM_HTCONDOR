%script for R2 statistics
matlabpool 4
gvar = zeros(length(mxstack),1);
parfor i =1:length(mxstack)
    gvar(i) = geodesic_var_spd([],mxstack{i});
end
matlabpool close