function blobItems = listBlobs(obj)
% LISTBLOBS Returns a list of blobs in this container
% Folder structures are flattened.
% An array of BlobItems is returned.

% Copyright 2020 The MathWorks, Inc.

% Create a logger object
% logObj = Logger.getLogger();

blobList = obj.Handle.listBlobs();

% Return an array of Blobitems
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