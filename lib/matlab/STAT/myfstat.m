function [fs df1 df2]= myfstat(chi1,chi2,np1,np2,n)
%MYFSTAT returns fstat for p-value.
%
%    n is number of subject.
%    chi1 is RSS of control (limited model).
%    chi2 is RSS of data (full model).
%    np1  is dimensional of control (limited model).
%    np2  is dimension of data (full model).
%
%    Requirement
%    np2 > np1
%

%   $Hyunwoo J. Kim$  $2014/10/25 22:28:25 (CDT) $
df1 = np2 - np1;
df2 = n - np2;
fs = df2*(chi1-chi2)./(df1*chi2);
