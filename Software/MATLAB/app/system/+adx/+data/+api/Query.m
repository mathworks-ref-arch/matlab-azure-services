classdef Query < adx.control.BaseClient
    % Query Class to run a KQL query
    %
    % Example:
    %    % Build a request object
    %    request = adx.data.models.QueryRequest();
    %    colName = "myColumn";
    %    message = "Hello World";
    %    
    %    % Set the KQL query fields
    %    request.csl = sprintf('print %s="%s"', colName, message);
    %    % Don't set the database use the default in .json config file
    %    % request.db = "myDatabaseName"
    %    % No adx.data.models.ClientRequestProperties required
    %    % request.requestProperties
    %
    %    % Create the Query object and run the request
    %    query = adx.data.api.Query();
    %    % The default cluster to use is configured using a .json configuration file
    %    % Run the query:
    %    [code, result, response, requestId] = query.queryRun(request); %#ok<ASGLU>
    %
    %    if code == matlab.net.http.StatusCode.OK
    %        % Convert the response to Tables
    %        hwTable = mathworks.internal.adx.queryV2Response2Tables(result);
    %        fprintf("Query (%s) result:\n", request.csl);
    %        disp(hwTable);
    %    else
    %        error('Error running query: %s', request.csl);
    % end


    % Copyright 2023-2024 The MathWorks, Inc.

    % Class properties
    properties
        dataplane = true
    end


    % Class methods
    methods
        function obj = Query(options)
            arguments
                options.configFile string {mustBeTextScalar}
                options.serverUri matlab.net.URI
                options.httpOptions matlab.net.http.HTTPOptions
                options.preferredAuthMethod string {mustBeTextScalar}
                options.bearerToken string {mustBeTextScalar};
                options.apiKey string {mustBeTextScalar};
                options.httpCredentials matlab.net.http.Credentials
                options.cookies matlab.net.http.field.CookieField
                options.scopes string 
                options.cluster string {mustBeTextScalar}
                options.apiVersion string
            end
            % Call base constructor to override any configured settings
            args = namedargs2cell(options);
            obj@adx.control.BaseClient(args{:})
        end

        function [code, result, response, requestId] = queryRun(obj, queryRequest, options)
            % queryRun Runs a KQL query
            %
            % Required argument(s)
            %   queryRequest: A populated adx.data.models.QueryRequest that defines the
            %                 query, the database and potentially query properties.
            %
            % Optional named arguments:
            %   cluster: A cluster URL as a scalar string.
            %
            %   apiVersion: URL path API version field, if not provided and the query starts
            %               with "." v1 is used otherwise v2 is used.
            %
            %   skipRowsArrayDecode: Returns a adx.data.models.QueryV2ResponseUnparsedRows where
            %                        the frames are parsed but the array of rows are not parsed
            %                        into individual values if true. Otherwise a
            %                        adx.data.models.QueryV2ResponseRaw is returned.
            %                        Only applied in the case of v2 APIs.
            %                        Default is false.
            %
            %   skipResponseDecode: Logical flag to determine if the HTTP response should be
            %                       be parsed at all. If true the result is returned as a
            %                       adx.data.models.QueryV2ResponseRaw.empty or a 
            %                       adx.data.models.QueryV1ResponseRaw.empty as appropriate.
            %                       Default is false.
            %
            %   verbose: Logical to enable additional output. Default is false.
            %
            % Return values:
            %   code: HTTP status code, 200 (matlab.net.http.StatusCode.OK) indicates success.
            %
            %   result: Returned data is various forms or an ErrorResponse:
            %           adx.control.models.ErrorResponse
            %           adx.data.models.QueryV2ResponseRaw
            %           adx.data.models.QueryV2ResponseUnparsedRows
            %           adx.data.models.QueryV1ResponseRaw
            %
            %   response: The original HTTP response to the matlab.net.http.RequestMessage.send
            %             The response may have been optionally processed by the baseClient
            %             postSend method.
            %
            %  requestId: A UUID value generated and submitted with the query to
            %             identify it.

            arguments
                obj adx.data.api.Query
                queryRequest adx.data.models.QueryRequest
                options.cluster string {mustBeTextScalar, mustBeNonzeroLengthText} = obj.cluster
                options.apiVersion string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.skipRowsArrayDecode (1,1) logical = false;
                options.skipResponseDecode (1,1) logical = false;
                options.verbose (1,1) logical = false;
            end

            if options.verbose; fprintf("Starting query\n"); end

            if isfield(options, 'cluster') && strlength(options.cluster) > 0
                cluster = options.cluster;
            else
                error("adx:data:api:Query:ClusterNotDefined","Neither cluster parameter nor a configuration file cluster field is defined");
            end
            if options.verbose; fprintf("Cluster: %s\n", cluster); end
            % Create the request object
            request = matlab.net.http.RequestMessage();

            % Verify that operation supports returning JSON
            specAcceptHeaders = [...
                "application/json", ...
                ]; %#ok<NBRAK2>
            if ismember("application/json",specAcceptHeaders)
                request.Header(end+1) = matlab.net.http.field.AcceptField('application/json');
            else
                error("adx:data:api:Query:UnsupportedMediaType","Class only supports 'application/json' MediaType.\n" + ...
                    "Operation '%s' does not support this. It may be possible to call this operation by first editing the generated code.","queryRun");
            end
            
            % Verify that operation supports JSON or FORM as input
            specContentTypeHeaders = [...
                "application/json", ...
            ]; %#ok<NBRAK2>
            if ismember("application/json",specContentTypeHeaders)
                request.Header(end+1) = matlab.net.http.field.ContentTypeField('application/json');
            elseif ismember("application/x-www-form-urlencoded",specContentTypeHeaders)
                request.Header(end+1) = matlab.net.http.field.ContentTypeField('application/x-www-form-urlencoded');
            else
                error("adx:data:api:Query:executeStatement:UnsupportedMediaType","Generated OpenAPI Classes only support 'application/json' and 'application/x-www-form-urlencoded' MediaTypes.\n" + ...
                    "Operation '%s' does not support this. It may be possible to call this operation by first editing the generated code.","queryRun")
            end

            requestId = string(javaMethod('randomUUID','java.util.UUID'));
            if options.verbose; fprintf("Request ID: %s\n", requestId); end
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
            if isfield(options, "apiVersion")
                apiVersion = options.apiVersion;
            % Don't use the Object's apiVerson value as it will be 2022-11-11
            % or similar based on the control api baseClient
            % elseif isprop(obj, "apiVersion") && strlength(obj.apiVersion) > 0
            %     apiVersion = obj.apiVersion;
            elseif startsWith(strip(queryRequest.csl), ".")
                apiVersion = "v1";
            else
                apiVersion = "v2";
            end
            if options.verbose; fprintf("apiVersion: %s\n", apiVersion); end
            if ~(strcmpi(apiVersion, "v2") || strcmpi(apiVersion, "v1"))
                warning("adx:queryRun", "Unexpected API version: %s", apiVersion);
            end
            uri.EncodedPath = uri.EncodedPath + "/" +apiVersion + "/rest/query";

            % No path parameters

            % Set query parameters
            %uri.Query(end+1) = matlab.net.QueryParameter("api-version", obj.apiVersion);

            % Set JSON Body
            requiredProperties = ["db", "csl"];
            optionalProperties = ["requestProperties"]; %#ok<NBRAK2>
            request.Body(1).Payload = queryRequest.getPayload(requiredProperties, optionalProperties);
            if options.verbose; fprintf("Database: %s\n", queryRequest.db); end
            if options.verbose; fprintf("CSL: %s\n", queryRequest.csl); end

            % No form body parameters

            % Operation does not require authorization

            % Add cookies if set
            request = obj.applyCookies(request, uri);

            % Call preSend
            if options.verbose; fprintf("Running preSend\n"); end
            [request, httpOptions, uri] = obj.preSend("queryRun", request, httpOptions, uri);

            % Perform the request
            if options.verbose; fprintf("Sending request\n"); end
            [response, full, history] = send(request, uri, httpOptions); %#ok<ASGLU>

            % Handle cookies if set
            obj.setCookies(history);

            % Call postSend
            if options.verbose; fprintf("Running postSend\n"); end
            response = obj.postSend("queryRun", response, request, uri, httpOptions);

            % Handle response
            if options.verbose; fprintf("Response code: %d\n", response.StatusCode); end
            code = response.StatusCode;
            switch (code)
                case 200
                    if strcmp(apiVersion, "v2")
                        if options.skipResponseDecode
                            result = adx.data.models.QueryV2ResponseRaw.empty;
                        else
                            if options.skipRowsArrayDecode
                                result = adx.data.models.QueryV2ResponseUnparsedRows(response.Body.Data);
                            else
                                result = adx.data.models.QueryV2ResponseRaw(response.Body.Data);
                            end
                        end
                    elseif strcmp(apiVersion, "v1")
                        if options.skipResponseDecode
                            result = adx.data.models.QueryV1ResponseRaw.empty;
                        else
                            result = adx.data.models.QueryV1ResponseRaw(response.Body.Data);
                        end
                    else
                        warning("adx:queryRun", "Unexpected API version: %s, returning raw data", apiVersion);
                        result = response.Body.Data;
                    end
                   
                otherwise % Default output as specified in spec
                    result = adx.control.models.ErrorResponse(response.Body.Data);
            end
        end
    end
end