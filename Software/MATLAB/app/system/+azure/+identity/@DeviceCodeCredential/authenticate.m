function authenticationRecord = authenticate(obj, varargin)
% AUTHENTICATE  Authenticates a user via the device code flow
% Can take a azure.core.credential.TokenRequestContext as an optional argument.
% Returns a reactor.core.publisher.Mono as a azure.identity.AuthenticationRecord.

% Copyright 2021 The MathWorks, Inc.

if isempty(varargin)
    authenticationRecordj = obj.Handle.authenticate();
    authenticationRecord = azure.identity.AuthenticationRecord(authenticationRecordj);
elseif length(varargin) == 1
    if ~isa(varargin{1}, 'azure.core.credential.TokenRequestContext')
        logObj = Logger.getLogger();
        write(logObj,'error','Expected argument of type azure.core.credential.TokenRequestContext');
    else
        tokenRequestContextj = varargin{1}.Handle;
        authenticationRecordj = obj.Handle.authenticate(tokenRequestContextj);
        authenticationRecord = azure.identity.AuthenticationRecord(authenticationRecordj);
    end
else
    logObj = Logger.getLogger();
    write(logObj,'error','Unexpected number of arguments');
end

end