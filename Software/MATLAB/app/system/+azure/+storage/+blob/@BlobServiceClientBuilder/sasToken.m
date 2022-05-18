function builder = sasToken(obj, sasToken)
% SASTOKEN Sets the SAS token used to authorize requests
% sasToken should be of type character vector or scalar string.
% An updated builder object is returned.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(sasToken) || isStringScalar(sasToken))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid sasToken argument');
else
    builderj = obj.Handle.sasToken(sasToken);
    builder = azure.storage.blob.BlobServiceClientBuilder(builderj);
end

end