function [p, V, E, Y_hat, U] = GR_logeuc(X,Y,varargin)
%GR_LOGEUC is logeuclidean geodesic regression. 
%    X input variable in Euclidean space.
%    Y output variable on Sphere
%    p is a base point for tangent space.
%    V is a set of tangent vectors. Column vectors
%    E is geodesic error.
%    Y_hat is prediction
%    U orthogonal bases of the tangent space

if nargin >=3
    niter = varargin{1};
else
    niter = 500;
end
% Linear transform

[ ndim ndata] = size(X);
Xc = X - repmat(mean(X,2),1,ndata);
p = karcher_mean(Y, ones(ndata,1)/ndata, niter);
logY = logmap_vecs(p, Y);
 % Get orthogonal bases
U = null(ones(size(p,1),1)*p');


Yu = U'*logY; %logY is represented by U
% Yu = L*X
L = Yu/Xc;
V = U*L;
logY_hat = V*Xc;
Y_hat = expmap_vecs(p,logY_hat);
E = geodesic_squred_error(Y, Y_hat, @logmap);