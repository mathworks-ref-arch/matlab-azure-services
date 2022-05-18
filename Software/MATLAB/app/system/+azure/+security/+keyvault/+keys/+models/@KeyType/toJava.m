function keyTypej = toJava(obj)
% TOJAVA Converts to a com.azure.security.keyvault.keys.models.KeyType Java object

% Copyright 2021 The MathWorks, Inc.

switch upper(obj.toString())
    case 'EC'
        keyTypej = com.azure.security.keyvault.keys.models.KeyType.EC;
    case 'EC_HSM'
        keyTypej = com.azure.security.keyvault.keys.models.KeyType.EC_HSM;
    case 'OCT'
        keyTypej = com.azure.security.keyvault.keys.models.KeyType.OCT;
    case 'OCT_HSM'
        keyTypej = com.azure.security.keyvault.keys.models.KeyType.OCT_HSM;
    case 'RSA'
        keyTypej = com.azure.security.keyvault.keys.models.KeyType.RSA;
    case 'RSA_HSM'
        keyTypej = com.azure.security.keyvault.keys.models.KeyType.RSA_HSM;
    otherwise
        logObj = Logger.getLogger();
        write(logObj,'error','Unexpected KeyType value');
end    

end