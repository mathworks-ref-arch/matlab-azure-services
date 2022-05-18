classdef BlobServiceSasSignatureValues < azure.object
% BLOBSERVICESASSIGNATUREVALUES Used to initialize a SAS for a Blob service
% When the values are set, use the generateSas method on the desired service
% client to obtain a representation of the SAS which can then be applied to a
% new client using the .sasToken(String) method on the desired client builder.
%
% Example
%   bsssv = azure.storage.blob.sas.BlobServiceSasSignatureValues(expiryTime, permissions);
%
% Argument types:
%   expiryTime:  datetime ideally with defined TimeZone to avoid any 
%                confusion, if TimeZone is not set, 'local' is assumed
%   permissions: azure.storage.blob.sas.BlobSasPermission or
%                BlobContainerSasPermission

% Copyright 2020-2022 The MathWorks, Inc.

methods
    function obj = BlobServiceSasSignatureValues(varargin)
        import java.time.OffsetDateTime.*;
        
        logObj = Logger.getLogger();
        
        if nargin == 2
            expiryTime = varargin{1};
            if ~(isdatetime(expiryTime) || isscalar(expiryTime))
                write(logObj,'error','Expected argument of type scalar datetime');
            end
              expiryTimej = datetime2OffsetDateTime(expiryTime);
            permissions = varargin{2};
            if ~(isa(permissions, 'azure.storage.blob.sas.BlobSasPermission') ...
                || isa(permissions, 'azure.storage.blob.sas.BlobContainerSasPermission')) 
                write(logObj,'error','Expected argument of type com.azure.storage.blob.sas.BlobSasPermission or azure.storage.blob.sas.BlobContainerSasPermission');
            end
            
            obj.Handle = com.azure.storage.blob.sas.BlobServiceSasSignatureValues(expiryTimej, permissions.Handle);

        elseif nargin == 1 && isa(varargin{1}, 'com.azure.storage.blob.sas.BlobServiceSasSignatureValues')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid argument(s)');
        end
    end
end

end