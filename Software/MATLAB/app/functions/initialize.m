function tf = initialize(varargin)
% INITIALIZE Configure logger and version test at Client builder entry points
% This function need only be invoked once per session when using the package.
% It configures logging and proxy settings.
% Note the logger is a singleton so prefixes may not correspond if multiple
% packages are using it simultaneously. In this scenario a generic subprefix
% may be helpful.
%
% Example
%    % Taken from createClient in the Key Vault interface
%    initialize('displayLevel', 'debug', 'loggerPrefix', 'Azure:KeyVault');
%
% See: MATLAB/app/functions/Logger.m for more details.


% Copyright 2020-2021 The MathWorks, Inc.

p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'initialize';
validationFcnStr = @(x) ischar(x) || isStringScalar(x);
addParameter(p,'loggerPrefix', 'Azure:Common', validationFcnStr);
% R2019a is 9.6
addParameter(p,'minVersion','9.6', validationFcnStr);
addParameter(p,'displayLevel', '', validationFcnStr);
% Allow log4j properties to be set to a PSP specific value if desired
addParameter(p,'log4jPropertiesPath', fullfile(AzureCommonRoot, 'lib', 'jar', 'log4j.properties'), validationFcnStr);
addParameter(p,'log4j2XmlPath', fullfile(AzureCommonRoot, 'lib', 'jar', 'log4j2.xml'), validationFcnStr);
parse(p,varargin{:});

%% Create a logger object
logObj = Logger.getLogger();
% Logger prefix can be used when catching errors
% Note this is mapped to a singleton and so can lead to incorrect values if using
% more than one PSP at the same time, in such a case consider setting all PSPs
% to a common value or allowing to default
logObj.MsgPrefix = char(p.Results.loggerPrefix);

% In normal operation use logger's default level debug 
% If debug is being set as an argument apply the setting otherwise don't alter it
% unless the level is not set, in that case set it to debug. This should not arise
% in normal operation. This allows the value to be set by an explicit call e.g.
% to verbose.
% TODO add a test for previous config to avoid repeated calls
if ~isempty(char(p.Results.displayLevel))
    logObj.DisplayLevel = char(p.Results.displayLevel);
else
    if isempty(logObj.DisplayLevel)
        logObj.DisplayLevel = 'debug';
    end
end
write(logObj,'verbose','Initializing');

%% Check for base MATLAB requirements
if ~usejava('jvm')
    write(logObj,'error','MATLAB must be used with the JVM enabled');
end
minVer = char(p.Results.minVersion);
if verLessThan('matlab', minVer)
    write(logObj,'error',['MATLAB version: ', minVer, ' or newer is required, see ver command for version details']);
end

%% Configure log4j if a properties file exists
% append the properties file location and configure it
% This is used by the SDK for logging
% TODO reduce logging from info level at on release

% Check whether log4j 1 or 2 is used
if exist('org.apache.logging.log4j.core.LoggerContext','class') 
    % For log4j2 refer to the log4j2.xml file
    if exist(char(p.Results.log4j2XmlPath), 'file') == 2
        java.lang.System.setProperty('log4j.configurationFile',java.io.File(p.Results.log4j2XmlPath).toURI().toString());
        org.apache.logging.log4j.core.LoggerContext.getContext(false).reconfigure()
    else
        write(logObj,'warning',['log4j2.xml file not found: ', char(p.Results.log4j2XmlPath)]);
    end
else
    % For log4j 1 refer to the log4j.properties files
    if exist(char(p.Results.log4jPropertiesPath), 'file') == 2
        org.apache.log4j.PropertyConfigurator.configure(char(p.Results.log4jPropertiesPath));
    else
        write(logObj,'warning',['log4j.properties file not found: ', char(p.Results.log4jPropertiesPath)]);
    end
end
   


%% Configure a proxy if set in MATLAB web preferences
% Populate values in a global com.azure.core.util.Configuration.
% If a value is set and it begins http: the set the http specific property
% otherwise assume the url should refer to a https url if it begin with https
% or not e.g. if no scheme is specified
% Clients are configured using configureProxyOptions to support proxy credentials
proxyHost = char(java.lang.System.getProperty('tmw.proxyHost'));
if ~isempty(proxyHost)
    proxyPort = char(java.lang.System.getProperty('tmw.proxyPort'));
    if ~isempty(proxyPort)
        proxyHost = append(proxyHost, ':', proxyPort);
    end
    configJ = com.azure.core.util.Configuration.getGlobalConfiguration();
    % MATLAB only supports a single field so set based on the initial characters
    if startsWith(proxyHost, 'http:', 'IgnoreCase', true)
        write(logObj,'verbose',['Setting http proxy to: ', proxyHost]);
        configJ.put('PROPERTY_HTTP_PROXY', proxyHost);
    else
        write(logObj,'verbose',['Setting https proxy to: ', proxyHost]);
        configJ.put('PROPERTY_HTTPS_PROXY', proxyHost);
    end
end


%% Place holder return value not currently used
tf = true;
end
