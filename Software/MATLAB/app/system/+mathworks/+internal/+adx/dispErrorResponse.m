function dispErrorResponse(err, options)
    % dispErrorResponse Display a adx.control.models.ErrorResponse

    % Copyright 2023 The MathWorks, Inc.

    arguments
        err (1,1) adx.control.models.ErrorResponse
        options.prefix string {mustBeTextScalar} = ""
    end

    fprintf("%sErrorResponse:\n", options.prefix);
    if isprop(err, 'error')
        if isa(err.error, 'adx.control.models.ErrorDetail')
            err.error.disp(prefix=options.prefix);
        end
    end
end