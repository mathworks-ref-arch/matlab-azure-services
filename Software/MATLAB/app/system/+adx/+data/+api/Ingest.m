classdef Ingest < adx.control.BaseClient
    % Ingest Class to run an ingest command

    % Copyright 2023 The MathWorks, Inc.

    % Class properties
    properties
        dataplane = true
    end

    % Class methods
    methods
        function obj = Ingest(options)
            arguments
                options.configFile string {mustBeTextScalar}
                options.serverUri matlab.net.URI
                options.httpOptions matlab.net.http.HTTPOptions
                options.preferredAuthMethod string {mustBeTextScalar}
                options.bearerToken string {mustBeTextScalar};
                options.apiKey string {mustBeTextScalar};
                options.httpCredentials matlab.net.http.Credentials
                options.cookies matlab.net.http.field.CookieField
                options.database string {mustBeTextScalar}
                options.cluster string {mustBeTextScalar}
            end
            % Call base constructor to override any configured settings
            args = namedargs2cell(options);
            obj@adx.control.BaseClient(args{:})
        end

        function [code, result, response] = ingestRun(obj, table, data, options)
            % ingestRun

            arguments
                obj adx.data.api.Ingest
                table string {mustBeTextScalar}
                % data should be utf8 encoded if textual
                data string
                options.database string {mustBeTextScalar} = obj.database
                options.cluster string {mustBeTextScalar} = obj.cluster
                options.streamFormat adx.data.models.StreamFormat
                options.mappingName string {mustBeTextScalar}
            end

            if isfield(options, 'cluster') && strlength(options.cluster) > 0
                if startsWith(options.cluster, 'https://ingest-')
                    cluster = options.cluster;
                else
                    cluster = strrep(options.cluster, 'https://', 'https://ingest-');
                end
            else
                error("adx:data:api:ingestRun:DatabaseNotDefined","Neither cluster parameter nor a configuration file cluster field is defined");
            end

            if isfield(options, 'database') && strlength(options.database) > 0
                database = options.database;
            else
                error("adx:data:api:ingestRun:DatabaseNotDefined","Neither database parameter nor a configuration file database field is defined");
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
                error("adx:data:api:Ingest:UnsupportedMediaType","Generated OpenAPI Classes only support 'application/json' MediaType.\n" + ...
                    "Operation '%s' does not support this. It may be possible to call this operation by first editing the generated code.","ingestRun");
            end

            % No body input, so no need to check its content type

            % Azure recommends enabling Keep-Alive
            request.Header(end+1) = matlab.net.http.HeaderField('Connection','Keep-Alive');

            % No header parameters
            % TODO Review headers https://learn.microsoft.com/en-us/azure/data-explorer/kusto/api/rest/streaming-ingest

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
            uri.EncodedPath = uri.EncodedPath + "/v1/rest/ingest/" + string(database) + "/" + string(table);

            % No path parameters

            % Set query parameters
            if isfield(options, 'streamFormat')
                % See: https://learn.microsoft.com/en-us/azure/data-explorer/ingestion-supported-formats 
                uri.Query(end+1) = matlab.net.QueryParameter("streamFormat", string(options.streamFormat));
                if options.streamFormat == adx.data.models.StreamFormat.JSON || ...
                    options.streamFormat == adx.data.models.StreamFormat.MultiJSON || ...
                    options.streamFormat == adx.data.models.StreamFormat.Avro
                    if ~(strlength(options.mappingName) > 0)
                        % Required if streamFormat is one of JSON, MultiJSON, or Avro
                        % See: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/management/mappings
                        % https://learn.microsoft.com/en-us/azure/data-explorer/kusto/management/create-ingestion-mapping-command
                        error("adx:data:api:Ingest", "mappingName is required if streamFormat is one of JSON, MultiJSON, or Avro");                    
                    end
                end
            end

            % Sometimes optional add it if present
            if isfield(options, 'mappingName')
                uri.Query(end+1) = matlab.net.QueryParameter("mappingName", options.mappingName);
            end

            request.Body(1).Payload = data;

            % No JSON body parameters

            % No form body parameters

            % Operation does not require authorization

            % Add cookies if set
            request = obj.applyCookies(request, uri);

            % Call preSend
            [request, httpOptions, uri] = obj.preSend("ingestRun", request, httpOptions, uri);

            % Perform the request
            [response, ~, history] = send(request, uri, httpOptions);

            % Handle cookies if set
            obj.setCookies(history);

            % Call postSend
            response = obj.postSend("ingestRun", response, request, uri, httpOptions);

            % Handle response
            code = response.StatusCode;
            switch (code)
                case 200
                    %result = adx.data.models.QueryV2ResponseRaw().fromJSON(response.Body.Data);
                    result = response.Body.Data;

                otherwise % Default output as specified in spec
                    % see https://learn.microsoft.com/en-us/azure/data-explorer/error-codes
                    result = adx.control.models.ErrorResponse(response.Body.Data);
            end
        end
    end
end