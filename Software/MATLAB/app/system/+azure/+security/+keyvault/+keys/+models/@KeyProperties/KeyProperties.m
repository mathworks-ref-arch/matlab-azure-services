classdef KeyProperties < azure.object
% KEYPROPERTIES Contains the properties of the secret except its value
%
% Example
%     keyClient = createKeyVaultClient('Type','Key');
%     propList = keyClient.listPropertiesOfKeys();
%     % Look at a name in a returned property
%     name = propList(1).getName();

% Copyright 2021 The MathWorks, Inc.

properties
end

methods
    function obj = KeyProperties(varargin)
        if nargin == 0
            obj.Handle = com.azure.security.keyvault.keys.models.KeyProperties();
        elseif nargin == 1
            if isa(varargin{1}, 'com.azure.security.keyvault.keys.models.KeyProperties')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Expected argument of type com.azure.security.keyvault.keys.models.KeyProperties');
            end    
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Unexpected number of arguments');
        end
    end

end %methods
end %class

