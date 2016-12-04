function missing = batchcopyfiles(srcroot, dstroot, fname, varargin)
%BATCHCOPYFILES copies files from SRCROOT to DSTROOT.
%
%   The directory structures must be same.
%   FNAME is a file name or file name pattern. 
%   Options : oneleveldown, mksubdir
%
%             'oneleveldown'
%             srcroot/sub/exp1   -> dstroot/exp1
%
%             'mksubdir'
%             mkidr  dstroot/exp1
%             srcroot/sub/exp1   -> dstroot/exp1
%
%    See Also: BATCHFTEST

%   $Hyunwoo J. Kim$  $2014/10/25 03:16:20 (CDT) $

    options = varargin_test(varargin);
    options
    oneleveldown = options(1);
    mksubdir = options(2); 

    curdir = pwd;
    cd(srcroot)
    results = regexp(genpath('.'), ':', 'split');

    removeit = zeros(length(results),1);
    for i = 1:length(results)
        if isempty(regexp(results{i},'exp_','ONCE'))
            removeit(i) = 1;
        end
    end
    results(logical(removeit)) = [];
    cd(curdir);

    %% Copy files from A to B
    missing = [];
    for i =1:length(results)
        try
            src = fullfile(srcroot,results{i},fname);
            if oneleveldown == true
                [sub_path exp_path] = fileparts(results{i});
            else 
                exp_path = results{i};
            end

            if mksubdir == 1 && exist(fullfile(dstroot, exp_path)) ~= 1
                system(['mkdir -p "',fullfile(dstroot, exp_path),'"']);
            end
            
            dst = fullfile(dstroot, exp_path,fname);
            res = system(['cp "',src,'" "',dst,'"']);
     
            if res == 1
                id = str2double(exp_path(5:end));
                missing = [missing; id ];
            end
        catch err
            disp(['Err :  ','cp "',src,'" "',dst,'"']);
        end
    end

    if mksubdir == 0
        fprintf('Missing directories %d\n',length(missing));
    end
end

function options = varargin_test(opts)
    options = [0, 0];
    if (~isempty(opts))
        for c=1:length(opts)
            option = lower(opts{c});
            if strcmp(option,'oneleveldown') == 1
                options(1) = 1;
            end
            if strcmp(option,'mksubdir') == 1
                options(2) = 1;
            end
        end % for
    end % if
end
