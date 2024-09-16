classdef AttachedDatabaseConfigurations < adx.control.BaseClient
    % AttachedDatabaseConfigurations No description provided
    %
    % AttachedDatabaseConfigurations Properties:
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
    % AttachedDatabaseConfigurations Methods:
    %
    %   AttachedDatabaseConfigurations - Constructor
    %   attachedDatabaseConfigurationsCheckNameAvailability - 
    %   attachedDatabaseConfigurationsCreateOrUpdate - 
    %   attachedDatabaseConfigurationsDelete - 
    %   attachedDatabaseConfigurationsGet - 
    %   attachedDatabaseConfigurationsListByCluster - 
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
        function obj = AttachedDatabaseConfigurations(options)
            % AttachedDatabaseConfigurations Constructor, creates a AttachedDatabaseConfigurations instance.
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
            %   client = adx.control.api.AttachedDatabaseConfigurations();
            %
            %   % Create a client for alternative server/base URI
            %   client = adx.control.api.AttachedDatabaseConfigurations("serverUri","https://example.com:1234/api/");
            %
            %   % Create a client loading configuration options from 
            %   % JSON configuration file
            %   client = adx.control.api.AttachedDatabaseConfigurations("configFile","myconfig.json");
            %
            %   % Create a client with alternative HTTPOptions and an API key
            %   client = adx.control.api.AttachedDatabaseConfigurations("httpOptions",...
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

        function [code, result, response] = attachedDatabaseConfigurationsCheckNameAvailability(obj, resourceGroupName, clusterName, api_version, subscriptionId, AttachedDatabaseConfigurationsCheckNameRequest)
            % attachedDatabaseConfigurationsCheckNameAvailability No summary provided
            % Checks that the attached database configuration resource name is valid and is not already in use.
            %
            % Required parameters:
            %   resourceGroupName - The name of the resource group. The name is case insensitive., Type: string
            %   clusterName - The name of the Kusto cluster., Type: string
            %   api_version - The API version to use for this operation., Type: string
            %   subscriptionId - The ID of the target subscription., Type: string
            %   AttachedDatabaseConfigurationsCheckNameRequest - The name of the resource., Type: AttachedDatabaseConfigurationsCheckNameRequest
            %       Required properties in the model for this call:
            %           name
            %           type
            %       Optional properties in the model for this call:
            %
            % No optional parameters
            %
            % Responses:
            %   200: OK -- Operation to check the kusto resource name availability was successful.
            %   0: Error response describing why the operation failed.
            %
            % Returns: CheckNameResult
            %
            % See Also: adx.control.models.CheckNameResult

            arguments
              obj adx.control.api.AttachedDatabaseConfigurations
              resourceGroupName string
              clusterName string
              api_version string
              subscriptionId string
              AttachedDatabaseConfigurationsCheckNameRequest adx.control.models.AttachedDatabaseConfigurationsCheckNameRequest
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
                error("control:api:attachedDatabaseConfigurationsCheckNameAvailability:UnsupportedMediaType","Generated OpenAPI Classes only support 'application/json' MediaType.\n" + ...
                    "Operation '%s' does not support this. It may be possible to call this operation by first editing the generated code.","attachedDatabaseConfigurationsCheckNameAvailability")
            end
            
            % Verify that operation supports JSON or FORM as input
            specContentTypeHeaders = [...
                "application/json", ...
            ];
            if ismember("application/json",specContentTypeHeaders)
                request.Header(end+1) = matlab.net.http.field.ContentTypeField('application/json');
            elseif ismember("application/x-www-form-urlencoded",specContentTypeHeaders)
                request.Header(end+1) = matlab.net.http.field.ContentTypeField('application/x-www-form-urlencoded');
            else
                error("control:api:attachedDatabaseConfigurationsCheckNameAvailability:UnsupportedMediaType","Generated OpenAPI Classes only support 'application/json' and 'application/x-www-form-urlencoded' MediaTypes.\n" + ...
                    "Operation '%s' does not support this. It may be possible to call this operation by first editing the generated code.","attachedDatabaseConfigurationsCheckNameAvailability")
            end
            
            % No header parameters

            % Configure default httpOptions
            httpOptions = obj.httpOptions;
            % Never convert API response
            httpOptions.ConvertResponse = false;

            % Configure request verb/method
            request.Method = matlab.net.http.RequestMethod('POST');

            % Build the request URI
            if ~isempty(obj.serverUri)
                % If URI specified in object, use that
                uri = obj.serverUri;
            else
                % If no server specified use base path from OpenAPI spec
                uri = matlab.net.URI("https://management.azure.com");
            end
            % Append the operation end-point
            uri.EncodedPath = uri.EncodedPath + "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/attachedDatabaseConfigurationCheckNameAvailability";

            % Substitute path parameters
            uri.Path(uri.Path == "{" + "resourceGroupName" +"}") = resourceGroupName;
            uri.Path(uri.Path == "{" + "clusterName" +"}") = clusterName;
            uri.Path(uri.Path == "{" + "subscriptionId" +"}") = subscriptionId;

            % Set query parameters
            uri.Query(end+1) = matlab.net.QueryParameter("api-version", api_version);
            
            % Set JSON Body
            requiredProperties = [...
                "name",...
                "type",...
            ];
            optionalProperties = [...
            ];
            request.Body(1).Payload = AttachedDatabaseConfigurationsCheckNameRequest.getPayload(requiredProperties,optionalProperties);

            % No form body parameters

            % Operation does not require authorization

            % Add cookies if set
            request = obj.applyCookies(request, uri);

            % Call preSend
            [request, httpOptions, uri] = obj.preSend("attachedDatabaseConfigurationsCheckNameAvailability", request, httpOptions, uri);

            % Perform the request
            [response, ~, history] = send(request, uri, httpOptions);

            % Handle cookies if set
            obj.setCookies(history);

            % Call postSend
            response = obj.postSend("attachedDatabaseConfigurationsCheckNameAvailability", response, request, uri, httpOptions);

            % Handle response
            code = response.StatusCode;
            switch (code)
                case 200
                    result = adx.control.models.CheckNameResult(response.Body.Data);
                otherwise % Default output as specified in spec
                    result = adx.control.models.ErrorResponse(response.Body.Data);
            end
        
        end % attachedDatabaseConfigurationsCheckNameAvailability method

        function [code, result, response] = attachedDatabaseConfigurationsCreateOrUpdate(obj, resourceGroupName, clusterName, attachedDatabaseConfigurationName, subscriptionId, api_version, AttachedDatabaseConfiguration)
            % attachedDatabaseConfigurationsCreateOrUpdate No summary provided
            % Creates or updates an attached database configuration.
            %
            % Required parameters:
            %   resourceGroupName - The name of the resource group. The name is case insensitive., Type: string
            %   clusterName - The name of the Kusto cluster., Type: string
            %   attachedDatabaseConfigurationName - The name of the attached database configuration., Type: string
            %   subscriptionId - The ID of the target subscription., Type: string
            %   api_version - The API version to use for this operation., Type: string
            %   AttachedDatabaseConfiguration - The database parameters supplied to the CreateOrUpdate operation., Type: AttachedDatabaseConfiguration
            %       Required properties in the model for this call:
            %       Optional properties in the model for this call:
            %           location
            %           xproperties
            %
            % No optional parameters
            %
            % Responses:
            %   200: Successfully updated the database.
            %   201: Successfully created the database.
            %   202: Accepted the create database request.
            %   0: Error response describing why the operation failed.
            %
            % Returns: AttachedDatabaseConfiguration
            %
            % See Also: adx.control.models.AttachedDatabaseConfiguration

            arguments
              obj adx.control.api.AttachedDatabaseConfigurations
              resourceGroupName string
              clusterName string
              attachedDatabaseConfigurationName string
              subscriptionId string
              api_version string
              AttachedDatabaseConfiguration adx.control.models.AttachedDatabaseConfiguration
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
                error("control:api:attachedDatabaseConfigurationsCreateOrUpdate:UnsupportedMediaType","Generated OpenAPI Classes only support 'application/json' MediaType.\n" + ...
                    "Operation '%s' does not support this. It may be possible to call this operation by first editing the generated code.","attachedDatabaseConfigurationsCreateOrUpdate")
            end
            
            % Verify that operation supports JSON or FORM as input
            specContentTypeHeaders = [...
                "application/json", ...
            ];
            if ismember("application/json",specContentTypeHeaders)
                request.Header(end+1) = matlab.net.http.field.ContentTypeField('application/json');
            elseif ismember("application/x-www-form-urlencoded",specContentTypeHeaders)
                request.Header(end+1) = matlab.net.http.field.ContentTypeField('application/x-www-form-urlencoded');
            else
                error("control:api:attachedDatabaseConfigurationsCreateOrUpdate:UnsupportedMediaType","Generated OpenAPI Classes only support 'application/json' and 'application/x-www-form-urlencoded' MediaTypes.\n" + ...
                    "Operation '%s' does not support this. It may be possible to call this operation by first editing the generated code.","attachedDatabaseConfigurationsCreateOrUpdate")
            end
            
            % No header parameters

            % Configure default httpOptions
            httpOptions = obj.httpOptions;
            % Never convert API response
            httpOptions.ConvertResponse = false;

            % Configure request verb/method
            request.Method = matlab.net.http.RequestMethod('PUT');

            % Build the request URI
            if ~isempty(obj.serverUri)
                % If URI specified in object, use that
                uri = obj.serverUri;
            else
                % If no server specified use base path from OpenAPI spec
                uri = matlab.net.URI("https://management.azure.com");
            end
            % Append the operation end-point
            uri.EncodedPath = uri.EncodedPath + "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/attachedDatabaseConfigurations/{attachedDatabaseConfigurationName}";

            % Substitute path parameters
            uri.Path(uri.Path == "{" + "resourceGroupName" +"}") = resourceGroupName;
            uri.Path(uri.Path == "{" + "clusterName" +"}") = clusterName;
            uri.Path(uri.Path == "{" + "attachedDatabaseConfigurationName" +"}") = attachedDatabaseConfigurationName;
            uri.Path(uri.Path == "{" + "subscriptionId" +"}") = subscriptionId;

            % Set query parameters
            uri.Query(end+1) = matlab.net.QueryParameter("api-version", api_version);
            
            % Set JSON Body
            requiredProperties = [...
            ];
            optionalProperties = [...
                "location",...
                "xproperties",...
            ];
            request.Body(1).Payload = AttachedDatabaseConfiguration.getPayload(requiredProperties,optionalProperties);

            % No form body parameters

            % Operation does not require authorization

            % Add cookies if set
            request = obj.applyCookies(request, uri);

            % Call preSend
            [request, httpOptions, uri] = obj.preSend("attachedDatabaseConfigurationsCreateOrUpdate", request, httpOptions, uri);

            % Perform the request
            [response, ~, history] = send(request, uri, httpOptions);

            % Handle cookies if set
            obj.setCookies(history);

            % Call postSend
            response = obj.postSend("attachedDatabaseConfigurationsCreateOrUpdate", response, request, uri, httpOptions);

            % Handle response
            code = response.StatusCode;
            switch (code)
                case 200
                    result = adx.control.models.AttachedDatabaseConfiguration(response.Body.Data);
                case 201
                    result = adx.control.models.AttachedDatabaseConfiguration(response.Body.Data);
                case 202
                    result = adx.control.models.AttachedDatabaseConfiguration(response.Body.Data);
                otherwise % Default output as specified in spec
                    result = adx.control.models.ErrorResponse(response.Body.Data);
            end
        
        end % attachedDatabaseConfigurationsCreateOrUpdate method

        function [code, result, response] = attachedDatabaseConfigurationsDelete(obj, resourceGroupName, clusterName, attachedDatabaseConfigurationName, subscriptionId, api_version)
            % attachedDatabaseConfigurationsDelete No summary provided
            % Deletes the attached database configuration with the given name.
            %
            % Required parameters:
            %   resourceGroupName - The name of the resource group. The name is case insensitive., Type: string
            %   clusterName - The name of the Kusto cluster., Type: string
            %   attachedDatabaseConfigurationName - The name of the attached database configuration., Type: string
            %   subscriptionId - The ID of the target subscription., Type: string
            %   api_version - The API version to use for this operation., Type: string
            %
            % No optional parameters
            %
            % Responses:
            %   200: Successfully deleted the database.
            %   202: Accepted.
            %   204: The specified database does not exist.
            %   0: Error response describing why the operation failed.
            %
            % Returns: 
            %
            % See Also: adx.control.models.

            arguments
              obj adx.control.api.AttachedDatabaseConfigurations
              resourceGroupName string
              clusterName string
              attachedDatabaseConfigurationName string
              subscriptionId string
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
                error("control:api:attachedDatabaseConfigurationsDelete:UnsupportedMediaType","Generated OpenAPI Classes only support 'application/json' MediaType.\n" + ...
                    "Operation '%s' does not support this. It may be possible to call this operation by first editing the generated code.","attachedDatabaseConfigurationsDelete")
            end
            
            % No body input, so no need to check its content type
            
            % No header parameters

            % Configure default httpOptions
            httpOptions = obj.httpOptions;
            % Never convert API response
            httpOptions.ConvertResponse = false;

            % Configure request verb/method
            request.Method = matlab.net.http.RequestMethod('DELETE');

            % Build the request URI
            if ~isempty(obj.serverUri)
                % If URI specified in object, use that
                uri = obj.serverUri;
            else
                % If no server specified use base path from OpenAPI spec
                uri = matlab.net.URI("https://management.azure.com");
            end
            % Append the operation end-point
            uri.EncodedPath = uri.EncodedPath + "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/attachedDatabaseConfigurations/{attachedDatabaseConfigurationName}";

            % Substitute path parameters
            uri.Path(uri.Path == "{" + "resourceGroupName" +"}") = resourceGroupName;
            uri.Path(uri.Path == "{" + "clusterName" +"}") = clusterName;
            uri.Path(uri.Path == "{" + "attachedDatabaseConfigurationName" +"}") = attachedDatabaseConfigurationName;
            uri.Path(uri.Path == "{" + "subscriptionId" +"}") = subscriptionId;

            % Set query parameters
            uri.Query(end+1) = matlab.net.QueryParameter("api-version", api_version);
            
            % No JSON body parameters

            % No form body parameters

            % Operation does not require authorization

            % Add cookies if set
            request = obj.applyCookies(request, uri);

            % Call preSend
            [request, httpOptions, uri] = obj.preSend("attachedDatabaseConfigurationsDelete", request, httpOptions, uri);

            % Perform the request
            [response, ~, history] = send(request, uri, httpOptions);

            % Handle cookies if set
            obj.setCookies(history);

            % Call postSend
            response = obj.postSend("attachedDatabaseConfigurationsDelete", response, request, uri, httpOptions);

            % Handle response
            code = response.StatusCode;
            switch (code)
                case 200
                    result = response.Body.Data;
                case 202
                    result = response.Body.Data;
                case 204
                    result = response.Body.Data;
                otherwise % Default output as specified in spec
                    result = adx.control.models.ErrorResponse(response.Body.Data);
            end
        
        end % attachedDatabaseConfigurationsDelete method

        function [code, result, response] = attachedDatabaseConfigurationsGet(obj, resourceGroupName, clusterName, attachedDatabaseConfigurationName, subscriptionId, api_version)
            % attachedDatabaseConfigurationsGet No summary provided
            % Returns an attached database configuration.
            %
            % Required parameters:
            %   resourceGroupName - The name of the resource group. The name is case insensitive., Type: string
            %   clusterName - The name of the Kusto cluster., Type: string
            %   attachedDatabaseConfigurationName - The name of the attached database configuration., Type: string
            %   subscriptionId - The ID of the target subscription., Type: string
            %   api_version - The API version to use for this operation., Type: string
            %
            % No optional parameters
            %
            % Responses:
            %   200: Successfully retrieved the specified attached database configuration.
            %   0: Error response describing why the operation failed.
            %
            % Returns: AttachedDatabaseConfiguration
            %
            % See Also: adx.control.models.AttachedDatabaseConfiguration

            arguments
              obj adx.control.api.AttachedDatabaseConfigurations
              resourceGroupName string
              clusterName string
              attachedDatabaseConfigurationName string
              subscriptionId string
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
                error("control:api:attachedDatabaseConfigurationsGet:UnsupportedMediaType","Generated OpenAPI Classes only support 'application/json' MediaType.\n" + ...
                    "Operation '%s' does not support this. It may be possible to call this operation by first editing the generated code.","attachedDatabaseConfigurationsGet")
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
            uri.EncodedPath = uri.EncodedPath + "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/attachedDatabaseConfigurations/{attachedDatabaseConfigurationName}";

            % Substitute path parameters
            uri.Path(uri.Path == "{" + "resourceGroupName" +"}") = resourceGroupName;
            uri.Path(uri.Path == "{" + "clusterName" +"}") = clusterName;
            uri.Path(uri.Path == "{" + "attachedDatabaseConfigurationName" +"}") = attachedDatabaseConfigurationName;
            uri.Path(uri.Path == "{" + "subscriptionId" +"}") = subscriptionId;

            % Set query parameters
            uri.Query(end+1) = matlab.net.QueryParameter("api-version", api_version);
            
            % No JSON body parameters

            % No form body parameters

            % Operation does not require authorization

            % Add cookies if set
            request = obj.applyCookies(request, uri);

            % Call preSend
            [request, httpOptions, uri] = obj.preSend("attachedDatabaseConfigurationsGet", request, httpOptions, uri);

            % Perform the request
            [response, ~, history] = send(request, uri, httpOptions);

            % Handle cookies if set
            obj.setCookies(history);

            % Call postSend
            response = obj.postSend("attachedDatabaseConfigurationsGet", response, request, uri, httpOptions);

            % Handle response
            code = response.StatusCode;
            switch (code)
                case 200
                    result = adx.control.models.AttachedDatabaseConfiguration(response.Body.Data);
                otherwise % Default output as specified in spec
                    result = adx.control.models.ErrorResponse(response.Body.Data);
            end
        
        end % attachedDatabaseConfigurationsGet method

        function [code, result, response] = attachedDatabaseConfigurationsListByCluster(obj, resourceGroupName, clusterName, subscriptionId, api_version)
            % attachedDatabaseConfigurationsListByCluster No summary provided
            % Returns the list of attached database configurations of the given Kusto cluster.
            %
            % Required parameters:
            %   resourceGroupName - The name of the resource group. The name is case insensitive., Type: string
            %   clusterName - The name of the Kusto cluster., Type: string
            %   subscriptionId - The ID of the target subscription., Type: string
            %   api_version - The API version to use for this operation., Type: string
            %
            % No optional parameters
            %
            % Responses:
            %   200: Successfully retrieved the list of attached database configurations.
            %   0: Error response describing why the operation failed.
            %
            % Returns: AttachedDatabaseConfigurationListResult
            %
            % See Also: adx.control.models.AttachedDatabaseConfigurationListResult

            arguments
              obj adx.control.api.AttachedDatabaseConfigurations
              resourceGroupName string
              clusterName string
              subscriptionId string
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
                error("control:api:attachedDatabaseConfigurationsListByCluster:UnsupportedMediaType","Generated OpenAPI Classes only support 'application/json' MediaType.\n" + ...
                    "Operation '%s' does not support this. It may be possible to call this operation by first editing the generated code.","attachedDatabaseConfigurationsListByCluster")
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
            uri.EncodedPath = uri.EncodedPath + "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kusto/clusters/{clusterName}/attachedDatabaseConfigurations";

            % Substitute path parameters
            uri.Path(uri.Path == "{" + "resourceGroupName" +"}") = resourceGroupName;
            uri.Path(uri.Path == "{" + "clusterName" +"}") = clusterName;
            uri.Path(uri.Path == "{" + "subscriptionId" +"}") = subscriptionId;

            % Set query parameters
            uri.Query(end+1) = matlab.net.QueryParameter("api-version", api_version);
            
            % No JSON body parameters

            % No form body parameters

            % Operation does not require authorization

            % Add cookies if set
            request = obj.applyCookies(request, uri);

            % Call preSend
            [request, httpOptions, uri] = obj.preSend("attachedDatabaseConfigurationsListByCluster", request, httpOptions, uri);

            % Perform the request
            [response, ~, history] = send(request, uri, httpOptions);

            % Handle cookies if set
            obj.setCookies(history);

            % Call postSend
            response = obj.postSend("attachedDatabaseConfigurationsListByCluster", response, request, uri, httpOptions);

            % Handle response
            code = response.StatusCode;
            switch (code)
                case 200
                    result = adx.control.models.AttachedDatabaseConfigurationListResult(response.Body.Data);
                otherwise % Default output as specified in spec
                    result = adx.control.models.ErrorResponse(response.Body.Data);
            end
        
        end % attachedDatabaseConfigurationsListByCluster method

    end %methods
end %class

