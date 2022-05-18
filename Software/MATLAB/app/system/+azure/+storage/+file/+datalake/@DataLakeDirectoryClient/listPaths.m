function pathItems = listPaths(obj)
    % LISTPATHS Returns a list of files/directories in this account
    % Paths are returned as an array of 
    % azure.storage.file.datalake.models.PathItem objects.
    % If there are no keys an empty array is returned.
    
    % Copyright 2022 The MathWorks, Inc.
    
    pathItems = azure.storage.file.datalake.models.PathItem.empty;
    
    pagedIter = obj.Handle.listPaths();
    iterator = pagedIter.iterator();
    while iterator.hasNext()
        pathItemj = iterator.next();
        pathItem = azure.storage.file.datalake.models.PathItem(pathItemj);
        pathItems(end+1) = pathItem; %#ok<AGROW>
    end
    
    end