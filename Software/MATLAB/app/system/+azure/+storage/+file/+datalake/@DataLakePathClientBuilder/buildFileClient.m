function dataLakeFileClient = buildFileClient(obj)
% BUILDFILECLIENT Creates a DataLakeFileClient based on options set in the builder
% Returns a DataLakeFileClient created from the configurations in this builder.

% Copyright 2022 The MathWorks, Inc.

dataLakeFileClientj = obj.Handle.buildFileClient();
dataLakeFileClient = azure.storage.file.datalake.DataLakeFileClient(dataLakeFileClientj);

end