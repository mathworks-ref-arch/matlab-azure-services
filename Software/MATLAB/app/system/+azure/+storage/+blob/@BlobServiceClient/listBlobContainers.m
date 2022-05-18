function blobContainerItems = listBlobContainers(obj)
% LISTBLOBCONTAINERS

% Copyright 2020-2021 The MathWorks, Inc.

blobContainerList = obj.Handle.listBlobContainers();

% Return an array of Blobitems
blobContainerItems = azure.storage.blob.models.BlobContainerItem.empty;

% Retrieve the iterator for the object
pageIterator = blobContainerList.iterableByPage().iterator();

% Depending on whether the blob has elements iterate through the list
% The returned PagedIterable can be consumed through while
% new items are automatically retrieved as needed.
% Blob names are returned in lexicographic order.
while pageIterator.hasNext()
    pagedResponse = pageIterator.next();
    itemsj = pagedResponse.getItems;
    for n = 1:itemsj.size
        blobContainerItemj = itemsj.get(n-1);
        if ~isa(blobContainerItemj, 'com.azure.storage.blob.models.BlobContainerItem')
            logObj = Logger.getLogger();
            write(logObj,'error','Expected item of type com.azure.storage.blob.models.BlobContainerItem');
        end
        blobContainerItems(end+1) = azure.storage.blob.models.BlobContainerItem(blobContainerItemj); %#ok<AGROW>
    end
end
end