function deleteSubdirectory(obj, subdirectoryName)
% DELETESUBDIRECTORY Deletes the specified sub-directory in the directory
% If the sub-directory doesn't exist or is not empty the operation fails.
% subdirectoryName is provided as a character vector or scalar string.

% Copyright 2022 The MathWorks, Inc.

if ~(ischar(subdirectoryName) || isStringScalar(subdirectoryName))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid subdirectoryName argument');
else
    obj.Handle.deleteSubdirectory(subdirectoryName)
end

end