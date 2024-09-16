classdef Management < adx.control.BaseClient
    % Management Class to run a management command

    % Copyright 2023 The MathWorks, Inc.

    % Class properties
    properties
        dataplane = true
    end


    % Class methods
    methods
        function obj = Management(options)
            arguments
                options.configFile string {mustBeTextScalar}
                options.serverUri matlab.net.URI
                options.httpOptions matlab.net.http.HTTPOptions
                options.preferredAuthMethod string {mustBeTextScalar}
                options.bearerToken string {mustBeTextScalar};
                options.apiKey string {mustBeTextScalar};
                options.httpCredentials matlab.net.http.Credentials
                options.cookies matlab.net.http.field.CookieField
                options.scopes string {mustBeTextScalar}
                options.cluster string {mustBeTextScalar}
            end
            % Call base constructor to override any configured settings
            args = namedargs2cell(options);
            obj@adx.control.BaseClient(args{:})
        end

        function [code, result, response, requestId] = managementRun(obj, ManagementRequest, options)
            % managementRun

            arguments
                obj adx.data.api.Management
                ManagementRequest adx.data.models.ManagementRequest
                options.cluster string = obj.cluster
                options.verbose (1,1) logical = false
            end

            if isfield(options, 'cluster') && ~isempty(options.cluster) && ...
                strlength(options.cluster) > 0 && isStringScalar(options.cluster)
                cluster = options.cluster;
            else
                cluster = obj.cluster;
            end

            % Create the request object
            request = matlab.net.http.RequestMessage();

            % Verify that operation supports returning JSON
            specAcceptHeaders = [...
                "application/json", ...
                ]; %#ok<NBRAK2>
            if ismember("application/json",specAcceptHeaders)
                request.Header(end+1) = matlab.net.http.field.AcceptField('application/json');
            else
                error("adx:data:api:Management:UnsupportedMediaType","Class only supports 'application/json' MediaType.\n" + ...
                    "Operation '%s' does not support this. It may be possible to call this operation by first editing the generated code.","mgmtRun");
            end

            % No body input, so no need to check its content type
            request.Header(end+1) = matlab.net.http.HeaderField('Content-Type','application/json');

            requestId = string(javaMethod('randomUUID','java.util.UUID'));
            %if options.verbose; fprintf("Request ID: %s\n", requestId); end
            request = mathworks.internal.adx.setCustomQueryHeaders(request, id=requestId);

            % Azure recommends enabling Keep-Alive
            request.Header(end+1) = matlab.net.http.HeaderField('Connection','Keep-Alive');

            % Configure default httpOptions
            httpOptions = obj.httpOptions;
            % Never convert API response
            httpOptions.ConvertResponse = false;

            % Configure request verb/method
            request.Method =  matlab.net.http.RequestMethod('POST');

            % Build the request URI
            if ~isempty(obj.serverUri)
                % If URI specified in object, use that
                uri = obj.serverUri;
            else
                % If no server specified use base path from OpenAPI spec
                % uri = matlab.net.URI("https://help.kusto.windows.net");
                uri = matlab.net.URI(cluster);
            end
            % Append the operation end-point
            uri.EncodedPath = uri.EncodedPath + "/v1/rest/mgmt";

            % No path parameters

            % Set JSON Body
            requiredProperties = ["csl"]; %#ok<NBRAK2>
            optionalProperties = ["db"]; %#ok<NBRAK2> % TODO properties field
            request.Body(1).Payload = ManagementRequest.getPayload(requiredProperties,optionalProperties);
            
            % No form body parameters

            % Operation does not require authorization

            % Add cookies if set
            request = obj.applyCookies(request, uri);

            % Call preSend
            [request, httpOptions, uri] = obj.preSend("managementRun", request, httpOptions, uri);

            % Perform the request
            [response, fullRequest, history] = send(request, uri, httpOptions); %#ok<ASGLU>

            % Handle cookies if set
            obj.setCookies(history);

            % Call postSend
            response = obj.postSend("managementRun", response, request, uri, httpOptions);

            % Handle response
            code = response.StatusCode;
            switch (code)
                case 200
                    result = adx.data.models.QueryV1ResponseRaw(response.Body.Data);

                otherwise % Default output as specified in spec
                    result = adx.control.models.ErrorResponse(response.Body.Data);
            end
        end
    end %methods


    methods(Access = protected)
        function groups = getPropertyGroups(obj)
            if isscalar(obj)
                % Don't display sensitive values
                % bearerToken, apiKey, clientSecret
                propList = {'serverUri',...
                            'httpOptions',...
                            'preferredAuthMethod',...
                            'httpCredentials',...
                            'apiVersion',...
                            'subscriptionId',...
                            'tenantId',...
                            'clientId',...
                            'database',...
                            'cluster',...
                            'scopes',...
                            'cookies'
                            };
                groups = matlab.mixin.util.PropertyGroup(propList);
            else
                % Nonscalar case: call superclass method
                groups = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
            end
        end %function
    end %methods

end %class

