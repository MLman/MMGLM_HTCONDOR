function r2  = r2stat(Y_bar, Y, Y_hat, logfunc)
%R2STAT calculates R2statistics.
%
%    r2  = r2stat(Y_bar, Y, Y_hat, logfunc)
%
%    Example:
%        
%        Y_bar = karcher_mean(Y,[],1000);
%        r2  = r2stat(Y_bar, Y, Y_hat, logmap);
gvar = geodesic_var(Y_bar, Y, logfunc);
uvar = unexplained_var(Y, Y_hat, logfunc);
r2 = 1-uvar/gvar;
