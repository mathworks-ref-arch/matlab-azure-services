function timespan = duration2Timespan(d)
    % duration2Timespan Converts a MATLAB duration to a Kusto timespan
    % Input must be a scalar duration, duration.empty or duration NaN.
    % A timespan literal is returned as a scalar string.
    % At most millisecond precision is supported.
    % A duration.empty or duration NaN are returned as "timespan(null)"
    % Other values are returned in the format: "timespan(days.hours:minutes:seconds.milliseconds)"
    %
    % See: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/scalar-data-types/timespan

    % Copyright 2024 The MathWorks, Inc.

    arguments
        d duration
    end

    if isempty(d)
        timespan = "timespan(null)";
    else
        if ~isscalar(d)
            error("adx:duration2Timespan", "Expected a scalar or empty value");
        end
        if isnan(d)
            timespan = "timespan(null)";
        else
            d.Format = 'dd:hh:mm:ss.SSS';
            dStr = char(d);
            dotSplit = split(dStr, '.');
            ms = dotSplit{end};
            colonSplit = split(dotSplit{1}, ':');
            if numel(colonSplit) == 4
                dd = colonSplit{1};
                hh = colonSplit{2};
                mm = colonSplit{3};
                ss = colonSplit{4};
            elseif numel(colonSplit) == 3
                dd = '00';
                hh = colonSplit{1};
                mm = colonSplit{2};
                ss = colonSplit{3};
            else
                error("adx:duration2Timespan", "Expected duration string value to have 3 or 4 fields");
            end
            % Uses format for literal like: timespan(days.hours:minutes:seconds.milliseconds)
            timespan = sprintf("timespan(%s.%s:%s:%s.%s)",dd,hh,mm,ss,ms);
        end
    end
end