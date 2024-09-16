function size = getBlobSize(obj)
    % GETBLOBSIZE Gets the size of the blob in bytes
    % An int64 is returned.

    % Copyright 2023 The MathWorks, Inc.

    size = azure.mathworks.internal.int64FnHandler(obj);
end
