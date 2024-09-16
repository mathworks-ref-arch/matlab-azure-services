function dispErrorDetails(details, options)
    % dispErrorDetails Display a adx.control.models.ErrorDetail

    % Copyright 2023 The MathWorks, Inc.

    arguments
        details (1,1) adx.control.models.ErrorDetail
        options.prefix string {mustBeTextScalar} = ""
    end

    fprintf("%sErrorDetails:\n", options.prefix);
    if isprop(details, 'code') && ~isempty(details.code)
        fprintf("%s  code: %s\n", options.prefix, details.code);
    end
    if isprop(details, 'message') && ~isempty(details.message)
        fprintf("%s  message: %s\n", options.prefix, details.message);
    end
    if isprop(details, 'target') && ~isempty(details.target)
        fprintf("%s  target: %s\n", options.prefix, details.target);
    end
    if isprop(details, 'details') && ~isempty(details.details)
        indentPrefix = options.prefix + "  ";
        for n =1:numel(details.details)
            if isa(details.details(n), 'adx.control.models.ErrorDetails')
                details.details(n).disp(prefix=indentPrefix);
            else
                disp(details.details(n));
            end
        end
    end
    if isprop(details, 'additionalInfo') && ~isempty(details.additionalInfo)
        indentPrefix = options.prefix + "  ";
        for n =1:numel(details.additionalInfo)
            if isa(details.additionalInfo(n), 'adx.control.models.ErrorAdditionalInfo')
                details.additionalInfo(n).disp(prefix=indentPrefix);
            else
                disp(details.additionalInfo(n));
            end
        end
    end
    if isprop(details, 'context') && ~isempty(details.context)
        fprintf("%s  context:\n",options.prefix)
        disp(details.context);
    end
end