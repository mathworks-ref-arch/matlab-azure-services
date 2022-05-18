classdef AccountSasSignatureValues < azure.object
% ACCOUNTSASSIGNATUREVALUES Used to initialize a SAS for a storage account
% When the values are set, use the generateSas method on the desired service
% client to obtain a representation of the SAS which can then be applied to a
% new client using the .sasToken(String) method on the desired client builder.
%
% Example
%   assv = azure.storage.common.sas.AccountSasSignatureValues( ...
%              expiryTime, permissions, services, resourceTypes);
%
% Argument types:
%   expiryTime: datetime
%   permissions: azure.storage.common.sas.AccountSasPermission
%   services: azure.storage.common.sas.AccountSasService
%   resourceTypes: azure.storage.common.sas.AccountSasResourceType

% Copyright 2020 The MathWorks, Inc.

methods
    function obj = AccountSasSignatureValues(varargin)
        import java.time.OffsetDateTime.*;
        
        logObj = Logger.getLogger();
        
        if nargin == 4
            expiryTime = varargin{1};
            if ~(isdatetime(expiryTime) || isscalar(expiryTime))
                write(logObj,'error','Expected argument of type scalar datetime');
            end
            if isnan(tzoffset(expiryTime))
                write(logObj,'error','expiresAt datetime argument must have timezone set');
            end
            % iso8601 format required TZ should be -04:00 format except for 0 offset then returned as Z
            timeCharSeq = char(datetime(expiryTime,'Format','yyyy-MM-dd''T''HH:mm:ssZZZZZ'));
            % StringBuffer required to provide CharSequence interface
            expiryTimej = java.time.OffsetDateTime.parse(java.lang.StringBuffer(timeCharSeq));

            permissions = varargin{2};
            if ~isa(permissions, 'azure.storage.common.sas.AccountSasPermission')
                write(logObj,'error','Expected argument of type com.azure.storage.common.sas.AccountSasPermission');
            end

            services = varargin{3};
            if ~isa(services, 'azure.storage.common.sas.AccountSasService')
                write(logObj,'error','Expected argument of type com.azure.storage.common.sas.AccountSasService');
            end

            resourceTypes = varargin{4};
            if ~isa(resourceTypes, 'azure.storage.common.sas.AccountSasResourceType')
                write(logObj,'error','Expected argument of type com.azure.storage.common.sas.AccountSasResourceType');
            end
            
            obj.Handle = com.azure.storage.common.sas.AccountSasSignatureValues(expiryTimej, permissions.Handle, ...
                                                                         services.Handle, resourceTypes.Handle);

        elseif nargin == 1 && isa(varargin{1}, 'com.azure.storage.common.sas.AccountSasSignatureValues')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid argument(s)');
        end
    end
end

end