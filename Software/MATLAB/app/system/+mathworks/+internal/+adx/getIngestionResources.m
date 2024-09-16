function irs = getIngestionResources(options)
    % getIngestionResources Get queues and other values to do ingestion
    % Returns a adx.data.models.IngestionResourcesSnapshot
    
    % Copyright 2023-2024 The MathWorks, Inc.
    
    arguments
        options.cluster string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.bearerToken string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    % If cluster is set as an argument use it otherwise
    % Management cluster will get a default
    args = mathworks.utils.addArgs(options, ["cluster", "bearerToken"]);
    managementClient = adx.data.api.Management(args{:});

    % Error if the cluster is not set
    if strlength(managementClient.cluster) > 0
        % Prepend the ingest- for this call if not present
        if startsWith(managementClient.cluster, 'https://ingest-')
            ingestCluster = managementClient.cluster;
        else
            ingestCluster = strrep(managementClient.cluster, 'https://', 'https://ingest-');
        end
    else
        error("adx:getIngestionResources", "Management Client cluster not set")
    end

    [code, result, response] = managementClient.managementRun(adx.data.models.ManagementRequest('csl', '.get ingestion resources'), 'cluster', ingestCluster); %#ok<ASGLU>
    if code == matlab.net.http.StatusCode.OK
        irs = adx.data.models.IngestionResourcesSnapshot(result);
    else
        error("adx:getIngestionResources", "Error getting Ingestion Resources")
    end
end
