% DEMO Step3
% Run mglm parallely
% You can manually run MGLMs.
%{CONDORROOT}:=/data/hdd1/MGLM_demo
%{CONDORROOT}/condorin/run1$ shared/mglm_dti exp_1 {CONDORROOT}/condorout/run1/totalresults/exp_1 shared &
%{CONDORROOT}/condorin/run1$ shared/mglm_dti exp_11 {CONDORROOT}/condorout/run1/totalresults/exp_11 shared &

%{CONDORROOT}condorin/run2$ shared/mglm_dti exp_1 {CONDORROOT}/condorout/run2/totalresults/exp_1 shared &
%{CONDORROOT}/condorin/run2$ shared/mglm_dti exp_11 {CONDORROOT}/condorout/run2/totalresults/exp_11 shared &

runid = [1, 2];
CONDORROOT='/data/hdd1/MGLM_demo';
curdir = pwd;

for ir =1:length(runid)
    ws = sprintf('%s/condorin/run%d', CONDORROOT, runid(ir));
    cd(ws);
    disp(['cd ',ws])
    expids = dir('exp*');
    for ie=1:length(expids)
        cmd = sprintf('shared/mglm_dti %s %s/condorout/run%d/totalresults/%s shared', expids(ie).name, CONDORROOT, ir, ex        system(cmd);
        disp(cmd)
    end
end
cd(curdir)