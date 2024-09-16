classdef TableKind < adx.control.JSONEnum
    % TableKind Specifies the type of a Table response
    % The value should be one of:
    %   PrimaryResult
    %   QueryCompletionInformation
    %   QueryTraceLog
    %   QueryPerfLog
    %   TableOfContents
    %   QueryProperties
    %   QueryPlan
    %   Unknown
    %
    % See: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/api/rest/response2
    
    % Copyright 2023 The MathWorks, Inc.

    enumeration
        PrimaryResult ("PrimaryResult")
        QueryCompletionInformation ("QueryCompletionInformation")
        QueryTraceLog ("QueryTraceLog")
        QueryPerfLog ("QueryPerfLog")
        TableOfContents ("TableOfContents")
        QueryProperties ("QueryProperties")
        QueryPlan ("QueryPlan")
        Unknown ("Unknown")
    end
end

