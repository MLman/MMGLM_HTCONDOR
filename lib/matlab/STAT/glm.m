function stat=glm(y,Z,X)
%
% stat=GLM(y,Z, X)
%
% The function fits genearl linear model of the form y=Z*lambda + X*beta 
% and outputs stat. Notations follow the paper [1]. It test the
% significance of beta variable
%
% INPUT
% y           : response variable of sieze n x m. m is the number of voxels/vertices
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
% (C) Moo K. Chung
%  email://mkchung@wisc.edu
%  Department of Biostatisics and Medical Informatics
%  University of Wisconsin, Madison
%
%  The code was downloaed from
%  http://brainimaging.waisman.wisc.edu/~chung/glm
%  If you are using the code, please reference the following paper
%  
%  [1] Chung, M.K., Dalton, K.M., Alexander, A.L., Davidson, R.J. 2004.
%      Less white matter concentration in autism: 2D Voxel-Based 
%      Morphometry. NeuroImage 23:242-251.
%-----------------------------------------------------------

% The number of parameters
n=size(y,1);
k=size(Z,2)+1; % Constant
p=size(X,2);

%H_0: null model
%     y = Z*lambda
W=[ones(n,1) Z]; % Constant (intercept) is always added in the model. 
lambda = inv(W'*W)*W'*y;
SSE0 = sum((y-(W*lambda)).^2); %The sum of squared residuals. 

%H_1: full model
%     y = Z*lambda + X*beta

W=[ones(n,1) Z X];
gamma = inv(W'*W)*W'*y;
SSE1 = sum((y-(W*gamma)).^2); %The sum of squared residuals. 

%F stat degress of freedom
stat.degree = [p, n - p- k];

%F stat
stat.F=(SSE0-SSE1)/p./(SSE0/(n-p-k));

%pvalue
stat.p=1-fcdf(stat.F,p,n-p-k);




