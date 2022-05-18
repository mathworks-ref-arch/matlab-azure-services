function sas = generateSas(obj, queueServiceSasSignatureValues)
% GENERATESAS Generates a SAS for the queue
% The client must be authenticated via StorageSharedKeyCredential
% The SAS is returned as a character vector.

% Copyright 2021 The MathWorks, Inc.

if isa(queueServiceSasSignatureValues, 'azure.storage.queue.sas.QueueServiceSasSignatureValues')
    sas = char(obj.Handle.generateSas(queueServiceSasSignatureValues.Handle));
else
    logObj = Logger.getLogger();
    write(logObj,'error','Expected queueServiceSasSignatureValues argument of type azure.storage.queue.sas.QueueServiceSasSignatureValues');
end

end