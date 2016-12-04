function totalelapsedtime = DTI_condordata_gen_sub(X, szjob, mxstack, mask, outputdir, szsub)
%DTI_CONDORDATA_GEN_SUB generats data for condor or parallel computation.
%
%   Subject ID varification MUSTi be done before this function.
%
%   DTI_CONDORDATA_GEN(X, szjob, mxstack, mask, outputdir)
%
%   See Also: DTI_CONDORDATA_GEN, CSVREAD, IND2SUB, DTI_CONDORDATA_GEN_C_SUB

%   $ Hyunwoo J. Kim $  $ 2015/08/02 15:52:51 (CDT) $

% Navigate data directory
    starttime=clock;
    curdir = pwd;

    X=X';
    Xc =centering(X);
    Xs = scaling(Xc);

    nsubjects = length(subj_ids);

    %% Read Size of Data
    fprintf('%d voxels are masked.\n',size(mask,1));
    ids = partition(size(mask,1),szjob);
    prefix = 'exp_';

    if isdir(outputdir)
        cd(outputdir);
    else
        mkdir(outputdir);
        cd(outputdir);
    end

    subprefix = 'sub_'; % Prefix for subsets.
    nexp = size(ids,1);
    nsub = ceil(nexp/szsub);
    iexp = 1;
    isub = 1;

    while iexp <= nexp
        fprintf('%f\n',isub/nsub);
        expcounter_per_sub = 0;

        % Shell script
        shname = sprintf('run_sub_%d.sh',isub);
        fp = fopen(shname,'w');
        fprintf(fp,'#!/bin/bash\n');
        fprintf(fp,'# Excutable_file_path input_dir output_dir shared_dir\n');

        while iexp <= nexp
            foldername = strcat([subprefix,mat2str(isub),'/',prefix,mat2str(ids(iexp,1))]);
            exp_name = foldername;
            mkdir(foldername);
            indices = ids(iexp,1):ids(iexp,2);
            mask_job = mask(ids(iexp,1):ids(iexp,2),:);
            mxstack_job = mxstack(ids(iexp,1):ids(iexp,2),1);
            Ys = mxstack_job2mx(mxstack_job);
            save(strcat(['./',foldername,'/','Ys_arma.mat']),'Ys','-ascii');
            save(strcat(['./',foldername,'/','mask_job_arma.mat']),'mask_job', '-ascii');

            %Shell script
            input_dir = sprintf('sub_%d/exp_%d',isub,ids(iexp));
            output_dir = ['totalresults/exp_',mat2str(ids(iexp))];
            fprintf(fp,'shared/legr_dti %s %s shared\n',input_dir,output_dir);

            iexp = iexp + 1;
            expcounter_per_sub =  expcounter_per_sub + 1; 
            if expcounter_per_sub >= szsub
                break;
            end 
        end

        fclose(fp); 
        isub = isub + 1;
    end

    foldername = 'shared';
    mkdir(foldername);
    save(strcat(['./',foldername,'/','Xs_arma.mat']),'Xs', '-ascii');
    system(['cp /home/hyunwoo/Workspaces/matlab_mv/legr_dti ','./',foldername]);
    system(['cp /home/hyunwoo/Workspaces/matlab_mv/idx_dti_arma.mat ','./',foldername]);
    system('chmod 755 *.sh');
    cd(curdir);
    fprintf('check data.\n');
    fprintf('cd %s \n',outputdir);
    disp('done')
    endtime = clock;
    totalelapsedtime = etime(endtime,starttime);
end
