% Script for Y hat
% Load Y
datapath = '/home/hyunwoo/Workspaces/data/DTI_mat_cvpr2013/DTI_masked_data.mat';
GroundTruth = load(datapath);

%% Load X
tic
Erreuc = zeros(length(mxstack),1);
%result = load('DTI_res_X11');

for i = 1:length(mxstack)
    if mod(i,100) ==0
        i
    end
    Y = mxstack{i};
    Yhat = prediction_spd(results.P(:,:,i),results.V(:,:,1,:),Xs,@expmap_spd);
    for k =1:length(Y)
        Erreuc(i) = Erreuc(i) + sum(sum((Y(:,:,k)-Yhat(:,:,k)).^2));
    end
end
toc;