function dataLakeFileSystemClient = buildClient(obj)
% BUILDFILESYSTEMCLIENT Creates a DataLakeFileSystemClient based on the builder
% Returns a DataLakeFileSystemClient created from the configurations in this builder.

% Copyright 2022 The MathWorks, Inc.

dataLakeFileSystemClientj = obj.Handle.buildClient();
dataLakeFileSystemClient = azure.storage.file.datalake.DataLakeFileSystemClient(dataLakeFileSystemClientj);

end