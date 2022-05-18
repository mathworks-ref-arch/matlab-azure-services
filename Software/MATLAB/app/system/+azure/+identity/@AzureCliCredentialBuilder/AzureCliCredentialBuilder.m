classdef AzureCliCredentialBuilder < azure.identity.CredentialBuilderBase
% AZURECLICREDENTIALBUILDER  Credential builder for instantiating a AzureCliCredential

% Copyright 2020-2021 The MathWorks, Inc.

properties
end

methods
    function obj = AzureCliCredentialBuilder(varargin)

        initialize('loggerPrefix', 'Azure:Common');

        if nargin == 0
            obj.Handle = com.azure.identity.AzureCliCredentialBuilder();
        elseif nargin == 1 && isa(varargin{1}, 'com.azure.identity.AzureCliCredentialBuilder')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid argument(s)');
        end
    end
end

end