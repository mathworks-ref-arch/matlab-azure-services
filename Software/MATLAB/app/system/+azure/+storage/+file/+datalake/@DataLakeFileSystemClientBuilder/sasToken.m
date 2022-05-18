function builder = sasToken(obj, sasToken)
% SASTOKEN Sets the SAS token used to authorize requests sent to the service
% This string should only be the query parameters (with or without a leading
% '?') and not a full url.
% An updated builder is returned.

% Copyright 2022 The MathWorks, Inc.

if ~(ischar(sasToken) || isStringScalar(sasToken))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid sasToken argument');
else
    builderj = obj.Handle.sasToken(sasToken);
    builder = azure.storage.file.datalake.DataLakeFileSystemClientBuilder(builderj);
end

end