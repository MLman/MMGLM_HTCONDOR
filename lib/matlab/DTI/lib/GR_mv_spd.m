function [p, V, E, gnorm, Y_hat] = GR_mv_spd(X, Y, varargin)
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

    p = Y(:,:,1); % Karcer mean can be good option for fast convergence
    
    V = zeros([ndimY ndimY ndimX]);
    for i=1:ndimX
        tmp = rand(ndimY)*0.1; % Random initialization
        V(:,:,i) = (tmp+tmp')/2; % Small 
    end

    if nargin >=3
        maxiter = varargin{1};
    else
        maxiter = 5000;
    end
    % Gradient Descent algorith
    % Step size
    c1 = 1;
    
    % Safeguard parameter
    c2 = 1;
    
    V = proj_TpM_spd(p,V);

    E = [];
    gnorm = [];
    E = [E; fevalGR_mv_spd(p,V,X,Y,@expmap_spd,@logmap_spd)];
    step = c1;
    for niter=1:maxiter
        Y_hat = prediction_spd(p,V,X,@expmap_spd);
        J = logmap_vecs_spd(Y_hat, Y);
        if ~issym(J) 
            niter
            J
        end
        
        err_TpM = paralleltranslateAtoB_spd(Y_hat, p, J);
        if ~issym(err_TpM)
            niter
            err_TpM
        end
        
        gradp = -sum(err_TpM,3);
        
        % v projection on to tanget space
        gradV = zeros(size(V));
        % Matrix multiplicaton
        for iV = 1:size(V,3)
            gradV(:,:,iV) = -weightedsum_mx(err_TpM,X(iV,:));
        end
        
        ns = normVs(p,gradV);
        normgradv = sum(ns);
        
        ns = normVs(p,gradp);
        normgradp = sum(ns);

        gnorm_new = normgradp+normgradv;
        if ~isreal(gnorm_new)
            disp('here');
        end

        % Safegaurd
        [gradp gradV] = safeguard(gradp, gradV, p, c2);
        
        moved = 0;
        for i = 1:200
            step = step*0.5;
            % Safegaurd for gradv, gradp
            V_new = V -step*gradV;
            p_new = expmap_spd(p,-step*gradp);
            if ~isspd(p_new)
                p_new = proj_M_spd(p_new);
            end
            V_new = paralleltranslateAtoB_spd(p,p_new,V_new);
            %V_new = proj_TpM(p_new,V_new);
            E_new = fevalGR_mv_spd(p_new, V_new, X, Y, @expmap_spd, @logmap_spd);
            
            if E(end) > E_new
                p = p_new;
                V = proj_TpM_spd(p,V_new);
                E = [E; E_new];
                if ~isreal(gnorm_new)
                    disp(p)
                    disp(V_new)
                end
                gnorm = [gnorm; gnorm_new];
                moved = 1;
                step = step*2;
                break
            end
        end
        if moved ~= 1 || gnorm(end) < 1e-10
            break
        end
    end

    E = [E; fevalGR_mv_spd(p,V,X,Y,@expmap_spd,@logmap_spd)];
    Y_hat = prediction_spd(p,V,X,@expmap_spd);
end
%%
function [T S] = issym(mx)
    tol = 0.00001;
    S = zeros(size(mx,3),1);
    for i = 1:size(mx,3)
        S(i) = (sum(sum(abs(mx(:,:,i)-mx(:,:,i)'))) < tol);
    end
    T = (sum(S) == size(mx,3));
end

function TF = isspd(mx)
    TF = (sum(eig(mx) <=0) == 0);
end
function ns = normVs(p,V)
    for i =1:size(V,3)
        ns(i,1) = norm_TpM_spd(p,V(:,:,i));
    end
end

%%  For symmetric positive definite matrix
function V = proj_TpM_spd(p,V)
    for i = 1:size(V,3)
        V(:,:,i) = (V(:,:,i)+V(:,:,i)')/2;
    end
end 

%% Let's think about safegaurd
function [gradp gradV] = safeguard(gradp, gradV, p, c2)
    ns = normVs(p,gradV);
    normgradv = sum(ns);
    ns = normVs(p,gradp);
    normgradp = sum(ns);
    norms = [ normgradp normgradv];
    maxnorm = max(norms);
    if maxnorm > c2
        gradV = gradV*c2/maxnorm;
        gradp = gradp*c2/maxnorm;
    end
end
