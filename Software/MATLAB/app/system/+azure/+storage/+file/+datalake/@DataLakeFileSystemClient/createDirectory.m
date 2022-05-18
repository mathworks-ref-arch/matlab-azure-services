function dataLakeDirectoryClient = createDirectory(obj, varargin)
% CREATEDIRECTORY Creates a new directory within a file system
% By default, this method will not overwrite an existing directory.
% To enable overwrite set an overwrite argument to true.
% A azure.storage.file.datalake.DataLakeDirectoryClient is returned.

% Copyright 2022 The MathWorks, Inc.

validString = @(x) ischar(x) || isStringScalar(x);

p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'createDirectory';
p.addRequired('directoryName',validString);
p.addOptional('overwrite',false,@islogical);
p.parse(varargin{:});

dataLakeDirectoryClientj = obj.Handle.createDirectory(p.Results.directoryName, p.Results.overwrite);
dataLakeDirectoryClient = azure.storage.file.datalake.DataLakeDirectoryClient(dataLakeDirectoryClientj);

end