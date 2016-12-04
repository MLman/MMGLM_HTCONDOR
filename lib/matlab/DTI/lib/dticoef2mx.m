function mx = dticoef2mx(coffvec)
%% DTI coefficients in Barb Data according to Nagesh Info.
%
%    Dxx 1  Dxy 2 Dzx 4
%        2  Dyy 3 Dzy 5
%        4  Dzy5  Dzz 6
%
%    DTICOFF2MX converts DTI coefficients.
%
%    See Also: SPD2VEC, MXSTACK_JOB2MX

    mx = zeros(3);
    mx(1,1) = coffvec(1);
    mx(1,2) = coffvec(2);
    mx(1,3) = coffvec(4);
    mx(2,1) = coffvec(2);
    mx(2,2) = coffvec(3);
    mx(2,3) = coffvec(5);
    mx(3,1) = coffvec(4);
    mx(3,2) = coffvec(5);
    mx(3,3) = coffvec(6);
end