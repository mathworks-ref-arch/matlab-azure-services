function blobProperties = getProperties(obj)
    % GETPROPERTIES Returns the blob's metadata and properties

    % Copyright 2023 The MathWorks, Inc.

    blobProperties = azure.storage.blob.models.BlobProperties(obj.Handle.getProperties());
end
