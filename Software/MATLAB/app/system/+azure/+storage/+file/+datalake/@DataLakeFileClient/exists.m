function tf = exists(obj)
% EXISTS Gets if the path this client represents exists in Azure
% This does not guarantee that the path type (file/directory) matches expectations.
% E.g. a DataLakeFileClient representing a path to a datalake directory will
% return true, and vice versa.

% Copyright 2022 The MathWorks, Inc.

tfj = obj.Handle.exists();
tf = tfj.booleanValue();


end