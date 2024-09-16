function result = timespanValue2duration(t)
    % timespanValue2duration Converts a timespan value to a MATALB duration
    %
    % See: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/scalar-data-types/timespan

    % Copyright 2024 The MathWorks, Inc.

    tin = t; % keep original for error messages
    t = strip(t); % Remove stray spaces

    decP = digitsPattern + optionalPattern("." + digitsPattern);
    % Match 2.00:00:00
    colonValP = digitsPattern + "." + digitsPattern + ":" + digitsPattern + ":" + decP;
    % Match hh:mm:ss.SSSSSSS
    hhmmssSSSSSSP = digitsPattern + ":" + digitsPattern + ":" + digitsPattern + "." + digitsPattern;
    hhmmssP = digitsPattern + ":" + digitsPattern + ":" + digitsPattern;

    if matches(t, colonValP)
        str = extract(t, colonValP);
        strFields = split(str, ":");
        if numel(strFields) ~= 3
            error("adx:timespanValue2duration", "Expected time value to have 3 colon separated fields, e.g.: 0.12:34:56.7 : %s", str);
        end
        dhFields = split(strFields(1), ".");
        if numel(dhFields) ~= 2
            error("adx:timespanValue2duration", "Expected time day.hour value to have 2 dot separated fields, e.g. 0.12:34:56.7 : %s", str);
        end
        secondFields = split(strFields(3), ".");
        infmt = "dd:hh:mm:ss";
        if numel(secondFields) > 1
            if strlength(secondFields(2)) > 0
                infmt = infmt + ".";
            end
            for n = 1:strlength(secondFields(2))
                infmt = infmt + "S";
            end
        end
        timeString = dhFields(1) + ":" + dhFields(2) + ":" + strFields(2) + ":" + strFields(3);
        result = duration(timeString, 'InputFormat', infmt, 'Format', infmt);
    elseif matches(t, hhmmssSSSSSSP)
        result = duration(t, 'InputFormat','hh:mm:ss.SSSSSSS', 'Format', 'hh:mm:ss.SSSSSSS');
    elseif matches(t, hhmmssP)
        result = duration(t, 'InputFormat','hh:mm:ss', 'Format', 'hh:mm:ss');
    else
        error("adx:timespanValue2duration:convertDuration", "Unexpected timespan value: %s", tin);
    end
end
