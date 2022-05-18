function fileClient = getFileClient(obj, fileName)
% GETFILECLIENT Create a DataLakeFileClient concatenating fileName to the DataLakeDirectoryClient

% Copyright 2022 The MathWorks, Inc.

if ~(ischar(fileName) || isStringScalar(fileName))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid fileName argument');
else
    fileClientj = obj.Handle.getFileClient(filePath);
    fileClient = azure.storage.file.datalake.DataLakeFileClient(fileClientj);
end

end