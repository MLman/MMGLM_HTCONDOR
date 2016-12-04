function gradV = grad_v_mv(p,V,X,P,expmap,logmap)
%Gradient is also in ambient space.
    gradV = zeros(size(V));
    ndimX = size(X,1);
    for i = 1:ndimX
        gradV(:,i) = grad_v(p,V(:,i),X(i,:),P,expmap,logmap);
    end
end
