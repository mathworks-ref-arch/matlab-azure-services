function AzureShell(varargin)
% AZURESHELL Invokes the Azure Web Browser based shell
% Cloud Shell enables access to a browser-based command-line experience with
% Azure. It is an interactive, browser-accessible shell for managing Azure
% resources. The shell can be Bash or PowerShell. The system configured browser
% is used. Authentication will be requested if not already in place within the
% browser.

% Copyright 2018 The MathWorks, Inc.

% Create a logger object
logObj = Logger.getLogger();

shellUrl = 'https://shell.azure.com';

stat = web(shellUrl,'-browser');

if stat ~= 0
    write(logObj,'error',['Error opening ',shellUrl]);
end

end
