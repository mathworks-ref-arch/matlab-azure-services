classdef DeviceCodeCredential < azure.core.credential.TokenCredential
    % DEVICECODECREDENTIAL AAD credential acquires token with device code for AAD application
    
    % Copyright 2020 The MathWorks, Inc.
    
    methods
        function obj = DeviceCodeCredential(varargin)

            if length(varargin) == 1
                deviceCodeCredentialj = varargin{1};
                if isa(deviceCodeCredentialj, 'com.azure.identity.DeviceCodeCredential')
                    obj.Handle = deviceCodeCredentialj;
                else
                    logObj = Logger.getLogger();
                    write(logObj,'error','Expected argument of type com.azure.identity.DeviceCodeCredential');
                end
            elseif isempty(varargin)
            else
                logObj = Logger.getLogger();             
                write(logObj,'error','Unexpected number of arguments');
            end
        end
    end

end