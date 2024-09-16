function result = clustersGet(options)
    % clustersGet Returns a Cluster object for a given or default Cluster URL
    % In the case of error a adx.control.models.ErrorResponse is returned
    % or an error is thrown.
    %
    % Example:
    %   % Get a cluster Object for the current default cluster
    %   result = mathworks.adx.clustersGet();

    % Copyright 2023-2024 The MathWorks, Inc.

    arguments
        options.cluster string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.resourceGroup string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.subscriptionId string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.apiVersion string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    
    % Create a Clusters object and get default values from it
    c = adx.control.api.Clusters;

    if isfield(options, 'resourceGroup')
        resourceGroup = options.resourceGroup;
    else
        resourceGroup = c.resourceGroup;
    end

    if isfield(options, 'subscriptionId')
        subscriptionId = options.subscriptionId;
    else
        subscriptionId = c.subscriptionId;
    end

    if isfield(options, 'apiVersion')
        apiVersion = options.apiVersion;
    else
        apiVersion = c.apiVersion;
    end

    if isfield(options, 'cluster')
        clusterName = options.cluster;
    else
        clusterName = mathworks.internal.adx.getDefaultConfigValue('cluster');
    end

    if startsWith(clusterName, "https://")
        clusterUri = matlab.net.URI(clusterName);
        clusterName = clusterUri.Host;
    end
    fields = split(clusterName, '.');
    clusterName = fields(1);

    [code, result, response] = c.clustersGet(resourceGroup, clusterName, subscriptionId, apiVersion);  

    if code == matlab.net.http.StatusCode.OK
        if ~isa(result, 'adx.control.models.Cluster')
            warning("adx:clustersGet", "Expected cluster to be of type adx.control.models.Cluster, not: %s", class(result));
        end
    else
        if isa(result, 'adx.control.models.ErrorResponse')
            mathworks.internal.adx.dispErrorResponse(result);
        else
            error("adx:clustersGet", "Error getting cluster: %s, %s", clusterName, response.StatusCode);
        end
    end
end