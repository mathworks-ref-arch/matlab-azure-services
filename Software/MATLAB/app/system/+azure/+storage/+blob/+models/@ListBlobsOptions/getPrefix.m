function prefix = getPrefix(obj)
    % GETPREFIX Filters the results to return only blobs whose names begin with the specified prefix

    % Copyright 2023 The MathWorks, Inc.

    prefix = char(obj.Handle.getPrefix());
end