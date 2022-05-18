classdef ManagedIdentityCredentialBuilder < azure.identity.CredentialBuilderBase
% MANAGEDIDENTITYCREDENTIALBUILDER Builder for ManagedIdentityCredential

% Copyright 2020-2021 The MathWorks, Inc.

properties
end

methods
    function obj = ManagedIdentityCredentialBuilder(varargin)

        initialize('loggerPrefix', 'Azure:Common');

        if nargin == 0
            obj.Handle = com.azure.identity.ManagedIdentityCredentialBuilder();
        elseif nargin == 1 && isa(varargin{1}, 'com.azure.identity.ManagedIdentityCredentialBuilder')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid argument(s)');
        end
    end
end

end