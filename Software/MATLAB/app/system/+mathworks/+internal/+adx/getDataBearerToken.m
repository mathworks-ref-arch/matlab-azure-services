function bearerToken = getDataBearerToken(database, cluster)
    % getDataBearerToken Gets a bearer token by forcing a query
    
    % Copyright 2023 The MathWorks, Inc.
    
    arguments
        database string {mustBeTextScalar, mustBeNonzeroLengthText}
        cluster string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    req = adx.data.models.QueryRequest('db', database, 'csl', 'print Test="Query to force the return of a bearer token"');
    q = adx.data.api.Query('cluster', cluster);
    [code, result, response] = q.queryRun(req); %#ok<*ASGLU>

    if code ~= matlab.net.http.StatusCode.OK
        if isa(result, 'adx.control.models.ErrorResponse')
            if isprop(result, 'error')
                if isa(result.error, 'adx.control.models.ErrorDetail')
                    if isprop(result.error, 'code')
                        fprintf("Error code: %s\n", result.error.code);
                    end
                    if isprop(result.error, 'message')
                        fprintf("Error message: %s\n", result.error.message);
                    end
                end
            end
        end
        error("adx:getDataBearerToken", "Error getting bearer token");
    else
        bearerToken = q.bearerToken;
    end
end