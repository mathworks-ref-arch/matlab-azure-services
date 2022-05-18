function deleteFile(obj, fileName)
    % DELETEFILE Deletes the file - this is the equivalent of the "delete"
    % method in the Azure Java API but because "delete" is a reserved
    % method name in MATLAB, the method is named deleteFile.
    %
    % Example:
    %   client.deleteFile('myfile.txt')

    % Copyright 2022 The MathWorks, Inc.

    if ~(ischar(fileName) || isStringScalar(fileName))
        logObj = Logger.getLogger();
        write(logObj,'error','Invalid fileName argument');
    else
        obj.Handle.deleteFile(fileName);
    end
    
end