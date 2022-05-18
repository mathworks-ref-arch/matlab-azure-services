classdef BlobContainerSasPermission < azure.object
% BLOBCONTAINERSASPERMISSION Constructs a string of permissions granted by Account SAS
% Setting a value to true means that any SAS which uses these permissions will
% grant permissions for that operation.
% Once the required values are set, the object should be serialized with
% toString and set as the permissions field on a BlobSasSignatureValues
% object

% Copyright 2020 The MathWorks, Inc.

% It is possible to construct the permissions  string without this class,
% but the order of the permissions  is particular and this class guarantees
% correctness.

methods (Static)
    accountSasResourceType = parse(permString);
end

methods
    function obj = BlobContainerSasPermission(varargin)
        if nargin == 0
            obj.Handle = com.azure.storage.blob.sas.BlobContainerSasPermission();        
        elseif nargin == 1
            if isa(varargin{1}, 'com.azure.storage.blob.sas.BlobContainerSasPermission')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Expected argument of type com.azure.storage.blob.sas.BlobContainerSasPermission');
            end                
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Unexpected number of arguments');
        end
    end
end
end    