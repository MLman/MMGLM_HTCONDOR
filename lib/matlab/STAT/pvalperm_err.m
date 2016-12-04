function pvals = pvalperm_err(score ,  distr)
% Score is a column vector
% Distr is a matrix
% Error case

pvals  = sum((score*ones(1, size(distr,2)) > distr),2)/size(distr,2);