
function [blobUriWithSas, blobSize] = clientCopyToBlobContainer(ingestionResources, blobName, localFile)
    % clientCopyToBlobContainer Copies a file to a blob for ingestion
    % Uses MATLAB's built in copy file function.

    % See: G3200984 MATLAB copyfile requires list permissions which is not supported
    % by the SAS returned by ADX

    % Copyright 2023 The MathWorks, Inc.

    arguments
        ingestionResources
        blobName string {mustBeTextScalar, mustBeNonzeroLengthText}
        localFile string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    
    warning("adx:clientCopyToBlobContainer", "copyfile cannot currently be used with an ADX SAS");

    if ~isfile(localFile)
        error("adx:clientCopyToBlobContainer", "File name not found: %s", localFile);
    end

    % Assume source and destination size is the same
    dirInfo = dir(localFile);
    blobSize = dirInfo.bytes;
    
    if ~isprop(ingestionResources, 'TempStorage')
        error("adx:clientCopyToBlobContainer", "TempStorage name not found");
    else
        containerURI = matlab.net.URI(ingestionResources.TempStorage(1));
    end

    sasToken = "?" + string(containerURI.EncodedQuery);
    setenv("MW_WASB_SAS_TOKEN", sasToken);
    cleanup = onCleanup(@() cleanupEnvVar("MW_WASB_SAS_TOKEN"));
    destination = "wasbs://" + string(strip(containerURI.EncodedPath, "/")) + "@" + containerURI.EncodedAuthority + "/" + blobName;
    blobUriWithSas = containerURI.Scheme + "://" + containerURI.EncodedAuthority + containerURI.EncodedPath + "/" + blobName + "?" + containerURI.EncodedQuery;

    [status,msg,msgID] = copyfile(localFile, destination);
    if status ~= 1
        error("adx:clientCopyToBlobContainer","copyfile failed: msgID: %s, msg: %s", msgID, msg);
    end
end


function cleanupEnvVar(varName)
    if isMATLABReleaseOlderThan("R2022b")
        setenv(varName, "");
    else
        unsetenv(varName);
    end
end
