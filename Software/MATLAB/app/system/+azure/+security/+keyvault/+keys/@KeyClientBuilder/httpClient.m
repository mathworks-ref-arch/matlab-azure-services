function builder = httpClient(obj, varargin)
% HTTPCLIENT Sets the HttpClient to use for sending a receiving requests
% Currently the Netty client is configured by default. Other options may be added
% in the future. An updated builder object is returned.
% This method will apply http proxy settings if defined in MATLAB Web preferences.

% Copyright 2021 The MathWorks, Inc.

p = inputParser;
p.CaseSensitive = false;
validString = @(x) ischar(x) || isStringScalar(x);
p.FunctionName = mfilename;
addParameter(p, 'httpClientName', 'netty', validString);
parse(p,varargin{:});

if strcmpi(p.Results.httpClientName, 'netty')
    httpClientBuilderj = com.azure.core.http.netty.NettyAsyncHttpClientBuilder;
else
    logObj = Logger.getLogger();
    write(logObj,'error',['Unknown http client name: ', p.Results.httpClientName]);
end

proxyOptionsj = configureProxyOptions();
if ~isempty(proxyOptionsj)
    httpClientBuilderj = httpClientBuilderj.proxy(proxyOptionsj);
end

% Build the http client and apply it to the credential builder
httpClientj = httpClientBuilderj.build();
builderj = obj.Handle.httpClient(httpClientj);
builder = azure.security.keyvault.keys.KeyClientBuilder(builderj);

end

