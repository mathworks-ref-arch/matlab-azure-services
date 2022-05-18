function proxyOptionsj = configureProxyOptions()
% CONFIGUREPROXYOPTIONS Configured Java proxy options object
% A com.azure.core.http.ProxyOptions Java object is returned if a proxy is
% configured otherwise an empty double is returned corresponding to a null.

% See: https://docs.microsoft.com/en-us/azure/developer/java/sdk/proxying
% TODO enhance with calls to com.azure.core.util.Configuration
% See https://docs.microsoft.com/en-us/java/api/com.azure.core.util.configuration?view=azure-java-stable

% Copyright 2021 The MathWorks, Inc.


% Extract MATLAB preferences
proxyHost = char(java.lang.System.getProperty('tmw.proxyHost'));

% If there is a host check for other values
if ~isempty(proxyHost)
    proxyOptionsTypej = javaMethod('valueOf','com.azure.core.http.ProxyOptions$Type','HTTP');
    proxyPort = char(java.lang.System.getProperty('tmw.proxyPort'));
    proxyAddressj = java.net.InetSocketAddress(proxyHost, int32(str2double(proxyPort)));
    proxyOptionsj = com.azure.core.http.ProxyOptions(proxyOptionsTypej, proxyAddressj);

    proxyUser = char(java.lang.System.getProperty('tmw.proxyUser'));
    if ~isempty(proxyUser)
        proxyPassword = char(java.lang.System.getProperty('tmw.proxyPassword'));
        proxyOptionsj = proxyOptionsj.setCredentials(proxyUser, proxyPassword);
    end
else
    proxyOptionsj = [];

end

end %function