function gradv = grad_v_mv(p,v,X,P,expmap,logmap)
% Gradient is also in ambient space.
gradv = zeros(size(p));
ndata = length(X);
vnorm = norm(v);
% V is parallel translated v to each tangent space at each prediction.
V = zeros(size(p,1),ndata);

for i = 1:ndata
    V(:,i) = paralleltranslate(p,X(i),v);
end
uV = unitvec(V);
Phat = prediction(p,v,X,expmap);

for i = 1:ndata
    mu = logmap(Phat(:,i),P(:,i));
    Ep = uV(:,i)'*mu;
    gradv = gradv  + X(i)*sin(X(i)*vnorm)*Ep*Phat(:,i);
    mu_p = Ep*uV(:,i);
    gradv = gradv  + X(i)*cos(X(i)*vnorm)*mu_p;
    mu_o = mu - mu_p;
    gradv = gradv  + sin(X(i)*vnorm)/vnorm * mu_o;
    
end
gradv = - gradv;


