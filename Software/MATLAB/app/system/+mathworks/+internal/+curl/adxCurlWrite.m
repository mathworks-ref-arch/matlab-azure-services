function [tf, result, id] = adxCurlWrite(options)
    % adxCurlWrite adx caller for mathworks.internal.curlWrite
    % Inserts custom headers required by ADX.
    %
    % This function may be changed or removed in a future release without
    % notice. currently only windows is supported.
    % It is a Proof of Concept testing mechanism to enable TCP keep-alive
    % Packets only, it should be avoided in production use.
    %
    % Arguments:
    %   clusterUrl: A cluster URL including https:// as scalar text if not provided
    %               an attempt will be made to read the value from adx.Client.Settings.json
    %
    %   urlPath: Query URL path as scalar text, default: "/v1/rest/query"
    %
    %   query: KQL query to execute as scalar text, default (for PoC purposes):
    %          "print mycol=""Hello World"""
    %          Alternatively a a file containing the complete Query body can be
    %          provided byt prefixing the file name with a "@" symbol as
    %          normal in curl command syntax.
    %          When the JSON body for the query is constructed only the csl
    %          and db fields are populated, if further properties are
    %          required then the JSON body should be provided in its
    %          entirety as described above
    %
    %   bearerToken: A bearerToken as scalar text if not provided an attempt will
    %                be made to read the value from adx.Client.Settings.json
    %
    %   id: Request id header value as scalar text, if not provided a UUID is created
    %
    %
    %   skipJSONDecode: A logical to determine if JSON is decode using MATLAB's
    %                   jsondecode or not, default is true
    %
    %   propertyNames: Property names to be applies to the query, specified as a
    %                  string array
    %
    %   propertyValues: Property values that correspond the propertyNames, specified
    %                   as a cell array
    %
    %   verbose: A logical to enable additional feedback, default is true
    %            WARNING: verbose output will display the bearer token
    %
    %
    % Returned values:
    %   tf: Logical that indicates if a HTTP status 200 was returned
    %
    %   result: Result of the query as a string or a decoded JSON struct
    %           In certain error cases an empty struct is returned
    %
    %   id: Request Id
    %
    %
    % Examples:
    %
    %   If called with no arguments with a adx.Client.Settings.json file
    %   present containing a valid bearer token the query: print mycol='Hello World'
    %   should run, returning a logical true, populated result struct and
    %   request UUID:
    %
    %   [tf, result, id] = mathworks.internal.curl.adxCurlWrite()
    %
    %
    %   Provide key arguments:
    %
    %   clusterUrl = "https://mycluster.westeurope.kusto.windows.net";
    %   query = 'print mycol="Hello World"';
    %   bearerToken = "eyJ0e<REDACTED>c1RuQ";
    %   [tf, result, id] = mathworks.internal.adxCurlWrite(clusterUrl=clusterUrl, bearerToken=bearerToken, query=query, verbose=true)
    %
    %
    %   Convert the primary result to a MATLAB table
    %   Assumes the url path is specifying a v1 API, as per default:
    %
    %   [tf, result, id] = mathworks.internal.curl.adxCurlWrite(skipJSONDecode=true);
    %   [primaryResult, resultTables] = mathworks.internal.adx.queryV1Response2Tables(result);
    %
    %
    %   Set sample request properties & convert to a MATLAB table:
    %
    %   propertyNames = {"notruncation", "query_datetimescope_column", "servertimeout"};
    %   tenMinDuration = minutes(10);
    %   propertyValues = {true, "mycol", tenMinDuration};
    %   [tf,result,id] = mathworks.internal.curl.adxCurlWrite(verbose=true, propertyNames=propertyNames, propertyValues=propertyValues, skipJSONDecode=true)
    %   [primaryResult, ~] = mathworks.internal.adx.queryV1Response2Tables(result)

    % Copyright 2024 The MathWorks

    arguments
        options.clusterUrl string {mustBeTextScalar} = ""
        options.urlPath string {mustBeTextScalar} = "/v1/rest/query"
        options.database string {mustBeTextScalar} = ""
        options.query string {mustBeTextScalar} = "print mycol='Hello World'" % For PoC testing
        options.bearerToken string {mustBeTextScalar} = ""
        options.id string {mustBeTextScalar} = mathworks.utils.UUID
        options.skipJSONDecode (1,1) logical = false
        options.propertyNames (1,:) string {mustBeNonzeroLengthText}
        options.propertyValues (1,:) cell
        options.verbose (1,1) logical = false
    end

    if isfield(options, "propertyNames") && isfield(options, "propertyValues")
        if numel(options.propertyNames) ~= numel(options.propertyValues)
            error("adx:adxCurlWrite", "The number of propertyNames and propertyValues must match");
        else
            if options.verbose; fprintf("Applying properties\n"); end
            applyProperties = true;
        end
    else
        applyProperties = false;
    end

    id = options.id;
    headersCell = {'x-ms-client-request-id', char(options.id)};

    userName = char(java.lang.System.getProperty("user.name"));
    headersCell(end+1,:) = {'x-ms-user', userName};
    headersCell(end+1,:) = {'x-ms-user-id', userName};

    tmpWebOptions = weboptions;
    headersCell(end+1,:) = {'x-ms-app', tmpWebOptions.UserAgent};
    headersCell(end+1,:) = {'x-ms-client-version', tmpWebOptions.UserAgent};

    % Use a query object to get the default cluster
    if strlength(options.clusterUrl) == 0
        queryObj = adx.data.api.Query();
        clusterUrl = queryObj.cluster;
    else
        clusterUrl = options.clusterUrl;
    end
    clusterUrl = string(strip(clusterUrl, 'right', '/'));
    urlWithPath = clusterUrl + options.urlPath;

    if strlength(options.bearerToken) > 0
        bearerToken = options.bearerToken;
    else
        uri = matlab.net.URI(urlWithPath);
        cluster = uri.Scheme + "://" + uri.Host;
        queryObj = adx.data.api.Query("cluster", cluster);
        if isprop(queryObj, 'dataBearerToken')
            bearerToken = queryObj.dataBearerToken;
        else
            error("adx:adxCurlWrite", "Cached Bearer Token or bearerToken argument not found.\nRunning a trivial query e.g.:\n   mathworks.adx.run('print mycol=""Hello World""')\nwill cache a fresh cache a token");
        end
    end

    try
        jwt = mathworks.utils.jwt.JWT(bearerToken);
    catch ME
        error("adx:adxCurlWrite", "Bearer token is not a valid JWT\nMessage: %s", ME.message);
    end
    if ~jwt.isTimeValid
        error("adx:adxCurlWrite", "Cached Bearer Token or bearerToken argument is either not valid yet or expired, running a trivial query e.g.:\n   mathworks.adx.run('print mycol=""Hello World""')\nwill cache a fresh token");
    end
    bearerField = ['Bearer ', char(bearerToken)];
    headersCell(end+1,:) = {'Authorization', bearerField};

    % Build up a basic query request e.g.: '{"csl":"print mycol='Hello World'","db":"unittestdb"}'
    if startsWith(options.query, "@")
        qFields = split(options.query, "@");
        dataFilename = qFields(2);
    else
        % Use a query object to get the default cluster
        if strlength(options.database) == 0
            queryObj = adx.data.api.Query();
            database = queryObj.database;
        else
            database = options.database;
        end

        % Build up a request object
        request = adx.data.models.QueryRequest();
        request.csl = options.query;
        request.db = database;
        if applyProperties
            crpo = adx.data.models.ClientRequestPropertiesOptions;
            for n = 1:numel(options.propertyNames)
                if isprop(crpo, options.propertyNames(n))
                    try
                        if options.verbose; fprintf("Setting property: %s\n", options.propertyNames(n)); end
                        crpo.(options.propertyNames(n)) = options.propertyValues{n};
                    catch exception
                        fprintf("Assignment failure for: %s, property class: %s, value class: %s",...
                            options.propertyNames(n), class(crpo.(options.propertyNames(n))), class(options.propertyValues{n}));
                        rethrow(exception);
                    end
                else
                    error("adx:adxCurlWrite", "adx.data.models.ClientRequestPropertiesOptions does not have a property named: %s", options.propertyNames(n));
                end
            end
            crp = adx.data.models.ClientRequestProperties();
            crp.Options = crpo;
            request.requestProperties = crp;
        end

        % Convert to JSON using JSONMapper
        data = request.jsonencode();

        % Not using the shell for the payload so don't escape
        % Escape " & | in the JSON, required by Windows shell
        % data = strrep(data, '"', '\"');
        % data = strrep(data, '|', '^|');
        dataFilename = tempname;
        if options.verbose
            fprintf("Writing query body data to a curl input file:\n%s\n\n", data);
        end
        fileID = fopen(dataFilename, 'w');
        fprintf(fileID,'%s', data);
        fclose(fileID);
        % Delete the temp input file on cleanup, if it exists
        cleanup = onCleanup(@() doCleanup(dataFilename));
    end

    if ~isfile(dataFilename)
        error("adx:adxCurlWrite", "Data/query file not found: %s", dataFilename);
    end

    headersCell(end+1,:) = {'Connection', 'Keep-Alive'};
    headersCell(end+1,:) = {'Expect', '100-continue'};

    webOpts = weboptions('HeaderFields', headersCell);
    webOpts.ContentType = "json";
    webOpts.MediaType = "application/json;charset=utf-8";

    [tf, result] = mathworks.internal.curl.curlWrite(matlab.net.URI(urlWithPath), dataFilename, webOpts, options.verbose, skipJSONDecode=options.skipJSONDecode);
end


function doCleanup(filename)
    % doCleanup Delete the temporary output file if it exists
    arguments
        filename string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    if isfile(filename)
        delete(filename);
    end
end