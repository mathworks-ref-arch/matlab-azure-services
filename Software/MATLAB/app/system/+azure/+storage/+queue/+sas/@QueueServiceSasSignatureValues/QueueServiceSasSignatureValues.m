classdef QueueServiceSasSignatureValues < azure.object
% QUEUESERVICESASSIGNATUREVALUES Used to initialize a SAS for a Queue service
% When the values are set, use the generateSas method on the desired service
% client to obtain a representation of the SAS which can then be applied to a
% new client using the .sasToken(String) method on the desired client builder.
%
% Example
%   qsssv = azure.storage.queue.sas.QueueServiceSasSignatureValues(expiryTime, permissions);
%
% Argument types:
%   expiryTime: datetime
%   permissions: azure.storage.queue.sas.QueueSasPermission

% Copyright 2021 The MathWorks, Inc.

methods
    function obj = QueueServiceSasSignatureValues(varargin)
        import java.time.OffsetDateTime.*;
        
        logObj = Logger.getLogger();
        
        if nargin == 2
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
            if ~isa(permissions, 'azure.storage.queue.sas.QueueSasPermission')
                write(logObj,'error','Expected argument of type com.azure.storage.queue.sas.QueueSasPermission');
            end
            
            obj.Handle = com.azure.storage.queue.sas.QueueServiceSasSignatureValues(expiryTimej, permissions.Handle);

        elseif nargin == 1 && isa(varargin{1}, 'com.azure.storage.queue.sas.QueueServiceSasSignatureValues')
            obj.Handle = varargin{1};
        else
            write(logObj,'error','Invalid argument(s)');
        end
    end
end

end