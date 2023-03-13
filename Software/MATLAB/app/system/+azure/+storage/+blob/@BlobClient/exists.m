function result = exists(obj)
    % EXISTS Gets if the blob this client represents exists in Azure
    % A logical is returned if the Container exists indicating if the blob
    % exists or not. Otherwise an exception is thrown, for example if the
    % container does not exist. Consider using a container client to check for
    % the existance of the container first.

    % Copyright 2020-2022 The MathWorks, Inc.

    % Returns a Boolean convert to boolean and then logical
    resultj = obj.Handle.exists();
    result = resultj.booleanValue;

end