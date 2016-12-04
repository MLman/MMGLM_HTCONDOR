% Script for data generation for CONDOR ODF experiments

datapath = '/home/hyunwoo/Workspaces/data/ODF_cvpr2013/NCCAM_WM_2x2x2_spatially_normalized_data_v1.mat';
metadata = '/home/hyunwoo/Workspaces/data/ODF_cvpr2013/non_imaging_csv_nccam.mat';
outputdir_template ='/home/hyunwoo/Workspaces/data/ODF_%s_condor_cvpr2013_logeuc';


%Varnames={'X6','X7','X8'};
Varnames={'X7'};
for i = 1:length(Varnames)
    Xin = Varnames{i};
    outputdir = sprintf(outputdir_template,Xin);
    szjob = 15;
    totalelapsedtime = ODF_condordata_gen(Xin, szjob, datapath,metadata,outputdir);
end