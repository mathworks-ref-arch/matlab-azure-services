function listBlobsOptions = setPrefix(obj, prefix)
    % SETPREFIX Filters the results to return only blobs whose names begin with the specified prefix

    % Copyright 2023 The MathWorks, Inc.

    if ~(isStringScalar(prefix) || ischar(prefix))
        logObj = Logger.getLogger();
        write(logObj,'error','Invalid argument(s), expected a scalar string or character vector');
    else
        listBlobsOptions = azure.storage.blob.models.ListBlobsOptions(obj.Handle.setPrefix(prefix));
    end
end