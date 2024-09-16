function result = timespanLiteral2duration(t)
    % timespanLiteral2duration Converts a Kusto timespan value to a MATLAB duration
    %
    % See: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/scalar-data-types/timespan

    % Copyright 2024 The MathWorks, Inc.

    arguments
        t string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    tin = t; % keep original for error messages
    t = strip(t); % Remove stray spaces

    % TODO check if there is a single common format to allow an optimized
    % short circuit path

    decP = digitsPattern + optionalPattern("." + digitsPattern);
    daysP = decP + "d";
    hoursP = decP + "h";
    minutesP = decP + "m";
    secondsP = decP + "s";
    msP = decP + "ms";
    usP = decP + "microsecond";
    tickP = decP + "tick";
    timeP = "time(" + wildcardPattern(1, 100) + ")";

    if matches(t, daysP)
        t = strip(t, "right", "d");
        result = days(str2double(t));
    elseif matches(t, hoursP)
        t = strip(t, "right", "h");
        result = hours(str2double(t));
    elseif matches(t, minutesP)
        t = strip(t, "right", "m");
        result = minutes(str2double(t));
    elseif matches(t, secondsP)
        t = strip(t, "right", "s");
        result = seconds(str2double(t));
    elseif matches(t, msP)
        t = strip(t, "right", "s");
        t = strip(t, "right", "m");
        result = milliseconds(str2double(t));
    elseif matches(t, usP)
        str = split(t, "microsecond");
        result = milliseconds(str2double(str(1))/1000);
    elseif matches(t, tickP)
        str = split(t, "tick");
        result = milliseconds(str2double(str(1))/10000);
    elseif matches(t, timeP)
        % Not clear is the dd hh mm fields should support decimal values as
        % seconds does?

        % assume <= 100 white spaces otherwise something is probably broken
        secondsP = "time(" + whitespacePattern(0,100) + decP + whitespacePattern(0,100) + "seconds" + whitespacePattern(0,100) + ")";
        daysP = "time(" + whitespacePattern(0,100) + decP + whitespacePattern(0,100) + ")";
        colonValP = digitsPattern + "." + digitsPattern + ":" + digitsPattern + ":" + decP;
        colonP = "time(" + whitespacePattern(0,100) + colonValP + whitespacePattern(0,100) + ")";

        if matches(t, secondsP)
            str = extract(t, decP);
            result = seconds(str2double(str));
        elseif matches(t, daysP)
            str = extract(t, decP);
            result = days(str2double(str));
        elseif matches(t, colonP)
            str = extract(t, colonValP);
            strFields = split(str, ":");
            if numel(strFields) ~= 3
                error("adx:timespanLiteral2duration", "Expected time value to have 3 colon separated fields, e.g.: time(0.12:34:56.7) : %s", str);
            end
            dhFields = split(strFields(1), ".");
            if numel(dhFields) ~= 2
                error("adx:timespanLiteral2duration", "Expected time day.hour value to have 2 dot separated fields, e.g. time(0.12:34:56.7) : %s", str);
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
        else
            error("adx:timespanLiteral2duration", "Could not convert timespan value to a duration: %s", tin);
        end
    else
        error("adx:timespanLiteral2duration", "Could not convert timespan value to a duration: %s", tin);
    end
end