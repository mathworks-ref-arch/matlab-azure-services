classdef IngestionResourcesSnapshot
    % INGESTIONRESOURCESSNAPSHOT Contains result of .get ingestion resources request
    %
    % Example:
    %
    %   managementClient = adx.data.api.Management();
    %   [code, result, response] = managementClient.managementRun(adx.data.models.ManagementRequest('csl', '.get ingestion resources'));
    %   if code == matlab.net.http.StatusCode.OK
    %       irs = adx.data.models.IngestionResourcesSnapshot(result);
    %   end
    %
    % See: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/api/netfx/kusto-ingest-client-rest#retrieve-ingestion-resources

    % Copyright 2023 The MathWorks, Inc.

    properties
        SecuredReadyForAggregationQueue string
        TempStorage string
        FailedIngestionsQueue string
        SuccessfulIngestionsQueue string
        IngestionsStatusTable string
        Data adx.data.models.DataTableV1
    end

    methods
        function obj = IngestionResourcesSnapshot(dt)
            % INGESTIONRESOURCESSNAPSHOT Constructor for IngestionResourcesSnapshot object
            arguments
                dt adx.data.models.QueryV1ResponseRaw
            end

            if ~isprop(dt, 'Tables')
                error("adx:IngestionResourcesSnapshot", "Tables property not found");
            end

            if ~isprop(dt.Tables, 'TableName')
                error("adx:IngestionResourcesSnapshot", "Tables.TableName property not found");
            end

            if ~isprop(dt.Tables, 'Columns')
                error("adx:IngestionResourcesSnapshot", "Tables.Columns property not found");
            end

            if ~isprop(dt.Tables, 'Rows')
                error("adx:IngestionResourcesSnapshot", "Tables.Rows property not found");
            end

            if ~strcmp(dt.Tables.TableName, 'Table_0')
                error("adx:IngestionResourcesSnapshot", "Unexpected TableName: %s", dt.Tables.TableName);
            end

            if numel(dt.Tables.Columns) ~= 2
                error("adx:IngestionResourcesSnapshot", "Expected 2 columns");
            end

            obj.Data = dt.Tables;

            for n = 1:numel(dt.Tables.Rows)
                decodedRow = jsondecode(dt.Tables.Rows(n));
                if iscell(decodedRow)
                    if strcmp(decodedRow{1}, 'SecuredReadyForAggregationQueue')
                        obj.SecuredReadyForAggregationQueue(end+1) = decodedRow{2};
                    elseif strcmp(decodedRow{1}, 'TempStorage')
                        obj.TempStorage(end+1) = decodedRow{2};
                    elseif strcmp(decodedRow{1}, 'FailedIngestionsQueue')
                        obj.FailedIngestionsQueue(end+1) = decodedRow{2};
                    elseif strcmp(decodedRow{1}, 'SuccessfulIngestionsQueue')
                        obj.SuccessfulIngestionsQueue(end+1) = decodedRow{2};
                    elseif strcmp(decodedRow{1}, 'IngestionsStatusTable')
                        obj.IngestionsStatusTable(end+1) = decodedRow{2};
                    end
                else
                    % Unexpected fields for IRS
                end
            end
        end


        function T = table(obj)
            % TABLE Convert a IngestionResourcesSnapshot Data property to a MATLAB table
            nrows = numel(obj.Data.Rows);
            
            sz = [nrows, 2];
            varNames = [obj.Data.Columns(1).ColumnName, obj.Data.Columns(2).ColumnName];
            varTypes = [obj.Data.Columns(1).ColumnType, obj.Data.Columns(2).ColumnType];
            T = table('Size',sz,'VariableTypes',varTypes, 'VariableNames', varNames);

            for n = 1:nrows
                decodedRow = jsondecode(obj.Data.Rows(n));
                if iscell(decodedRow)
                    if numel(decodedRow) ~= 2
                        error("adx:IngestionResourcesSnapshot:table", "Expected a cell array with 2 entries found: %d", numel(decodedRow));
                    else
                        T(n,:) = decodedRow';
                    end
                else
                    error("adx:IngestionResourcesSnapshot:table", "Expected cell array output");
                end
            end
        end
    end
end
