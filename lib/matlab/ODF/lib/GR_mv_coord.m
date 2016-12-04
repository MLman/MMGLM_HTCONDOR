function [p, V, E, gnorm, P_hat] = GR_mv_coord(X,P, varargin)
%Geodesic regression for 3d circle and 1d tangent space
%    X is input variables
%    P is values on manifolds
%
    expmap = @(p,v) cos(norm(v))*p+sin(norm(v))*v/zero2one(norm(v));
    logmap = @(p1,p2) (p2-p1'*p2*p1)/zero2one(sqrt(1-(p1'*p2)^2))*acos(p1'*p2);
    
    ndimX = size(X,1);
    ndimP = size(P,1);

    p = P(:,1);
    V = rand(ndimP,ndimX)*0.1; % Random initialization

    if nargin >=3
        maxiter = varargin{1};
    else
        maxiter = 500;
    end
    % Gradient Descent algorith
    % Step size
    c1 = 0.1;
    
    % Safeguard parameter
    c2 = 0.1;
    
    V = proj_TpM(p,V);

    E = [];
    gnorm = [];
    E = [E; fevalGR_mv(p,V,X,P,expmap,logmap)];
    step = c1;
    for niter=1:maxiter
        % Optimize along V
        for iV = 1:size(V,2)
            % v projection on to tanget space
            gradV = grad_v_mv(p,V,X,P,expmap,logmap);
            gradp = grad_p_mv(p,V,X,P,expmap,logmap);
            gnorm_new = norm([gradV gradp]);
            
            moved = 0;
            for i = 1:100
                step = step*0.5;
                % Safegaurd for gradv, gradp
                V_new = V - step*gradV;
                p_new = unitvec(expmap(p,step*gradp));
                V_new = proj_TpM(p,V_new);

                E_new = fevalGR_mv(p_new, V_new, X, P, expmap, logmap);
                if E(end) > E_new
                    V = V_new;
                    p = p_new;
                    E = [E; E_new];
                    gnorm = [gnorm; gnorm_new];
                    moved = 1;
                    step = step*2;
                    break

                end
            end
            if moved ~= 1
                break
            end
        end
        
        % Optimize along p
        
    end

    E = [E; fevalGR_mv(p,V,X,P,expmap,logmap)];
    P_hat = prediction(p,V,X,expmap);
end

function V = proj_TpM(p,V)
    for i = 1:size(V,2)
        v = V(:,i);
        V(:,i) = v-p'*v*p;
    end
end 

function [gradp gradV] = safegarud(gradp, gradV, c2)
    vecnorms = @(A) sqrt(sum(A.^2,1));
    norms = [ vecnorms(gradV) norm(gradp)];
    maxnorm = max(norms);
    if maxnorm > c2
        gradV = gradV*c2/maxnorm;
        gradp = gradp*c2/maxnorm;
    end
    
end
