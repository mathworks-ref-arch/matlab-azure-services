classdef KeyClientBuilder < azure.object
% KEYCLIENTBUILDER Builder for KeyClient object
% Can optionally accept a Java com.azure.security.keyvault.keys.KeyClientBuilder
% object as an argument to create a MATLAB builder from the Java builder.

% Copyright 2021 The MathWorks, Inc.

properties
end

methods
    function obj = KeyClientBuilder(varargin)

        initialize('loggerPrefix', 'Azure:KeyVault');

        if nargin == 0
            obj.Handle = com.azure.security.keyvault.keys.KeyClientBuilder();
        elseif nargin == 1 && isa(varargin{1}, 'com.azure.security.keyvault.keys.KeyClientBuilder')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid argument(s)');
        end
    end
end

end