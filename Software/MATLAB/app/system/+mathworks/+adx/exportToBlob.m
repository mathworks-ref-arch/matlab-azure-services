function [tf, result] = exportToBlob(storageConnectionString, query, options)
    % exportToBlob Exports data to an Azure blob
    %
    % Required arguments
    %  storageConnectionString: SAS URL for the destination blob
    %
    %  query: The result of the query is written to a blob.
    %
    % Optional arguments
    %  compressed: Logical to indicate if the results should be compressed, default is true
    %
    %  outputDataFormat: String to indicate the output file format the default is parquet
    %                    Supported values are: csv, tsv, json, and parquet.
    %
    %  database: Database name string, the default is taken from the JSON settings file.
    %
    %  cluster: Cluster name string, the default is taken from the JSON settings file.
    %
    %  bearerToken: String containing a specific bearerToken
    %
    % Return values
    %  tf: Logical to indicate if the command succeeded.
    %
    %  Result: On success contains the result of the query on failure contains a
    %          adx.control.models.ErrorResponse
    %
    % Example:
    %  exportURL = "https://<mystorageaccount>.blob.core.windows.net/<REDACTED>";
    %  exportURI = matlab.net.URI(exportURL);
    %  SAS = exportURI.EncodedQuery;
    %  query = "table('" + "mytablename" + "', 'all')";
    %  [tf, result] = mathworks.adx.exportToBlob(exportURI.EncodedURI, query);
    %  % Assuming tf == true
    %  downloadURL = result.Path(1) + "?" + SAS;
    %  downloadURI = matlab.net.URI(downloadURL);
    %  % The default export format is parquet
    %  localFile = websave("exportedTable.gz.parquet", downloadURI);
    %  T = parquetread(localFile);
    % 
    % See also: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/management/data-export/export-data-to-storage

    % Copyright 2023 The MathWorks, Inc.

    arguments
        storageConnectionString string {mustBeNonzeroLengthText}
        query string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.compressed logical = true
        options.async logical = false
        options.outputDataFormat string {mustBeTextScalar, mustBeNonzeroLengthText} = "parquet"
        options.database string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.cluster string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.bearerToken string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.exportProperties containers.Map
    end

    args = mathworks.utils.addArgs(options, ["bearerToken", "cluster"]);
    managementClient = adx.data.api.Management(args{:});

    if isfield(options, 'database')
        database = options.database;
    else
        database = managementClient.database;
    end

    cmdString = ".export";

    if options.async
        cmdString = cmdString + " async";
    end

    if options.compressed 
        cmdString = cmdString + " compressed";
    end

    cmdString = cmdString + " to " + options.outputDataFormat;

    cmdString = cmdString + "(" + """" + storageConnectionString + """" + ")";
    
    if isfield(options, 'exportProperties')
        if length(options.exportProperties) > 0 %#ok<ISMT>
            cmKeys = keys(options.exportProperties);
            cmValues = values(options.exportProperties);
            cmdString = cmdString + " with(";
            for n = 1:length(options.exportProperties)
                cmdString = cmdString + cmKeys{n} + "=" + cmValues{n};
                if n < length(options.exportProperties)
                    cmdString = cmdString + ", ";
                end
            end
            cmdString = cmdString + ")";
        end
    end

    cmdString = cmdString + " <| " + query;

    req = adx.data.models.ManagementRequest('db', database, 'csl', cmdString);

    [code, result, response] = managementClient.managementRun(req); %#ok<*ASGLU>

    if code == matlab.net.http.StatusCode.OK
        cellTabularResult = mathworks.internal.adx.queryV1Response2Tables(result, allowNullStrings=true);
        if numel(cellTabularResult) == 1
            result = cellTabularResult{1};
        else
            warning("adx:exportToBlob", "More than one result table returned");
            result = cellTabularResult;
        end
        tf = true;
    else
        result.disp();
        tf = false;
    end
end