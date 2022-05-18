classdef InteractiveBrowserCredential < azure.core.credential.TokenCredential
% INTERACTIVEBROWSERCREDENTIAL Prompt the login in the default browser
% An AAD credential that acquires a token for an AAD application by prompting
% the login in the default browser.
% The oauth2 flow will notify the credential of the authentication code through
% the reply URL.
%% The application to authenticate to must have delegated user login permissions 
% and have http://localhost:{port} listed as a valid reply URL.

% Copyright 2020 The MathWorks, Inc.

properties    
end

methods
    function obj = InteractiveBrowserCredential(interactiveBrowserCredentialj)
        % Created using a EnvironmentCredential java object from the
        % EnvironmentCredential class only
        if isa(interactiveBrowserCredentialj, 'com.azure.identity.InteractiveBrowserCredential')
            obj.Handle = interactiveBrowserCredentialj;
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Expected argument of type com.azure.identity.InteractiveBrowserCredential');
        end
    end
end

end