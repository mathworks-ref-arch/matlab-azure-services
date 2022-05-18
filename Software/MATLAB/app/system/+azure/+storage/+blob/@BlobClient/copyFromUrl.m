function copyId = copyFromUrl(obj, copySource,varargin)
% COPYFROMURL Copies the data at the source URL to a blob
% The call waits for the copy to complete before returning a response.
% A copyId is returned as a character vector it can apply for certain long
% running operations.
%
% If a lease is active on the blob, parameter 'leaseId' and the
% actual lease id as value can be provided.

% Copyright 2020-2022 The MathWorks, Inc.

p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'copyFromUrl';
addParameter(p,'leaseid', [], @(x)ischar(x)||isStringScalar(x));
parse(p,varargin{:});

if ~(ischar(copySource) || isStringScalar(copySource))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid copySource type');
end

if isempty(p.Results.leaseid)
    copyId = char(obj.Handle.copyFromUrl(copySource));
else
    requestConditions = com.azure.storage.blob.models.BlobRequestConditions;
    requestConditions = requestConditions.setLeaseId(p.Results.leaseid);    
    r = obj.Handle.copyFromUrlWithResponse(copySource,[],[],[],requestConditions,[],[]);
    copyId = char(r.getValue);
end

end