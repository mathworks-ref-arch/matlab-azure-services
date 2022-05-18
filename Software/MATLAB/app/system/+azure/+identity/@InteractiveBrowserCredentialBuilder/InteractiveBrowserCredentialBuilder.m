classdef InteractiveBrowserCredentialBuilder < azure.identity.CredentialBuilderBase
% INTERACTIVEBROWSERCREDENTIALBUILDER builder for InteractiveBrowserCredential

% Copyright 2020-2021 The MathWorks, Inc.

properties
end

methods
    function obj = InteractiveBrowserCredentialBuilder(varargin)

        initialize('loggerPrefix', 'Azure:Common');

        if nargin == 0
            obj.Handle = com.azure.identity.InteractiveBrowserCredentialBuilder();
        elseif nargin == 1 && isa(varargin{1}, 'com.azure.identity.InteractiveBrowserCredentialBuilder')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid argument(s)');
        end
    end
end

end