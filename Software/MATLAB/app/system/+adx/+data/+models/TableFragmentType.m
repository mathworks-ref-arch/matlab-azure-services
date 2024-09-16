classdef TableFragmentType < adx.control.JSONEnum
    % TableFragmentType Describes what the client should do with this fragment
    % The value should be one of:
    %    DataAppend
    %    DataReplace
    %
    % See: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/api/rest/response2
    
    % Copyright 2023 The MathWorks, Inc.

    enumeration
        DataAppend ("DataAppend")
        DataReplace ("DataReplace")
    end
end

