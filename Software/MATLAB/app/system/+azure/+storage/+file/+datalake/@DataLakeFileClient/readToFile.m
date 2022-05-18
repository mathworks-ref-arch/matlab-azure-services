function pathProperty = readToFile(obj, varargin)
% READTOFILE Reads the entire file into a file specified by the path
% By default a file will not be overwritten and if the file already exists a 
% FileAlreadyExistsException Java will be thrown. A logical overwrite flag
% can be optionally provided.
% An azure.storage.file.datalake.models.PathProperties is returned.

% Copyright 2022 The MathWorks, Inc.

validString = @(x) ischar(x) || isStringScalar(x);

p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'readToFile';
p.addRequired('filePath','',validString);
p.addOptional('overwrite',false,@islogical);
p.parse(varargin{:});

pathProperty = obj.Handle.readToFile(p.Results.filePath, p.Results.overwrite);

end