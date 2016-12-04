function y = spdlognormpdf(X, M, sig)
%LOGSPDNORMPDF returns probability density of log-normal distribution for
%SPD manifold.
%
%    X : Evaluation point.
%    M : Mean / Anchor point.
%    sig : sigma corresponds to standard deviation.
%
%    Equation 3.8 by Schwartzman's thesis.

%   $ Hyunwoo J. Kim $  $ 2016/08/19 10:56:59 (CDT) $

[U, D] = eig(M);
g = U*sqrt(D);
invg = diag(1./sqrt(diag(D)))*U';
W = invg*X*invg';
J = Jacobi(W);
try
    assert(isfinite(J));
catch
%     disp(['Numerical error in ',mfilename,'.'])
%     J
    y = 0;
    return
end
[U, S] = eig(W);
% q =6, p = 3 
y = J/(sig^6*(2*pi)^3)*exp(-0.5*trace(U*diag(log(diag(S)))*U')^2);