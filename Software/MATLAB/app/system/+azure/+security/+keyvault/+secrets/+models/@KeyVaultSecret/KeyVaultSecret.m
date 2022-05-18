classdef KeyVaultSecret < azure.object
% KEYVAULTSECRET Class to provide access to the KeyVaultSecret object
% Creates a azure.security.keyvault.secrets.models.KeyVaultSecret object.
% A KeyVaultSecret can be created from a name and value or an equivalent Java
% object. A number of methods return KeyVaultSecret objects.
%
%
% Example
%     % Get a KeyVaultSecret object
%     secret = secretClient.getSecret('mySecretName');
%     value = secret.getValue();
%
% Or
%
%     secret = azure.security.keyvault.secrets.models.KeyVaultSecret(secretName, secretValue);
%
% Or
%
%     secret = azure.security.keyvault.secrets.models.KeyVaultSecret(javaKeyVaultSecret);

% Copyright 2020-2021 The MathWorks, Inc.

    properties
    end

    methods
        function obj = KeyVaultSecret(varargin)
            % Create a logger object
            logObj = Logger.getLogger();
           
            if length(varargin) == 2
                secretName = varargin{1};
                secretValue = varargin{2};
                if ((ischar(secretName) || isStringScalar(secretName)) && (ischar(secretValue) || isStringScalar(secretValue)))
                    obj.Handle = com.azure.security.keyvault.secrets.models.KeyVaultSecret(secretName, secretValue);
                else
                    write(logObj,'error','Expected secretName and secretValue to be of type character vector or scalar string');
                end
            elseif length(varargin) == 1
                if  isa(varargin{1}, 'com.azure.security.keyvault.secrets.models.KeyVaultSecret')
                    obj.Handle = varargin{1};
                else
                    write(logObj,'error','Expected argument of type com.azure.security.keyvault.secrets.models.KeyVaultSecret');
                end
            else
                write(logObj,'error','Unexpected number of arguments');
            end
        end
    end
end