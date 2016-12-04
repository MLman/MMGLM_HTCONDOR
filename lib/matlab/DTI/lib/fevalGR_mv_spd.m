function E = fevalGR_mv_spd(p,V,X,P)
% Sum of squared geodesic error.
%
% X is a set of column vectors
%% !! make sure that X is centered if p, V are calculated by centered X !!

ndata = size(X,2);
P_hat = prediction_spd(p,V,X);
E = 0 ;

for i = 1:ndata
    E = E + dist_M_spd(P_hat(:,:,i),P(:,:,i))^2;
end