function listBlobsOptions = setDetails(obj, blobListDetails)
    % SETDETAILS Returns a ListBlobsOptions object

    % Copyright 2023 The MathWorks, Inc.

    listBlobsOptions = azure.storage.blob.models.ListBlobsOptions(obj.Handle.setDetails(blobListDetails.Handle));

end