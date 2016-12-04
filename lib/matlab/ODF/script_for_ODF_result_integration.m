% script for output integration
clear;
close;
ncoeff = 15;
res = {'X1','X11','X2','X21','X3','X31','X4','X41','X5','X51'};
for i = 1:length(res)
    inputdir = sprintf('/home/hyunwoo/Workspaces/condor/ODF_%s_condor_cvpr2013_res',res{i});
    outputpath = sprintf('./results/ODF_res_%s.mat',res{i});
    ODF_result_integration(inputdir,outputpath,ncoeff);
end