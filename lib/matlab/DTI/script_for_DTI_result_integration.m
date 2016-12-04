% script for output integration
clear;
close;

%res = {'X1','X11','X2','X21','X3','X31','X5','X51'};
res={'X4','X41'};
for i = 1:length(res)
    inputdir = sprintf('/home/hyunwoo/Workspaces/condor/exp_DTI_%s_res',res{i});
    outputpath = sprintf('./results/DTI_res_%s.mat',res{i});
    DTI_result_integration(inputdir,outputpath);
end