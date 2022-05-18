function downloadToFile(obj, filePath, varargin)
% DOWNLOADTOFILE Downloads the entire blob into a file specified by filePath
% To overwrite an existing file use a parameter 'overwrite' and a logical true.
% By default a file is not overwritten.
%
% Example:
%   blobClient.downloadToFile('/mydir/myfile.txt', 'overwrite', true);

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(filePath) || isStringScalar(filePath))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid filePath type');
end

% validString = @(x) ischar(x) || isStringScalar(x);
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'downloadToFile';
addParameter(p,'overwrite', false, @islogical);
% To be extended
parse(p,varargin{:});

if p.Results.overwrite
    obj.Handle.downloadToFile(filePath, p.Results.overwrite);
else
    obj.Handle.downloadToFile(filePath);
end

end