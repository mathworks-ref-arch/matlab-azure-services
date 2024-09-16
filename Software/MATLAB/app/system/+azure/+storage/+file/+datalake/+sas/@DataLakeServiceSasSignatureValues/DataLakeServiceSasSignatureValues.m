classdef DataLakeServiceSasSignatureValues < azure.object
% DATALAKESERVICESASSIGNATUREVALUES Used to initialize a SAS for Data Lake Storage
% When the values are set, use the generateSas method on the desired service
% client to obtain a representation of the SAS which can then be applied to a
% new client using the .sasToken(String) method on the desired client builder.
%
% Example
%   dlsssv = azure.storage.file.datalake.sas.DataLakeServiceSasSignatureValues(expiryTime, permissions);
%
% Argument types:
%   expiryTime:  datetime ideally with defined TimeZone to avoid any 
%                confusion, if TimeZone is not set, 'local' is assumed
%   permissions: azure.storage.file.datalake.sas.PathSasPermission or
%                FileSystemSasPermission
% Or
%
%   dlsssv = azure.storage.file.datalake.sas.DataLakeServiceSasSignatureValues(identifier);
%
% Argument types:
%   identifier:  Creates an object with the specified identifier.
%                NOTE: Identifier can not be used for a UserDelegationKey SAS.
%                Type character vector or scalar string.

% Copyright 2022 The MathWorks, Inc.

methods
    function obj = DataLakeServiceSasSignatureValues(varargin)
        import java.time.OffsetDateTime.*;
        
        logObj = Logger.getLogger();
        
        if nargin == 2
            expiryTime = varargin{1};
            if ~(isdatetime(expiryTime) || isscalar(expiryTime))
                write(logObj,'error','Expected argument of type scalar datetime');
            end
              expiryTimej = azure.mathworks.internal.datetime2OffsetDateTime(expiryTime);
            permissions = varargin{2};
            if ~(isa(permissions, 'azure.storage.file.datalake.sas.PathSasPermission') ...
                || isa(permissions, 'azure.storage.file.datalake.sas.FileSystemSasPermission')) 
                write(logObj,'error','Expected argument of type com.azure.storage.file.datalake.sas.PathSasPermission or azure.storage.file.datalake.sas.FileSystemSasPermission');
            end
            
            obj.Handle = com.azure.storage.file.datalake.sas.DataLakeServiceSasSignatureValues(expiryTimej, permissions.Handle);

        elseif nargin == 1 && (ischar(varargin{1}) || isStringScalar(varargin{1}))
            % Creates an object with the specified identifier. NOTE: Identifier can not be used for a UserDelegationKey SAS.
            obj.Handle = com.azure.storage.file.datalake.sas.DataLakeServiceSasSignatureValues(varargin{1});
        elseif nargin == 1 && isa(varargin{1}, 'com.azure.storage.file.datalake.sas.DataLakeServiceSasSignatureValues')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid argument(s)');
        end
    end
end

end