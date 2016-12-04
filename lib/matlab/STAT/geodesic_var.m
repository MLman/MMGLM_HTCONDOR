function gvar = geodesic_var(X_bar, X)
% GEODESIC_VAR calculates geodesic variance in a tangent
% space at Karcher mean X_bar of X.
% If X_bar is empty then this calculates Karcher mean too. 
maxiter = 100; % This is for Karcher mean.

if isempty(X_bar)
    X_bar = karcher_mean(X,[],maxiter);
end

V = zeros(size(X));
for j = 1:size(X,2)
    xj = X(:,j);
    V(:,j) = logmap(X_bar,xj);
end
gvar = trace(V'*V);
gvar = gvar/size(X,2);