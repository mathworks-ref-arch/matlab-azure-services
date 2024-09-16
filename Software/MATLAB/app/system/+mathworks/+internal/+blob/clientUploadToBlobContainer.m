
function [blobUriWithSas, blobSize] = clientUploadToBlobContainer(ingestionResources, blobName, localFile)
    % clientUploadToBlobContainer Uploads a file to a blob for ingestion
    % Uses Azure Services support package

    % Copyright 2023 The MathWorks, Inc.

    arguments
        ingestionResources (1,1) adx.data.models.IngestionResourcesSnapshot
        blobName string {mustBeTextScalar, mustBeNonzeroLengthText}
        localFile string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    
    if ~isprop(ingestionResources, 'TempStorage')
        error("adx:clientUploadToBlobContainer", "TempStorage name not found");
    else
        containerURI = matlab.net.URI(ingestionResources.TempStorage(1));
    end
    
    blobContainerClientBuilder = azure.storage.blob.BlobContainerClientBuilder();
    blobContainerClientBuilder.sasToken(containerURI.EncodedQuery);
    blobContainerClientBuilder.endpoint(strcat(containerURI.Scheme, "://", containerURI.EncodedAuthority, containerURI.EncodedPath));
    blobContainerClient = blobContainerClientBuilder.buildClient;
    blobClient = blobContainerClient.getBlobClient(blobName);
    blobClient.uploadFromFile(localFile, 'overwrite', true);
    blobProperties = blobClient.getProperties();
    blobSize = blobProperties.getBlobSize();
    blobUriWithSas = strcat(blobClient.getBlobUrl(), "?", containerURI.EncodedQuery);
end
