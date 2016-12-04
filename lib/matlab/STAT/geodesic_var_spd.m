function [gvar X_bar]= geodesic_var_spd(X_bar, X)
% GEODESIC_VAR calculates geodesic variance in a tangent
% space at Karcher mean X_bar of X.
% If X_bar is empty then this calculates Karcher mean too. 
maxiter = 100; % This is for Karcher mean.

if isempty(X_bar)
    X_bar = karcher_mean_spd(X,[],maxiter);
end

%V = zeros(size(X));
gvar = 0;
for j = 1:size(X,3)
    xj = X(:,:,j);
    V = logmap_spd(X_bar,xj);
    gvar = gvar + innerprod_TpM_spd(V,V,X_bar);
end

gvar = gvar/size(X,3);