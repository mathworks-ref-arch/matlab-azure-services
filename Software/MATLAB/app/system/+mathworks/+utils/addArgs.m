function args = addArgs(options, argNames, initialArgs)
    % addArg Builds and named argument cell array
    %
    % Example:
    %   args = mathworks.utils.addArgs(options, ["authMethod", "profileName"]);
    %   x = myFunc(args{:});


    %   (c) 2024 MathWorks, Inc.

    arguments
        options (1,1) struct
        argNames string
        initialArgs cell = {}
    end

    args = initialArgs;
    for n = 1:numel(argNames)
        currArg = argNames(n);
        if isfield(options, currArg)
            args{end+1} = currArg; %#ok<AGROW>
            args{end+1} = options.(currArg); %#ok<AGROW>
        end
    end
end