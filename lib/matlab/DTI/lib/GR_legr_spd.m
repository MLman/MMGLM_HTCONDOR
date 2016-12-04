function [p, V, E, Y_hat logY] = GR_legr_spd(X, Y, p, logY, varargin)
%Geodesic regression for 3d circle and 1d tangent space
%    X is input variables
%    Y is values on manifolds. Symmetric positive matrices in Y(:,:,1) ..
%    Y(:,:,N)
%    V is a set of tangent vectors. V(:,:,1) ... V(:,:,ndimX).
% This is for symmetric positive matrices.

    ndimX = size(X,1);
    ndimY = size(Y,1);
    ndata =  size(X,2);
    
    if ndata ~= size(Y,3)
        error('Different number of input variables and response variables')
    end
    
    if nargin >=5
        niter = varargin{1};
    else
        niter = 100;
    end
    if isempty(p);
        p = karcher_mean_spd(Y, [], niter);
    end
    if isempty(logY)
        logY = logmap_vecs_spd(p, Y);
    end
    % xx xy xz yy yz zz
    Xc = X - repmat(mean(X,2),1,ndata);
    Yv = symmx2vec(Y);
    L = Yv/Xc;
    logYv_hat = L*Xc;
    V_hat = vec2symmx(logYv_hat);
    V = vec2symmx(L);
    
    Y_hat = zeros(ndimY,ndimY,ndata);
    for i = 1:ndata
        Y_hat(:,:,i) = expmap_spd(p,V_hat(:,:,i));
        if ~isspd(Y_hat(:,:,i))
            Y_hat(:,:,i) = proj_M_spd(Y_hat(:,:,i));
%            disp('projection')
        end
    end
    E = 0 ;
    for i = 1:ndata
        E = E + dist_M_spd(Y_hat(:,:,i),Y(:,:,i))^2;
    end
end


% function v = symmx2vec(mx)
% %SYMMX2VEC converts matrices MX to vectors V. 
% %   n by n matrices to n(n+1)/2 dimensional vectors.
%     [ nrow ncol ndata ] = size(mx);
%     v = zeros(nrow*(nrow+1)/2,ndata);
%     k =1;
%     for i=1:ncol
%         for j=i:ncol
%             v(k,:) = squeeze(mx(i,j,:))';
%             k = k + 1;
%         end
%     end
% %    v = [ squeeze(mx(1,1,:))'; squeeze(mx(1,2,:))'; squeeze(mx(1,3,:))'; squeeze(mx(2,2,:))';
% %           squeeze(mx(2,3,:))'; squeeze(mx(3,3,:))';];
% end
% 
% function mx = vec2symmx(v)
% %VEC2SYMMX converts vectors V to matrices MX.
% %   n(n+1)/2 dimensional vectors to n by n matrices.
%     [dimv ndata] = size(v);
%     n = (-1 + sqrt(1+8*dimv))/2;
%     mx = zeros(n,n,ndata);
%     k = 1;
%     for i=1:n
%         for j=i:n
%             mx(i,j,:) = v(k,:);
%             if i ~=j
%                 mx(j,i,:) = v(k,:);
%             end
%             k = k + 1;
%         end
%     end
% %       mx = zeros(3,3,ndata);
% %       mx(1,1,:) = v(1,:); %xx
% %       mx(1,2,:) = v(2,:); %xy
% %       mx(2,1,:) = v(2,:);
% %       mx(1,3,:) = v(3,:); %xz
% %       mx(3,1,:) = v(3,:);
% %       mx(2,2,:) = v(4,:); %yy
% %       mx(2,3,:) = v(5,:); %yz
% %       mx(3,2,:) = v(5,:);
% %       mx(3,3,:) = v(6,:); %zz
% end
