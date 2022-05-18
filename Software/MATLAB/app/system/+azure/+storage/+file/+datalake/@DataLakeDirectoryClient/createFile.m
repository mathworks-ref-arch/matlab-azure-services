function dataLakeFileClient = createFile(obj, varargin)
% CREATEFILE Creates a new file within a directory
% By default, this method will not overwrite an existing file.
% To enable overwrite set an overwrite argument to true.
% A azure.storage.file.datalake.DataLakeDirectoryClient is returned.

% Copyright 2022 The MathWorks, Inc.

validString = @(x) ischar(x) || isStringScalar(x);

p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'createFile';
p.addRequired('fileName',validString);
p.addOptional('overwrite',false,@islogical);
p.parse(varargin{:});

dataLakeFileClientj = obj.Handle.createFile(p.Results.fileName, p.Results.overwrite);
dataLakeFileClient = azure.storage.file.datalake.DataLakeFileClient(dataLakeFileClientj);

end