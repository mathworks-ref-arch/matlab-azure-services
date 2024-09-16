classdef Scripts < adx.control.BaseClient
    % Scripts No description provided
    %
    % Scripts Properties:
    %
    %   serverUri           - Base URI to use when calling the API. Allows using a different server
    %                         than specified in the original API spec.
    %   httpOptions         - HTTPOptions used by all requests.
    %   preferredAuthMethod - If operation supports multiple authentication methods, specified which
    %                         method to prefer.
    %   bearerToken         - If Bearer token authentication is used, the token can be supplied 
    %                         here. Note the token is only used if operations are called for which
    %                         the API explicitly specified that Bearer authentication is supported.
    %                         If this has not been specified in the spec but most operations do 
    %                         require Bearer authentication, consider adding the relevant header to
    %                         all requests in the preSend method.
    %   apiKey              - If API key authentication is used, the key can be supplied here. 
    %                         Note the key is only used if operations are called for which
    %                         the API explicitly specified that API key authentication is supported.
    %                         If this has not been specified in the spec but most operations do 
    %                         require API key authentication, consider adding the API key to all
    %                         requests in the preSend method.
    %   httpCredentials     - If Basic or Digest authentication is supported username/password
    %                         credentials can be supplied here as matlab.net.http.Credentials. Note 
    %                         these are only actively used if operations are called for which the 
    %                         API spec has specified they require Basic authentication. If this has
    %                         not been specified in the spec but most operations do require
    %                         Basic authentication, consider setting the Credentials property in the
    %                         httpOptions rather than through httpCredentials.
    %   cookies             - Cookie jar. The cookie jar is shared across all Api classes in the 
    %                         same package. All responses are automatically parsed for Set-Cookie
    %                         headers and cookies are automatically added to the jar. Similarly
    %                         cookies are added to outgoing requests if there are matching cookies 
    %                         in the jar for the given request. Cookies can also be added manually
    %                         by calling the setCookies method on the cookies property. The cookie
    %                         jar is also saved to disk (cookies.mat in the same directory as 
    %                         BaseClient) and reloaded in new MATLAB sessions.
    %
    % Scripts Methods:
    %
    %   Scripts - Constructor
    %   scriptsListByDatabase - 
    %
    % See Also: matlab.net.http.HTTPOptions, matlab.net.http.Credentials, 
    %   CookieJar.setCookies, control.BaseClient

    % This file is automatically generated using OpenAPI
    % Specification version: 2023-05-02
    % MATLAB Generator for OpenAPI version: 1.0.0
    % (c) 2023 MathWorks Inc.

    % Instruct MATLAB Code Analyzer to ignore unnecessary brackets
    %#ok<*NBRAK2> 

    % Class properties
    properties
    end

    % Class methods
    methods
        function obj = Scripts(options)
            % Scripts Constructor, creates a Scripts instance.
            % When called without inputs, tries to load configuration
            % options from JSON file 'adx.Client.Settings.json'.
            % If this file is not present, the instance is initialized with 
            % default configuration option. An alternative configuration 
            % file can be provided through the "configFile" Name-Value pair.
            % All other properties of the instance can also be overridden 
            % using Name-Value pairs where Name equals the property name.
            % 
            % Examples:
            %
            %   % Create a client with default options and serverUri
            %   % as parsed from OpenAPI spec (if available)
            %   client = adx.control.api.Scripts();
            %
            %   % Create a client for alternative server/base URI
            %   client = adx.control.api.Scripts("serverUri","https://example.com:1234/api/");
            %
            %   % Create a client loading configuration options from 
            %   % JSON configuration file
            %   client = adx.control.api.Scripts("configFile","myconfig.json");
            %
            %   % Create a client with alternative HTTPOptions and an API key
            %   client = adx.control.api.Scripts("httpOptions",...
            %       matlab.net.http.HTTPOptions("ConnectTimeout",42),...
            %       "apiKey", "ABC123");

            arguments
                options.configFile string
                options.?adx.control.BaseClient
            end
            % Call base constructor to override any configured settings
            args = namedargs2cell(options);
            obj@adx.control.BaseClient(args{:})
        end

        function [code, result, response] = scriptsListByDatabase(obj, subscriptionId, resourceGroupName, clusterName, databaseName, api_version)
            % scriptsListByDatabase No summary provided
            % Returns the list of database scripts for given database.
            %
            % Required parameters:
            %   subscriptionId - The ID of the target subscription., Type: string
            %   resourceGroupName - The name of the resource group. The name is case insensitive., Type: string
            %   clusterName - The name of the Kusto cluster., Type: string
            %   databaseName - The name of the database in the Kusto cluster., Type: string
            %   api_version - The API version to use for this operation., Type: string
            %
            % No optional parameters
            %
            % Responses:
            %   200: The list result of Kusto database scripts.
            %   0: Error response describing why the operation failed.
            %
            % Returns: ScriptListResult
            %
            % See Also: adx.control.models.ScriptListResult

            arguments
              obj adx.control.api.Scripts
              subscriptionId string
              resourceGroupName string
              clusterName string
              databaseName string
              api_version string
            end

            % Create the request object
            request = matlab.net.http.RequestMessage();
            
            % Verify that operation supports returning JSON
            specAcceptHeaders = [...
                "application/json", ...
            ];
            if ismember("application/json",specAcceptHeaders)
                request.Header(end+1) = matlab.net.http.field.AcceptField('application/json');
            else
                error("control:api:scriptsListByDatabase:UnsupportedMediaType","Generated OpenAPI Classes only support 'application/json' MediaType.\n" + ...
                    "Operation '%s' does not support this. It may be possible to call this operation by first editing the generated code.","scriptsListByDatabase")
            end
            
            % No body input, so no need to check its content type
            
            % No header parameters

            % Configure default httpOptions
            httpOptions = obj.httpOptions;
            % Never convert API response
            httpOptions.ConvertResponse = false;

            % Configure request verb/method
            request.Method = matlab.net.http.RequestMethod('GET');

            % Build the request URI
            if ~isempty(obj.serverUri)
                % If URI specified in object, use that
                uri = obj.serverUri;
            else
                % If no server specified use base path from OpenAPI spec
                uri = matlab.net.URI("https://management.azure.com");
            end
            % Append the operation end-point
            uri.EncodedPath = uri.EncodedPath + "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/databases/{databaseName}/scripts";

            % Substitute path parameters
            uri.Path(uri.Path == "{" + "subscriptionId" +"}") = subscriptionId;
            uri.Path(uri.Path == "{" + "resourceGroupName" +"}") = resourceGroupName;
            uri.Path(uri.Path == "{" + "clusterName" +"}") = clusterName;
            uri.Path(uri.Path == "{" + "databaseName" +"}") = databaseName;

            % Set query parameters
            uri.Query(end+1) = matlab.net.QueryParameter("api-version", api_version);
            
            % No JSON body parameters

            % No form body parameters

            % Operation does not require authorization

            % Add cookies if set
            request = obj.applyCookies(request, uri);

            % Call preSend
            [request, httpOptions, uri] = obj.preSend("scriptsListByDatabase", request, httpOptions, uri);

            % Perform the request
            [response, ~, history] = send(request, uri, httpOptions);

            % Handle cookies if set
            obj.setCookies(history);

            % Call postSend
            response = obj.postSend("scriptsListByDatabase", response, request, uri, httpOptions);

            % Handle response
            code = response.StatusCode;
            switch (code)
                case 200
                    result = adx.control.models.ScriptListResult(response.Body.Data);
                otherwise % Default output as specified in spec
                    result = adx.control.models.ErrorResponse(response.Body.Data);
            end
        
        end % scriptsListByDatabase method

    end %methods
end %class


