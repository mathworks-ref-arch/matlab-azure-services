classdef StreamFormat
    % STREAMFORMAT Specifies the format of the data in the request body
    % The value should be one of: CSV, TSV, SCsv, SOHsv, PSV, JSON, MultiJSON, Avro
    % See: https://learn.microsoft.com/en-us/azure/data-explorer/ingestion-supported-formats
    
    % Copyright 2023 The MathWorks, Inc.

    enumeration
        CSV
        TSV
        SCsv
        SOHsv
        PSV
        JSON
        MultiJSON
        Avro
    end
end

