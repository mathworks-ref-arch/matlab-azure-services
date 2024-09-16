function dispErrorAdditionalInfo(addInfo, options)
    % Displays a adx.control.models.ErrorAdditionalInfo

    % Copyright 2023 The MathWorks, Inc.

    arguments
        addInfo (1,1) adx.control.models.ErrorAdditionalInfo
        options.prefix string {mustBeTextScalar} = ""
    end

    fprintf("%sErrorAdditionalInfo:\n", options.prefix);
    if isprop(addInfo, 'type') && ~isempty(addInfo.type)
        fprintf("%s  type: %s\n", options.prefix, addInfo.type);
    end
    if isprop(addInfo, 'info') && ~isempty(addInfo.info)
        fprintf("%s  info:\n", options.prefix);
        disp(addInfo.info)
    end
end