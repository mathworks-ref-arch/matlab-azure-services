classdef DefaultAzureCredentialBuilder < azure.identity.CredentialBuilderBase
% DEFAULTAZURECREDENTIALBUILDER Credential builder for DefaultAzureCredential

% Copyright 2020-2021 The MathWorks, Inc.

properties
end

methods
    function obj = DefaultAzureCredentialBuilder(varargin)

        initialize('loggerPrefix', 'Azure:Common');

        if nargin == 0
            obj.Handle = com.azure.identity.DefaultAzureCredentialBuilder();
        elseif nargin == 1 && isa(varargin{1}, 'com.azure.identity.DefaultAzureCredentialBuilder')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid argument(s)');
        end
    end
end

end