function builder = endpoint(obj, endpoint)
% ENDPOINT Sets the client endpoint
% The endpoint is also parsed for additional information i.e. the SAS token
% endpoint should be of type character vector or scalar string.
% An updated builder object is returned.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(endpoint) || isStringScalar(endpoint))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid endpoint argument');
else
    builderj = obj.Handle.endpoint(endpoint);
    builder = azure.storage.blob.BlobClientBuilder(builderj);
end

end