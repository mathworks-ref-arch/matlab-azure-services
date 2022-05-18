function deleteBlob(obj,varargin)
    % DELETEBLOB Deletes the blob - this is the equivalent of the "delete"
    % method in the Azure Java API but because "delete" is a reserved
    % method name in MATLAB, the method is named deleteBlob.
    %
    % If a lease is active on the blob, parameter 'leaseId' and the
    % actual lease id as value can be provided.
    %
    % Example:
    %   client.deleteBlob('leaseId','f6eb8bda-cf33-4da1-8e50-11d1a6dd8797')

    % Copyright 2022 The MathWorks, Inc.
    p = inputParser;
    p.CaseSensitive = false;
    p.FunctionName = 'deleteBlob';
    addParameter(p,'leaseid', [], @(x)ischar(x)||isStringScalar(x));
    parse(p,varargin{:});
    
    if isempty(p.Results.leaseid)
        obj.Handle.delete();
    else
        requestConditions = com.azure.storage.blob.models.BlobRequestConditions;
        requestConditions = requestConditions.setLeaseId(p.Results.leaseid);
        r = obj.Handle.deleteWithResponse([],requestConditions,[],[]);
    end
end