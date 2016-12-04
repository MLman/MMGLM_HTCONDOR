%need to fine tune this function

%function totalelapsedtime = DTI_condordata_gen(X,X_part, szjob, mxstack, mask, outputdir)
function totalelapsedtime = DTI_data_gen(X, Z, szjob, mxstack, mask, outputdir)

%DTI_CONDORDATA_GEN generats data for condor or parallel computation. 
%   Subject ID varification MUST be done before this function.
%
%   DTI_CONDORDATA_GEN(X, szjob, mxstack, mask, outputdir)
%
%   See also CSVREAD, IND2SUB

%   $ Hyunwoo J. Kim $  $ 2015/05/29 11:25:57 (CDT) $

    % Navigate data directory
    starttime=clock;
    curdir = pwd;
    X = [X, Z];
    % Covariates are row vectors and centered.
    X=X'; 
    Xc = centering(X);
    Xs = scaling(Xc); % Scaling max(Xs') - min(Xs') = [1, .... 1];
    

%   No longer needed as part of new model
%    X_part=X_part';
%     Xc_part = centering(X_part);
%     Xs_part = scaling(Xc_part);
    
    
    %% Read Size of Data]
    
    fprintf('%d voxels are masked.\n',size(mask,1));
    idx = partition(size(mask,1),szjob);
    prefix = 'exp_';

    if isdir(outputdir)
        cd(outputdir);
    else
        mkdir(outputdir);
        cd(outputdir);
    end

    %Hyunwoo's version
%     for i = 1:size(idx,1)
%         foldername= strcat([prefix,mat2str(idx(i,1))]);
%         mkdir(foldername);
%         mask_job = mask(idx(i,1):idx(i,2),:);
%         mxstack_job = mxstack(idx(i,1):idx(i,2),1);
%         Ys = mxstack_job2mx(mxstack_job);
%         save(strcat(['./',foldername,'/','Ys_arma.mat']),'Ys','-ascii');
%         save(strcat(['./',foldername,'/','mask_job_arma.mat']),'mask_job', '-ascii');
%     end
%     
    
      for i = 1:size(idx,1)
        foldername= int2str(i);
        mkdir(foldername); %simple names being created
        
        mask_job = mask(idx(i,1):idx(i,2),:);
        mxstack_job = mxstack(idx(i,1):idx(i,2),1);
        Ys = mxstack_job2mx(mxstack_job);
        
        
        save(strcat(['./',foldername,'/','Ys_arma.mat']),'Ys','-ascii');
        save(strcat(['./',foldername,'/','mask_job_arma.mat']),'mask_job', '-ascii');
      end
    
      
    foldername = 'shared';
    mkdir(foldername);
    save(strcat(['./',foldername,'/','Xs_arma.mat']),'Xs', '-ascii');
   % save(strcat(['./',foldername,'/','Xs_arma_part.mat']),'Xs_part',
   % '-ascii'); - Not needed anymore in the new model
   
 
    cd(curdir);
    fprintf('check data.\n');
    fprintf('cd %s \n',outputdir);
    disp('done')
    endtime = clock;
    totalelapsedtime = etime(endtime,starttime);
end
%how to integrate this
%!sh main_script.sh
%post this step, main_script.sh is called - make sure connection happens
%well