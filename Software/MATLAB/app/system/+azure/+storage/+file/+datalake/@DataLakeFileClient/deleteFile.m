function deleteFile(obj)
    % DELETEFILE Deletes the file - this is the equivalent of the "delete"
    % method in the Azure Java API but because "delete" is a reserved
    % method name in MATLAB, the method is named deleteFile.
    %
    % Example:
    %   client.deleteFile()

    % Copyright 2022 The MathWorks, Inc.

    obj.Handle.delete();
    
end