% DTI Main script for DTI experiments
header_dti;

%% Data generation.

Xin = 'X7'; proj_id = 43; szjob = 10;
outputdir_template = sprintf('%s/project%s',condor_data_dir,mat2str(proj_id));
outputdir = sprintf(outputdir_template, Xin);
totalelapsedtime = DTI_condordata_gen(Xin, szjob, datapath,metadata,outputdir);
