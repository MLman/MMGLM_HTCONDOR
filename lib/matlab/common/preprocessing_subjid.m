function newsubjids = preprocessing_subjid(subjids)
%PREPROCESSING_SUBJID
%
%
%   See Also: NCHARSTR, MERGEMETADATA

%   $ Hyunwoo J. Kim $  $ 2015/05/27 15:30:48 (CDT) $
    newsubjids = cell(size(subjids));
    for i = 1:length(subjids)
        tokens = strsplit(subjids{i},'_');
        newsubjids{i} = tokens{1};
    end
end