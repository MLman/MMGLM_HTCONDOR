% Test script

%   $Hyunwoo J. Kim$  $2014/10/25 12:38:58 (CDT) $

mglmroot = '/home/hyunwoo/Workspaces/matlab_mv';
addpath(fullfile(mglmroot,'/packaging'));
addpath(fullfile(mglmroot,'/PermutationTesting'));
addpath(fullfile(mglmroot,'DTI'));
addpath(fullfile(mglmroot,'DTI/lib'));
addpath(fullfile(mglmroot,'STAT'));
addpath(fullfile(mglmroot,'common'));

t1=clock;
rawresultdir='/data/hdd2/results_raw/';
resultsdir='/data/hdd2/results/';
inputdir = fullfile(rawresultdir,sprintf('small_test'));
outputpath = fullfile(resultsdir,sprintf('small_test.mat'));
[proj, mask, errfiles, nerr] = DTI_perm_integration_c(inputdir);

load('/data/hdd2/results/small_test.mat');
proj
nvox = 70;

assert(size(proj.TotalErrMx,1) == nvox);
assert(size(proj.mask,1) == nvox);
assert(nerr == 2);
% exp_3 and exp_4
errfiles
disp('Integration Done.');
tic;save(outputpath,'proj','-v7.3');toc;
t2 = clock;
elapsedtime = etime(t2,t1)

