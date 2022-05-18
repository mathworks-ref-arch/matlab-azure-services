classdef EnvironmentCredentialBuilder < azure.identity.CredentialBuilderBase
% ENVIRONMENTCREDENTIALBUILDER Builder for EnvironmentCredentialBuilder

% Copyright 2020-2021 The MathWorks, Inc.

properties
end

methods
    function obj = EnvironmentCredentialBuilder(varargin)
        
        initialize('loggerPrefix', 'Azure:Common');

        if nargin == 0
            obj.Handle = com.azure.identity.EnvironmentCredentialBuilder();
        elseif nargin == 1 && isa(varargin{1}, 'com.azure.identity.EnvironmentCredentialBuilder')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid argument(s)');
        end
    end
end

end