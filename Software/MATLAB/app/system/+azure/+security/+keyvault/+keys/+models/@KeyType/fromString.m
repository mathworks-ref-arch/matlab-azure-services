function keyType = fromString(name)
% FROMSTRING Creates or finds a KeyType from its string representation
% A azure.security.keyvault.keys.models.KeyType is returned.
% Input may be a character vector or scalar string.
% Input is not case sensitive.
% Accepted values are: EC, EC_HSM, OCT, OCT_HSM, RSA & RSA_HSM.
% This is a static method.

% Copyright 2021 The MathWorks, Inc.

if ~(ischar(name) || isStringScalar(name))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected name to be of type character vector or scalar string');
end

keyTypej = com.azure.security.keyvault.keys.models.KeyType.fromString(name);

switch upper(char(keyTypej.toString))
    case 'EC'
        keyType = azure.security.keyvault.keys.models.KeyType.EC;
    case 'EC_HSM'
        keyType = azure.security.keyvault.keys.models.KeyType.EC_HSM;
    case 'OCT'
        keyType = azure.security.keyvault.keys.models.KeyType.OCT;
    case 'OCT_HSM'
        keyType = azure.security.keyvault.keys.models.KeyType.OCT_HSM;
    case 'RSA'
        keyType = azure.security.keyvault.keys.models.KeyType.RSA;
    case 'RSA_HSM'
        keyType = azure.security.keyvault.keys.models.KeyType.RSA_HSM;
    otherwise
        logObj = Logger.getLogger();
        write(logObj,'error','Unexpected KeyType value');
end

end