function Xc = centering(X,varargin)
%CENTERING make the mean of X equal to zeros along one dimension.
%
%   Xc = centering(X)    % By default, X is assumed to be row vectors
%   Xc = centering(X,1)  % For row vectors
%   Xc = centering(X,2)  % For column vectors
%
%
%   See Also:

%   $ Hyunwoo J. Kim $  $ 2015/10/14 23:05:50 (CDT) $

    if nargin == 2 && varargin{1} == 1
        Xm = mean(X,1);
        Xc = X - repmat(Xm,size(X,1),1);
    else
        Xm = mean(X,2);
        Xc = X - repmat(Xm,1,size(X,2));
    end
end