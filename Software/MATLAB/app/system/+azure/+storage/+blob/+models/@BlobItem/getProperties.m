function props = getProperties(obj)
    % GETPROPERTIES Get the properties property

    % Copyright 2023 The MathWorks, Inc.

    props = azure.storage.blob.models.BlobItemProperties(obj.Handle.getProperties);

end
