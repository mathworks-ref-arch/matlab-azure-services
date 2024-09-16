function literal = charOrString2String(value, options)
    % charOrString2String Converts a MATLAB char or string to a Kusto string
    % A string is returned.
    % Input must be a empty, missing, scalar string or character vector.
    %
    % If the optional logical named argument verbatim (default: false) a @ sign is
    % prepended to the string. The backslash character (\) stands for itself and
    % isn't an escape character. Prepending the @ character to string literals
    % serves as a verbatim identifier. In verbatim string literals, double quotes
    % are escaped with double quotes and single quotes are escaped with single quotes.
    %
    % An obfuscated string is created by setting the optional named argument
    % obfuscated (default: false). It prepends a H character to a verbatim
    % or string literal. The obfuscated argument is not applied to multi-lines.
    %
    % Multi-line string literals support newline (\n) and return (\r) characters.
    % Multi-line string literals do not support escaped characters, similar to verbatim
    % string literals. Multi-line string literals don't support obfuscation.
    %
    % Kusto does not support null strings hence empty or missing MATLAB string
    % values are treated as follows:
    %
    %           |  Literal     Verbatim    Multi-line
    %  -----------------------------------------------
    %  missing  |    ""           @""        ``````
    %    empty  |    ""           @""        ``````
    %
    % If an empty string is provided "", `````` or @"" is returned.
    %
    % Optional named arguments
    %   verbatim    Logical, default: false
    %   multiline    Logical, default: false
    %
    % Verbatim and multiline cannot be enabled at the same time.
    %
    % See also: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/scalar-data-types/string

    % Copyright 2024 The MathWorks, Inc.

    arguments
        value string
        options.verbatim (1,1) logical = false
        options.multiline (1,1) logical = false
        options.obfuscated (1,1) logical = false
    end

    if options.verbatim && options.multiline
        error("adx:charOrString2String", "Verbatim and multiline cannot be enabled at the same time");
    end

    if options.verbatim
        if isempty(value) || ismissing(value)
            literal = "@""""";
        else
            if ~isStringScalar(value)
                error("adx:charOrString2String", "Expected a scalar or empty value");
            end
            value = replace(value, '"', '""');
            value = replace(value, "'", "''");
            literal = "@" + value;
        end
        if options.obfuscated
            literal = "H" + literal;
        end
    elseif options.multiline
        if isempty(value) || ismissing(value)
            literal = "``````";
        else
            if ~isStringScalar(value)
                error("adx:charOrString2String", "Expected a scalar or empty value");
            end
            literal = "```" + value + "```";
        end
    else
        % If not a multiline or verbatim
        if isempty(value) || ismissing(value)
            literal = "";
        else
            if ~isStringScalar(value)
                error("adx:charOrString2String", "Expected a scalar or empty value");
            end
            value = replace(value, '\', '\\');
            %value = replace(value, '\t', '\\t');
            %value = replace(value, '\n', '\\n');
            %value = replace(value, '\r', '\\r');
            value = replace(value, '"', '\"');
            value = replace(value, "'", "\'");
            literal = """" + value + """";
        end
        if options.obfuscated
            literal = "H" + literal;
        end
    end
end