function sas = generateSas(obj, dataLakeServiceSasSignatureValues)
    % GENERATESAS Generates a SAS for the blob
    % The client must be authenticated via StorageSharedKeyCredential
    % The SAS is returned as a character vector.
    
    % Copyright 2022 The MathWorks, Inc.
    
    if isa(dataLakeServiceSasSignatureValues, 'azure.storage.file.datalake.sas.DataLakeServiceSasSignatureValues')
        sas = char(obj.Handle.generateSas(dataLakeServiceSasSignatureValues.Handle));
    else
        logObj = Logger.getLogger();
        write(logObj,'error','Expected dataLakeServiceSasSignatureValues argument of type azure.storage.file.datalake.sas.DataLakeServiceSasSignatureValues');
    end
    
    end