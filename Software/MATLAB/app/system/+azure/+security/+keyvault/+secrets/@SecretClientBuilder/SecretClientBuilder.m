classdef SecretClientBuilder < azure.object
% SECRETCLIENTBUILDER builder for SecretClient
% Can optionally accept a Java com.azure.security.keyvault.secrets.SecretClientBuilder
% object as an argument to build a MATLAB builder from the Java builder.

% Copyright 2021 The MathWorks, Inc.

properties
end

methods
    function obj = SecretClientBuilder(varargin)

        initialize('loggerPrefix', 'Azure:KeyVault');

        if nargin == 0
            obj.Handle = com.azure.security.keyvault.secrets.SecretClientBuilder();
        elseif nargin == 1 && isa(varargin{1}, 'com.azure.security.keyvault.secrets.SecretClientBuilder')
            obj.Handle = varargin{1};
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid argument(s)');
        end
    end
end

end