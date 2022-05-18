function deleteDirectory(obj)
    % DELETEDIRECTORY Deletes the directory - this is the equivalent of the "delete"
    % method in the Azure Java API but because "delete" is a reserved
    % method name in MATLAB, the method is named deleteDirectory.
    %
    % Example:
    %   client.deleteDirectory()

    % Copyright 2022 The MathWorks, Inc.

    obj.Handle.delete();
    
end