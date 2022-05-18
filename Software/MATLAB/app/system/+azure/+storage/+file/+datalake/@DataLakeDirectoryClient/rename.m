function dataLakeDirectoryClient = rename(obj, destinationFileSystem, destinationPath)
% RENAME Moves the directory to another location within the file system
% Arguments must be scalar strings or character vectors.
%
% destinationFileSystem is the file system of the destination within the account.
% Use an empty array [] to use the current file system.
%
% destinationPath Relative path from the file system to rename the directory to.
% This excludes the file system name, e.g. to move a directory with:
%    fileSystem = "myfilesystem", path = "mydir/mysubdir"
% to another path in myfilesystem e.g.: newdir then set the destinationPath to "newdir"
%
% A DataLakeDirectoryClient used to interact with the newly created directory is returned.

% Copyright 2022 The MathWorks, Inc.

if ~(ischar(destinationFileSystem) || isStringScalar(destinationFileSystem) || isempty(destinationFileSystem)) || ...
   ~(ischar(destinationPath) || isStringScalar(destinationPath))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid argument');
else
    dataLakeDirectoryClientj = obj.Handle.rename(destinationFileSystem, destinationPath);
    dataLakeDirectoryClient = azure.storage.file.datalake.DataLakeDirectoryClient(dataLakeDirectoryClientj);
end

end