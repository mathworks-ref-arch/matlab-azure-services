function max = getMaxResultsPerPage(obj)
    % GETDETAILS Returns the maximum number of blobs to return, including all BlobPrefix elements
    % A double is returned.
    % An empty [] is returned if not set.

    % Copyright 2023 The MathWorks, Inc.

    maxj = obj.Handle.getMaxResultsPerPage();
    if ~isempty(maxj)
        max = maxj.intValue;
    else
        max = maxj; % [] case
    end
end