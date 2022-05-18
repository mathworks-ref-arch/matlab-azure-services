function deleteDirectory(obj, directoryName)
    % DELETEDIRECTORY Deletes the specified directory
    %
    % Example:
    %   client.deleteDirectory('myDirectory')

    % Copyright 2022 The MathWorks, Inc.

    if ~(ischar(directoryName) || isStringScalar(directoryName))
        logObj = Logger.getLogger();
        write(logObj,'error','Invalid directoryName argument');
    else
        obj.Handle.deleteDirectory(directoryName);
    end

end