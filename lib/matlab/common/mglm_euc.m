function [B, E, Y_hat] = mglm_euc(X, Y)
%MGLM_EUC performs multivariate linear regressions.
%
%   [B, E, Y_hat] = MGLM_EUC(X, Y)
%
%   The outputs are B, E, Y_hat.
%   E is the sum of sqaured errors.
%
%   X is dimX x N column vectors.
%   Y is dimY x N column vectors.%

%   See Also:

%   $ Hyunwoo J. Kim $  $ 2016/08/16 21:33:38 (CDT) $
%   $ Revision: 0.12 $ 
    
    if size(X,2) ~= size(Y,2)
        error('Different number of input variables and response variables')
    end
    
    B = Y*X'/(X*X');
    Y_hat = B*X;
    E = sum(sum((Y_hat-Y).^2));
end
