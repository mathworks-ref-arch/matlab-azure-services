function deviceCodeCredentialBuilder = authorityHost(obj, authorityHost)
% AUTHORITYHOST Specifies the Azure Active Directory endpoint to acquire tokens
% An updated DeviceCodeCredentialBuilder is returned.

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(authorityHost) || isStringScalar(authorityHost))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

deviceCodeCredentialBuilderj = obj.Handle.authorityHost(authorityHost);
deviceCodeCredentialBuilder = azure.identity.DeviceCodeCredentialBuilder(deviceCodeCredentialBuilderj);

end
