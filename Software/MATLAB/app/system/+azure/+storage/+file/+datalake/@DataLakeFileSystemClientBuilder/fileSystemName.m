function builder = fileSystemName(obj, fileSystemName)
% FILESYSTEMNAME Sets the name of the file/directory
% If the path name contains special characters, pass in the url encoded version
% of the path name.
% A azure.storage.file.datalake.DataLakeFileSystemClientBuilder is returned.

% Copyright 2022 The MathWorks, Inc.

if ~(ischar(fileSystemName) || isStringScalar(fileSystemName))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid fileSystemName argument');
else
    builderj = obj.Handle.fileSystemName(fileSystemName);
    builder = azure.storage.file.datalake.DataLakeFileSystemClientBuilder(builderj);
end

end