function deviceCodeCredential = buildAndAuthenticate(obj, tokenRequestContext, challengeConsumer)
% BUILDANDAUTHENTICATE Creates new DeviceCodeCredential with the configured
% options set and also immediately authenticates it with the requested
% tokenRequestContext.
% 
% By default this method will print the device code information:
%
%  To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code ILOVEMATLAB to authenticate.
%
% To the MATLAB Command Window. Optionally a function handle
% challengeConsumer can be provided to customize the message or how to
% display it. This function will be called with a DeviceCodeInfo object as
% input.
%
% An authenticated DeviceCodeCredential is returned.

% Copyright 2022 The MathWorks, Inc.

if isempty(tokenRequestContext) || ~isa(tokenRequestContext,'azure.core.credential.TokenRequestContext')
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid tokenRequestContext argument');
end

if nargin == 2
    challengeConsumer = @defaultchallengeConsumer;
end

% Call the helper to build the DeviceCodeCredential and authenticate it
authFlow = com.mathworks.azure.sdk.DeviceCodeCredentialHelper.BuildAndAuthenticate(obj.Handle,tokenRequestContext.Handle);
% Work through the two steps in this flow
% The first step will return the deviceCodeInfo
deviceCodeInfo = authFlow.next();
% Which we can then display
challengeConsumer(azure.identity.DeviceCodeInfo(deviceCodeInfo));

% After this we can wait for the user to interactively perform the
% authentication. This will return the authenticated DeviceCodeCredential
% or throw an error upon timeout.
jdeviceCodeCredential = authFlow.next();

% Wrap the Java object in MATLAB equivalent
deviceCodeCredential = azure.identity.DeviceCodeCredential(jdeviceCodeCredential);

end

function defaultchallengeConsumer(deviceCodeInfo)
    fprintf('%s\n',char(deviceCodeInfo.getMessage))
end