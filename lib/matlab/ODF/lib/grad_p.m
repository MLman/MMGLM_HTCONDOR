function gradp = grad_p(p,v,X,P,expmap,logmap)
ndata = length(X);
vnorm = norm(v);
P_hat = prediction(p,v,X,expmap);
gradp = zeros(size(p));
for i=1:ndata
    gradp = gradp + cos(norm(X(i)*vnorm))*logmap(P_hat(:,i),P(:,i));
end
gradp = -gradp;