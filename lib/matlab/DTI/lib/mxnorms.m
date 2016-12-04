function ns = mxnorms(mxs)
%MXNORMS matrix norms
%    mxs(:,:,1) ... mxs(:,:,N)
%    ns(1) ... ns(N)
%
    ns = zeros(size(mxs,3),1);
    for i = 1:size(mxs,3)
        ns(i) = norm(mxs(:,:,i));
    end
end