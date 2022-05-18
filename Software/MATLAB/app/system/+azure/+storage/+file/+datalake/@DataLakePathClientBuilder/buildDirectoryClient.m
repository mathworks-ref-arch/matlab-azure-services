function dataLakeDirectoryClient = buildDirectoryClient(obj)
% BUILDDIRECTORYCLIENT Creates a DataLakeDirectoryClient based on the builder
% Returns a buildDirectoryClient created from the configurations in this builder.

% Copyright 2022 The MathWorks, Inc.

dataLakeDirectoryClientj = obj.Handle.buildDirectoryClient();
dataLakeDirectoryClient = azure.storage.file.datalake.DataLakeDirectoryClient(dataLakeDirectoryClientj);

end