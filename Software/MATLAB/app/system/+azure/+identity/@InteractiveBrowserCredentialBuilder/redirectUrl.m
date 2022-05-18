function interactiveBrowserCredentialBuilder = redirectUrl(obj, redirectUrl)
% REDIRECTURL Sets Redirect URL for application with the security code callback

% Copyright 2020 The MathWorks, Inc.

if ~(ischar(redirectUrl) || isStringScalar(redirectUrl))
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type character vector or scalar string');
end

interactiveBrowserCredentialBuilderj = obj.Handle.redirectUrl(redirectUrl);
interactiveBrowserCredentialBuilder = azure.identity.InteractiveBrowserCredentialBuilder(interactiveBrowserCredentialBuilderj);

end