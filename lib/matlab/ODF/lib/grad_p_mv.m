function gradp = grad_p_mv(p,V,X,P,expmap,logmap)
gradp = zeros(size(p));
ndimX = size(X,1);
for i = 1:ndimX
    gradp = gradp + grad_p(p,V(:,i),X(i,:),P,expmap,logmap);
end