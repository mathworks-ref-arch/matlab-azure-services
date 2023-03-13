function blobListDetails = getDetails(obj)
    % GETDETAILS Returns a BlobListDetails object

    % Copyright 2023 The MathWorks, Inc.

    blobListDetails = azure.storage.blob.models.BlobListDetails(obj.Handle.getDetails());

end