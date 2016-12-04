function stat=mglm(Y,Z,X)
%
% stat=MGLM(Y,Z, X)
%
% The function fits genearl linear model of the form y=Z*lambda + X*beta 
% and outputs stat. Notations follow the paper [1]. It test the
% significance of beta variable
%
% INPUT
% Y           : response variable of sieze n x m. m is the dimension of Y
% Z           : Matrix of size n x k, where n is the sample size
% X           : Matrix of size n x p.
%
% OUTPUT
% stat.F      : F stat value.
% stat.p      : pvalue
% stat.lambda   : fitted regression parameters of the null model
% stat.gamma  : fitted regression parameters of the full model, 
%               where gamma = (lambda, beta)
%
% EXAMPLE
% If we are fitting the model of the type: thickness = 1 + age + group and
% test for the significance of group variable, let Z= age and X=group. 
%
%
%   See Also: GLM

%   $ Hyunwoo J. Kim $  $ 2015/03/08 17:44:57 (CDT) $
%-----------------------------------------------------------

% The number of parameters
n=size(Y,1);
k=size(Z,2)+1; % Constant
p=size(X,2);

%H_0: null model
%     y = Z*lambda
W=[ones(n,1) Z]; % Constant (intercept) is always added in the model. 
lambda = inv(W'*W)*W'*Y;
SSE0 = sum(sum((Y-(W*lambda)).^2)); %The sum of squared residuals. 

%H_1: full model
%     y = Z*lambda + X*beta

W=[ones(n,1) Z X];
gamma = inv(W'*W)*W'*Y;
SSE1 = sum(sum((Y-(W*gamma)).^2)); %The sum of squared residuals. 

%F stat degress of freedom
stat.degree = [p, n - p- k];

%F stat
stat.F=(SSE0-SSE1)/p./(SSE0/(n-p-k));

%pvalue
stat.p=1-fcdf(stat.F,p,n-p-k);




