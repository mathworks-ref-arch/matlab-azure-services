function deviceCodeCredentialBuilder = disableAutomaticAuthentication(obj)
% DISABLEAUTOMATICAUTHENTICATION Disables the automatic authentication and
% prevents the DeviceCodeCredential from automatically prompting the user.
% If automatic authentication is disabled a AuthenticationRequiredException
% will be thrown from getToken(TokenRequestContext request) in the case
% that user interaction is necessary.
%
% An updated DeviceCodeCredentialBuilder is returned.

% Copyright 2022 The MathWorks, Inc.


deviceCodeCredentialBuilderj = obj.Handle.disableAutomaticAuthentication;
deviceCodeCredentialBuilder = azure.identity.DeviceCodeCredentialBuilder(deviceCodeCredentialBuilderj);

end
