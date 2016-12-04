function csvdata = mergemetadata(csvdata1, csvdata2, oncol1, oncol2, varargin)
%MERGEMETADATA joins two tables (csvdata1, csvdata2) based on oncol1 and oncol2. 
%   
%   CSVDATA  : Metadata
%   CSVDATA1 : Metadata1
%   CSVDATA2 : Metadata2
%   ONCOL1 : Key column of CSVDATA1 for inner join.
%   ONCOL2 : Key column of CSVDATA2 for inner join.
%   COLSFROMCSV1 : Selected columns from CSVDATA1
%   COLSFROMCSV2 : Selected columns from CSVDATA2
%
%
%   Field names (ONCOL1, COLSFROMCSV1,...)  are case insensitive.
%
%   csvdata = mergemetadata(csvdata1, csvdata2, oncol1, oncol2)
%   csvdata = mergemetadata(csvdata1, csvdata2, oncol1, oncol2, COLSFROMCSV1)
%   csvdata = mergemetadata(csvdata1, csvdata2, oncol1, oncol2, COLSFROMCSV1, COLSFROMCSV2)
%
%
%   See Also: JOINTABLE, MERGEIMGNMETA

%   $ Hyunwoo J. Kim $  $ 2015/05/27 15:13:14 (CDT) $

    idxSubjIDmeta1 = find(strcmpi(csvdata1.colnames,oncol1));
    idxSubjIDmeta2 = find(strcmpi(csvdata2.colnames,oncol2));

    if nargin >=5 && ~isempty(varargin{1})
        colsfromCSV1 = varargin{1};
        idxColCSV1 = mystrfindi(colsfromCSV1, csvdata1.colnames);
    else
        colsfromCSV1 = csvdata1.colnames;
        tmp = colsfromCSV1(idxSubjIDmeta1);
        colsfromCSV1(idxSubjIDmeta1) = []; % Permute the column names 
        colsfromCSV1 = [tmp, colsfromCSV1];% Bring the Key column name to the first.
        idxColCSV1 = [];
    end
    
    if nargin >= 6 && ~isempty(varargin{2})
        colsfromCSV2 = varargin{2};
        idxColCSV2 = mystrfindi(colsfromCSV2, csvdata2.colnames);
    else
        colsfromCSV2 = csvdata2.colnames;
        colsfromCSV2(idxSubjIDmeta2) = [];
        idxColCSV2 = [];
    end

    % New column names and new data
    Newcolnames = [colsfromCSV1,colsfromCSV2];
    NewData = jointables(csvdata1.data, csvdata2.data, idxSubjIDmeta1, ...
        idxSubjIDmeta2, idxColCSV1, idxColCSV2);

    % New metadatapath
    %newmetadata = '/data/hdd1/CauchyDeformationTensorProject/Longitudinal_GMVL_amy_20150317_v1.mat';
    csvdata =[];
    csvdata.colnames = Newcolnames;
    csvdata.data = NewData;
    csvdata.fnames = [];
    csvdata.fnames{1} = csvdata1.fname;
    csvdata.fnames{2} = csvdata2.fname;
end

