function builder = fileSystemName(obj, fileSystemName)
% fileSystemName Sets the name of the file system that contains the path
% If the value null or empty the root file system, $root, will be used.
% An updated builder object is returned.

% Copyright 2022 The MathWorks, Inc.

if ~(ischar(fileSystemName) || isStringScalar(fileSystemName))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid fileSystemName argument');
else
    builderj = obj.Handle.fileSystemName(fileSystemName);
    builder = azure.storage.file.datalake.DataLakePathClientBuilder(builderj);
end

end