function identityToken = getKustoIdentityToken(options)
    % getKustoIdentityToken Management query to request a Kusto Identity Token
    % Query used is: .get kusto identity token

    % Copyright 2023-2024 The MathWorks, Inc.
    
    arguments
        options.cluster string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.bearerToken string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    args = {};
    if isfield(options, 'cluster')
        args{end+1} = "cluster";
        args{end+1} = options.cluster;
    end
    if isfield(options, 'bearerToken')
        args{end+1} = "bearerToken";
        args{end+1} = options.bearerToken;
    end
    managementClient = adx.data.api.Management(args{:});

    [code, result, ~] = managementClient.managementRun(adx.data.models.ManagementRequest('csl', '.get kusto identity token'));
    if code == matlab.net.http.StatusCode.OK
        identityToken = mathworks.utils.jwt.JWT(result.Tables.Rows{1});
    else
        error("adx:getKustoIdentityToken", "Error getting Identity token")
    end
end