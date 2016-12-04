function [p fs df1 df2] = ftest(chi1, chi2, np1,np2, n)
%FTEST returns p value of statistics.
%
%    FTEST tests based on Gaussian assumption using a parametric model. 
%    n is number of subject.
%    chi1 is RSS of control
%    chi2 is RSS of data
%    np1  is dimensional of control
%    np2  is dimension of data
%
%    Requirement
%    np2 > np1
%
%

%   $Hyunwoo J. Kim$  $2014/10/25 22:26:40 (CDT) $

%df1 = np2 - np1;
%df2 = n - np2;

%fs = df2*(chi1-chi2)./(df1*chi2);
[fs df1 df2 ]= myfstat(chi1,chi2,np1,np2,n);

p = 1 - fcdf(fs, df1, df2);
