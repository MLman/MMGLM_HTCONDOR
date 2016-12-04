function [p, V, E, gnorm, Y_hat, b] = GR_linerr_input(X, Y, varargin)
%GR_LINERR_INPUT solves Geodesic Regression for 3d circle and 1d tangent space
%
%    y_hat = EXP(p,V(x-b)) is a geodesic model.
%
%    X is input variables.
%    Y is manifold-valued response variable.
%    b is offset for x.
%    p is a base point. 
%    
    expmap = @(p,v) cos(norm(v))*p+sin(norm(v))*v/zero2one(norm(v));
    logmap = @(p1,p2) (p2-p1'*p2*p1)/zero2one(sqrt(1-(p1'*p2)^2))*zero2one(acos(p1'*p2));
    
    ndimX = size(X,1);
    ndimY = size(Y,1);

    p = Y(:,1);
    V = rand(ndimY,ndimX)*0.1; % Random initialization

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
    
    % Initialization
    V = proj_TpM(p,V);
    b = zeros(size(X,1),1);
    E = [];
    gnorm = [];
    E = [E; fevalGR_mv(p,V,X,Y,expmap,logmap)];
    step = c1;
    Xb = X - b*ones(1,size(X,2));
    min_step = 1e-20;    
    step_even = c1;
    step_odd = c1;

    moved_even = 1;
    moved_odd = 1;
    
    for niter=1:(maxiter*2)

        Y_hat = prediction(p,V,Xb,expmap);
        J = logmap_vec(Y_hat,Y);
        err_TpM = paralleltranslateAtoB(Y_hat, p, J, logmap);
        gradp = -sum(err_TpM,2);
        
        % v projection on to tanget space
        gradV = zeros(size(V));
        gradb = zeros(size(b,1),1);
        for iV = 1:size(V,2)
            gradV(:,iV) = -err_TpM*Xb(iV,:)';
            gradb(iV,:) = -V(:,iV)'*gradp;
        end
        gnorm_new = norm([gradV gradp]) + norm(gradb);
        
        % Safegaurd
        if  mod(niter,2)
            step = step_even;
            moved_even = 0;
            gradb = 0;
            [gradp gradV gradb] = safegarud(gradp, gradV, gradb, c2);
        else
            moved_odd = 0;
            step = step_odd;
            gradV = zeros(size(V));
            gradp = zeros(size(gradp));
            [gradp gradV gradb] = safegarud(gradp, gradV, gradb, c2);
        end
        
        
        for i = 1:200
            step = step*0.5;

            if step  < min_step
                break
            end
            
            % Safegaurd for gradv, gradp
            V_new = V -step*gradV;
            p_new = unitvec(expmap(p,-step*gradp));
            V_new = paralleltranslateAtoB(p,p_new,V_new,logmap);
            V_new = proj_TpM(p_new,V_new); % To be safe
            b_new = b  - step*gradb;
            Xb_new = X - b_new*ones(1,size(X,2));
            E_new = fevalGR_mv(p_new, V_new, Xb_new, Y, expmap, logmap);
            if E(end) > E_new
                p = p_new;
                V = proj_TpM(p,V_new);
                b = b_new;
                Xb = Xb_new;
                E = [E; E_new];
                gnorm = [gnorm; gnorm_new];

                if mod(niter,2)
                    moved_even = 1;
                    step_even = step*2;
                else
                    moved_odd = 1;
                    step_odd = step*2;
                end
                break
            end
        end
  
        if mod(niter,2)
            step_even = min(step*2,0.01*c1);
        else
            step_odd = min(step*2,0.1*c1);
        end
        
        if moved_odd ~= 1 && moved_even ~= 1
            break
        end
    end

    E = [E; fevalGR_mv(p,V,Xb,Y,expmap,logmap)];
    Y_hat = prediction(p,V,Xb,expmap);
end

function V = proj_TpM(p,V)
    for i = 1:size(V,2)
        v = V(:,i);
        V(:,i) = v-p'*v*p;
    end
end 
function eb = logmap_vec(Y_hat,Y)
    eb = zeros(size(Y_hat));
    for i = 1:size(Y_hat,2)
        eb(:,i) = logmap(Y_hat(:,i),Y(:,i));
    end
end
function v12 = logmap(p1,p2)
    v12 = (p2-p1'*p2*p1)/zero2one(sqrt(1-(p1'*p2)^2))*zero2one(acos(p1'*p2));
end

function [gradp gradV gradb] = safegarud(gradp, gradV, gradb, c2)
    vecnorms = @(A) sqrt(sum(A.^2,1));
    norms = [ vecnorms(gradV) norm(gradp) norm(gradb)];
    maxnorm = max(norms);
    if maxnorm > c2
        gradV = gradV*c2/maxnorm;
        gradp = gradp*c2/maxnorm;
        gradb = gradb*c2/maxnorm;
    end
end
