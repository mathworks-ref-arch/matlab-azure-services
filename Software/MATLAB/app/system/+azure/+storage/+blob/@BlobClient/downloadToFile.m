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

% Check whether file exists, if so throw an error if overwrite not set such that
% all other code below can then simply just always assume overwriting is fine.
if isfile(filePath) && ~p.Results.overwrite
    logObj = Logger.getLogger();
    write(logObj,'error','File already exists and overwrite is set to false.');
end

% Determine the parent directory of where to save the file
[d,f,e] = fileparts(filePath);
% Get attributes of this directory
[status,info] = fileattrib(d);
% If this location does not exist, throw an error
if status == false
    logObj = Logger.getLogger();
    write(logObj,'error',sprintf('Specified download location "%s" does not exist.',d));
end    

% Form file name based on absolute location of directory with filename and
% extension appended
absPath = fullfile(info.Name,[f e]);

% Now call Java downloadToFile with absolute path and overwrite simply always
% set to true.
obj.Handle.downloadToFile(absPath, true);

end