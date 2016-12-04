function S = weightedsum_mx(mx, w)
%WEIGHTEDSUM_MX sums matrices with weight w.
%
%    mx is matrices.
%    w is weights for matrices. w is a column vector.
w = reshape(w,[1 1 length(w)]);
w = repmat(w, [size(mx,1) size(mx,2) 1]);
S = sum(mx.*w,3);