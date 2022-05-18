classdef SecretProperties < azure.object
% SECRETPROPERTIES Contains the properties of the secret but not its value
%
% Example:
%     secretClient = createKeyVaultClient('Type','Secret');
%     propList = secretClient.listPropertiesOfSecrets();
%     % Look at a name in a returned property
%     name = propList(1).getName();


% Copyright 2021 The MathWorks, Inc.

properties
end
    
methods
    function obj = SecretProperties(varargin)
        if nargin == 0
            obj.Handle = com.azure.security.keyvault.secrets.models.SecretProperties();
        elseif nargin == 1
            if isa(varargin{1}, 'com.azure.security.keyvault.secrets.models.SecretProperties')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Expected argument of type com.azure.security.keyvault.secrets.models.SecretProperties');
            end    
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Unexpected number of arguments');
        end
    end

end %methods
end %class

