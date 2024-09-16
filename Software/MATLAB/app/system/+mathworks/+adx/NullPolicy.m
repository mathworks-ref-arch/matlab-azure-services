classdef NullPolicy
    % NullPolicy Enumeration used to determine how null values ard handled in MATLAB
    %
    % Values:
    %                ErrorAny: Error if any null values are detected
    %  ErrorLogicalInt32Int64: Error if null values are detected for logicals,
    %                          int32s or int64s that do not support missing or NaN
    %                AllowAll: All null types to map to missing, NaN or NaT for
    %                          all data types
    %          Convert2Double: Convert logicals, int32s, & int64s  to doubles

    % (c) 2024 MathWorks Inc.
    
    enumeration
        % Error if any null values are detected
        ErrorAny
        % Error if null values are detected for logicals, int32s or int64s that do not support missing or NaN
        ErrorLogicalInt32Int64
        % All null types to map to missing, NaN or NaT for all data types
        AllowAll
        % Convert logicals, int32s, & int64s  to doubles
        Convert2Double
    end
end %class