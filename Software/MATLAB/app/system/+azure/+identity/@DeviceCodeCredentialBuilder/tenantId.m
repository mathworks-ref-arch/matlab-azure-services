function deviceCodeCredentialBuilder = tenantId(obj, tenantId)
% TENANTID Sets tenant id to authenticate through DeviceCodeCredential
% An updated DeviceCodeCredentialBuilder is returned.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(tenantId) || isStringScalar(tenantId))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

deviceCodeCredentialBuilderj = obj.Handle.tenantId(tenantId);
deviceCodeCredentialBuilder = azure.identity.DeviceCodeCredentialBuilder(deviceCodeCredentialBuilderj);

end
