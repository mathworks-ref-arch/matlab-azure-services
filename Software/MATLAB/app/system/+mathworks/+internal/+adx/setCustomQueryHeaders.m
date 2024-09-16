function request = setCustomQueryHeaders(request, options)
    % setCustomHeaders Sets custom header fields Query calls
    %
    % See: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/api/rest/request#request-headers

    % Copyright 2023 The MathWorks, Inc.

    arguments
        request matlab.net.http.RequestMessage
        options.id string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    % Set ADX specific headers, see: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/api/rest/request
    wOpts = weboptions;
    if isprop(wOpts, 'UserAgent')
        userAgent = wOpts.UserAgent;
    else
        userAgent = ['MATLAB ', version];
    end
    request.Header(end+1) = matlab.net.http.HeaderField('x-ms-app', userAgent);
    request.Header(end+1) = matlab.net.http.HeaderField('x-ms-client-version', userAgent);

    userName = char(java.lang.System.getProperty("user.name"));
    request.Header(end+1) = matlab.net.http.HeaderField('x-ms-user', userName);
    request.Header(end+1) = matlab.net.http.HeaderField('x-ms-user-id', userName);

    if isfield(options, 'id')
        request.Header(end+1) = matlab.net.http.HeaderField('x-ms-client-request-id', options.id);
    end
end