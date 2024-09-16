function result = sanitizeBlobName(blobName)
    % sanitizeBlobName Checks that a name complies with Blob name limits

    % Copyright 2023 The MathWorks, Inc.
    
    arguments
        blobName string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    % TODO apply blob name restrictions
    % blobName = lower(matlab.lang.makeValidName(['adxingesttemporaryblob',char(datetime('now'))],'ReplacementStyle','delete'));
    result = blobName;
end