function [tf, cluster] = isClusterRunning(options)
    % isClusterRunning Returns a logical true if the cluster is running
    % If the cluster is not running a false is returned. The state is optionally 
    % displayed. An optional adx.control.models.Cluster object is returned with
    % full cluster metadata information.
    %
    % Example:
    %   tf = mathworks.adx.isClusterRunning();

    % Copyright 2024 The MathWorks, Inc.

    arguments
        options.cluster string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.resourceGroup string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.subscriptionId string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.apiVersion string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end

    args = mathworks.utils.addArgs(options, ["cluster", "resourceGroup", "subscriptionId", "apiVersion"]);
    clusterObj = mathworks.adx.clustersGet(args{:});

    if ~isa(clusterObj, 'adx.control.models.Cluster') || ~isscalar(clusterObj)
        error("adx:isClusterRunning", "mathworks.adx.clustersGet failed");
    end

    if isprop(clusterObj, "xproperties") && isprop(clusterObj.xproperties, "state")
        cluster = clusterObj;
        if strcmpi(clusterObj.xproperties.state, "Running")
            tf = true;
        else
            if options.verbose
                fprintf("Cluster not running, state is: %s\n", clusterObj.xproperties.state);
            end
            tf = false;
        end
    else
        error("adx:isClusterRunning", "mathworks.adx.clustersGet xproperties or xproperties.state not found");
    end
end