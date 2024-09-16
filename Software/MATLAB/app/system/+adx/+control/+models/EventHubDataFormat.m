classdef EventHubDataFormat < adx.control.JSONEnum
% EventHubDataFormat The data format of the message. Optionally the data format can be added to each message.

    % This file is automatically generated using OpenAPI
    % Specification version: 2023-05-02
    % MATLAB Generator for OpenAPI version: 1.0.0
    % (c) 2023 MathWorks Inc.

    enumeration 
        MULTIJSON ("MULTIJSON")
        JSON ("JSON")
        CSV ("CSV")
        TSV ("TSV")
        SCSV ("SCSV")
        SOHSV ("SOHSV")
        PSV ("PSV")
        TXT ("TXT")
        RAW ("RAW")
        SINGLEJSON ("SINGLEJSON")
        AVRO ("AVRO")
        TSVE ("TSVE")
        PARQUET ("PARQUET")
        ORC ("ORC")
        APACHEAVRO ("APACHEAVRO")
        W3CLOGFILE ("W3CLOGFILE")
    end

end %class

