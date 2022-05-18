classdef DeviceCodeCredentialBuilder < azure.identity.CredentialBuilderBase
% DEVICECODECREDENTIALBUILDER Builder for DeviceCodeCredential.
%
% The DeviceCodeCredentialBuilder constructor in MATLAB always applies
% disableAutomaticAuthentication to avoid any automatic authentication
% attempts by clients during which MATLAB will not be able to display the
% device code. If a client requires authentication for a certain scope and
% your DeviceCodeCredential has not been authenticated for this (yet), an
% error will be thrown.
% 
% See:
%   https://docs.microsoft.com/en-us/java/api/com.azure.identity.devicecodecredentialbuilder.disableautomaticauthentication?view=azure-java-stable#com-azure-identity-devicecodecredentialbuilder-disableautomaticauthentication()

% Copyright 2022 The MathWorks, Inc.

properties
end

methods
    function obj = DeviceCodeCredentialBuilder(varargin)

        initialize('loggerPrefix', 'Azure:Common');
        
        if nargin == 0
            % When creating a new DeviceCodeCredentialBuilder always create
            % one with disabled automatic authentication 
            obj.Handle = com.azure.identity.DeviceCodeCredentialBuilder().disableAutomaticAuthentication();
        elseif nargin == 1 && isa(varargin{1}, 'com.azure.identity.DeviceCodeCredentialBuilder')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid argument(s)');
        end
    end
end

end