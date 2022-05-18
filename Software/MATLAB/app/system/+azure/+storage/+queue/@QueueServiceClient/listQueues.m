function queueItems = listQueues(obj)
% Lists all queues in the storage account without their metadata
% TODO listQueues probably SDK bug - Only the fist page of queues is 
% currently listed.

% Copyright 2021 The MathWorks, Inc.

queueListj = obj.Handle.listQueues();

% Return an array of Blobitems
queueItems = azure.storage.queue.models.QueueItem.empty;

% Retrieve the iterator for the object
pageIteratorj = queueListj.iterableByPage().iterator();
% Depending on whether the queue has elements iterate through the list
% The returned PagedIterable can be consumed through while
% new items are automatically retrieved as needed.
% Queue names are returned in lexicographic order.

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO listQueues probably SDK bug
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The iterator is not exhausting the pages and each page returns the same
% contents so for now just take elements from the first page

%while pageIteratorj.hasNext()
if pageIteratorj.hasNext()
    pagedResponsej = pageIteratorj.next();
    elementsj = pagedResponsej.getElements;
    elementsIteratorj = elementsj.iterator();
    while elementsIteratorj.hasNext
        queueItemj = elementsIteratorj.next();
        if ~isa(queueItemj, 'com.azure.storage.queue.models.QueueItem')
            logObj = Logger.getLogger();
            write(logObj,'error','Expected item of type com.azure.storage.queue.models.QueueItem');
        end
        queueItems(end+1) = azure.storage.queue.models.QueueItem(queueItemj); %#ok<AGROW>
    end
end
end