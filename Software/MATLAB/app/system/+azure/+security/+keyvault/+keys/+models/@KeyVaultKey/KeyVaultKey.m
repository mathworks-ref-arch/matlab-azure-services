classdef KeyVaultKey < azure.object
% KEYVAULTSECRET KeyVaultKey class
% Creates a azure.security.keyvault.keys.models.KeyVaultKey object.
% A com.azure.security.keyvault.keys.models.KeyVaultKey java object is a required
% input argument. A number of methods return KeyVaultKey objects.
%
% Example
%     % Get a KeyVaultKey object
%     key = keyClient.getKey('myKeyName');
%     keyType = key.getKeyType();
%     jsonWebKey = key.getKey();

% Copyright 2020-2021 The MathWorks, Inc.

    properties
    end

    methods
        function obj = KeyVaultKey(varargin)
            % Create a logger object
            logObj = Logger.getLogger();

            if length(varargin) == 1
                if  isa(varargin{1}, 'com.azure.security.keyvault.keys.models.KeyVaultKey')
                    obj.Handle = varargin{1};
                else
                    write(logObj,'error','Expected argument of type com.azure.security.keyvault.keys.models.KeyVaultKey');
                end
            else
                write(logObj,'error','Unexpected number of arguments');
            end
        end
    end
end