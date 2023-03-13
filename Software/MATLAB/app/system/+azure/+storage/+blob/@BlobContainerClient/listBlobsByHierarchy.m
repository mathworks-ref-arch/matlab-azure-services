function blobItems = listBlobsByHierarchy(obj, varargin)
% LISTBLOBSBYHIERARCHY Returns the blobs and directories (prefixes) under the given directory (prefix).
% Directories will have BlobItem.isPrefix() set to true. 
% Blob names are returned in lexicographic order.
% An array of BlobItems is returned.

% Copyright 2023 The MathWorks, Inc.

logObj = Logger.getLogger();

if numel(varargin) == 0
    directory = "";
    blobList = obj.Handle.listBlobsByHierarchy(directory);
elseif numel(varargin) == 1
    directory = varargin{1};
    if ~isStringScalar(directory)
        write(logObj,'error','Invalid argument(s), expected directory of type scalar string or character vector');
    end
    blobList = obj.Handle.listBlobsByHierarchy(directory);
elseif numel(varargin) == 3
    delimiter = varargin{1};
    if ~isStringScalar(delimiter)
        write(logObj,'error','Invalid argument(s), expected delimiter of type scalar string or character vector');
    end
    options = varargin{2};
    if ~isa(options, 'azure.storage.blob.models.ListBlobsOptions')
        write(logObj,'error','Invalid argument(s), expected options of type azure.storage.blob.models.ListBlobsOptions');
    end
    timeout = varargin{3};
    if ~(isduration(timeout) || isnumeric(timeout))
        write(logObj,'error','Invalid argument(s), expected timeout of type duration or numeric');
    end
    if isduration(timeout)
        secs = int64(seconds(timeout));
    else
        secs = int64(timeout);
    end
    jd = java.time.Duration.ofSeconds(secs);
    blobList = obj.Handle.listBlobsByHierarchy(delimiter, options.Handle, jd);
else
    write(logObj,'error','Invalid argument(s)');
end

% Return an array of BlobItems
blobItems = azure.storage.blob.models.BlobItem.empty;

% Retrieve the iterator for the object
pageIterator = blobList.iterableByPage().iterator();
% Depending on whether the blob has elements iterate through the list
% The returned PagedIterable can be consumed through while
% new items are automatically retrieved as needed. 
% Blob names are returned in lexicographic order. 
while pageIterator.hasNext()
    pagedResponse = pageIterator.next();
    itemsj = pagedResponse.getItems();
    for n = 1:itemsj.size
        blobItemj = itemsj.get(n-1);
        if ~isa(blobItemj, 'com.azure.storage.blob.models.BlobItem')
            logObj = Logger.getLogger();
            write(logObj,'warning','Expected item of type com.azure.storage.blob.models.BlobItem');
        end
        blobItems(end+1) = azure.storage.blob.models.BlobItem(blobItemj); %#ok<AGROW>
    end
end

end