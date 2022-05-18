classdef (Abstract) CredentialBuilderBase < azure.object
    methods
        function builder = httpClient(obj, varargin)
            % HTTPCLIENT Sets the HttpClient to use for sending a receiving requests
            % Currently the Netty client is configured by default.
            % An updated builder object is returned.

            % Copyright 2020-2021 The MathWorks, Inc.

            p = inputParser;
            p.CaseSensitive = false;
            validString = @(x) ischar(x) || isStringScalar(x);
            p.FunctionName = mfilename;
            addParameter(p, 'httpClientName', 'netty', validString);
            parse(p,varargin{:});


            if strcmpi(p.Results.httpClientName, 'netty')
                proxyOptionsj = configureProxyOptions();
                if isempty(proxyOptionsj) % If no proxy configured
                    % Create a standard NettyAsyncHttpClientBuilder with default settings
                    httpClientBuilderj = com.azure.core.http.netty.NettyAsyncHttpClientBuilder;
                else % If a proxy configured
                    % First create a netty HttpClient specifically configured with NoopAddressResolverGroup resolver.
                    % This will prevent the HttpClient from first trying to resolve the hostname before forwarding
                    % the request to the proxy. Which is the correct thing to do if a proxy is configured. If you need
                    % a proxy to access the internet, it is very likely you also cannot directly resolve external hostnames.
                    baseClient = reactor.netty.http.client.HttpClient.create().resolver(shaded.io.netty.resolver.NoopAddressResolverGroup.INSTANCE);
                    % Create a NettyAsyncHttpClientBuilder based on this specifically configured HttpClient
                    httpClientBuilderj = com.azure.core.http.netty.NettyAsyncHttpClientBuilder(baseClient);
                    httpClientBuilderj = httpClientBuilderj.proxy(proxyOptionsj);
                end
            else
                logObj = Logger.getLogger();
                write(logObj,'error',['Unknown http client name: ', p.Results.httpClientName]);
            end

            % Build the http client so it can be applied to the obj builder and return wrapped form
            httpClientj = httpClientBuilderj.build();
            builderj = obj.Handle.httpClient(httpClientj);
            builder = feval(class(obj),builderj);

        end


    end
end