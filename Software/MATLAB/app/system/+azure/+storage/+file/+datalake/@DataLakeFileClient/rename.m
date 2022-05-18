function dataLakeFileClient = rename(obj, destinationFileSystem, destinationPath)
% RENAME Moves the file to another location within the file system
% Arguments must be scalar strings or character vectors.
%
% destinationFileSystem is the file system of the destination within the account.
% Use a string or character vector of zero length for the current file system.
%
% destinationPath is the relative path from the file system to rename the file to.
% This excludes the file system name, e.g. to move a file with:
%    fileSystem = "myfilesystem", path = "mydir/hello.txt"
% to another path in myfilesystem e.g.: newdir/hi.txt
% then set the destinationPath = "newdir/hi.txt"
%
% A DataLakeFileClient used to interact with the newly created file is returned.

% Copyright 2022 The MathWorks, Inc.

if ~(ischar(destinationFileSystem) || isStringScalar(destinationFileSystem)) || ...
   ~(ischar(destinationPath) || isStringScalar(destinationPath))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid argument');
else
    dataLakeFileClientj = obj.Handle.rename(destinationFileSystem, destinationPath);
    dataLakeFileClient = azure.storage.file.datalake.DataLakeFileClient(dataLakeFileClientj);
end

end