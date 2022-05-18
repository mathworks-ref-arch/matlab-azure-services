function tf = compareAuthEnvVars()
% COMPAREAUTHENVVARS Checks matching Java & MATLAB authentication env. variables
% This is a useful sanity check that variables exist in both contexts.
% The following variables are tested:
%   AZURE_CLIENT_ID
%   AZURE_CLIENT_SECRET
%   AZURE_TENANT_ID
%   AZURE_CLIENT_CERTIFICATE_PATH
%   AZURE_USERNAME
%   AZURE_PASSWORD
%
% A variable no set in either context does not return a false.
% A logical is returned.

% Copyright 2021 The MathWorks, Inc.

clientIdTf = testVar('AZURE_CLIENT_ID');
clientSecretTf = testVar('AZURE_CLIENT_SECRET');
tenantIdTf = testVar('AZURE_TENANT_ID');
certPathTf = testVar('AZURE_CLIENT_CERTIFICATE_PATH');
usernameTf = testVar('AZURE_USERNAME');
passwordTf = testVar('AZURE_PASSWORD');

tf = all([clientIdTf, clientSecretTf, tenantIdTf, certPathTf, usernameTf, passwordTf]);

end


function tf = testVar(varName)
    % Return true if a variable is not set in both environments, in a sense this is a match
    if isempty(getenv(varName)) && isempty(char(java.lang.System.getenv(varName)))
        tf  = true;
    elseif strcmp(getenv(varName), char(java.lang.System.getenv(varName)))
        tf = true;
    else
        logObj = Logger.getLogger();
        write(logObj,'warning',['Variable mismatch detected for: ', char(varName)]);
        tf = false;
    end
end