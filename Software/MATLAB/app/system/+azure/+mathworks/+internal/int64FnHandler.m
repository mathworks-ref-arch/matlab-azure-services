function result = int64FnHandler(obj, varargin)
    % int64FnHandler Invokes Java method to convert a Java long to a string and then an int64
    % An int64 is returned.
    
    % Copyright 2023 The MathWorks, Inc.

    if nargin == 1
        % Use the stack to figure out the calling function
        stack = dbstack;
        fnName = (split(stack(2).name, '.'));
        result = sscanf(char(com.mathworks.azure.sdk.Version.invokeNamedMethodToString(obj.Handle, fnName{end})), '%ld');
    elseif nargin == 2
        % Use a named function
        result = sscanf(char(com.mathworks.azure.sdk.Version.invokeNamedMethodToString(obj.Handle, varargin{1})), '%ld');
    else
        logObj = Logger.getLogger();
        write(logObj,'error','Unexpected number of arguments');
    end
end