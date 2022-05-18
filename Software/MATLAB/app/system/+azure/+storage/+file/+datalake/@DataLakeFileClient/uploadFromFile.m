function uploadFromFile(obj, filePath, varargin)
% UPLOADFROMFILE Creates a file with the content of the specified file
% By default, this method will not overwrite an existing file.
% filePath is provided as a character vector or scalar string.

% Copyright 2022 The MathWorks, Inc.

if ~(ischar(filePath) || isStringScalar(filePath))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid filePath argument');
else
    if ~isfile(filePath)
        logObj = Logger.getLogger();
        write(logObj,'error','File not found: %s');
    else
        obj.Handle.uploadFromFile(filePath);
    end
end

end