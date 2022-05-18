function uploadFromFile(obj, filePath, varargin)
    % UPLOADFROMFILE Creates a or updates a block blob To overwrite an
    % existing blob use a parameter 'overwrite' and a logical true. By
    % default a blob is not overwritten.
    %
    % If a lease is active on the blob, parameter 'leaseId' and the
    % actual lease id as value can be provided.
    %
    % Example:
    %   blobClient.uploadFromFile('/mydir/myfile.txt',...
    %       'overwrite', true,...
    %       'leaseId','f6eb8bda-cf33-4da1-8e50-11d1a6dd8797');
    
    % Copyright 2020-2022 The MathWorks, Inc.
    
    if ~(ischar(filePath) || isStringScalar(filePath))
        logObj = Logger.getLogger();
        write(logObj,'error','Invalid filePath type');
    else
        if ~isfile(filePath)
            logObj = Logger.getLogger();
            write(logObj,'error',['File not found: ', strrep(char(filePath),'\','\\')]);
        end
    end
    
    % validString = @(x) ischar(x) || isStringScalar(x);
    p = inputParser;
    p.CaseSensitive = false;
    p.FunctionName = 'uploadFromFile';
    addParameter(p,'overwrite', false, @islogical);
    addParameter(p,'leaseid', [], @(x)ischar(x)||isStringScalar(x));
    % To be extended
    parse(p,varargin{:});

    if ~(p.Results.overwrite)
        if(obj.exists)
            logObj = Logger.getLogger();
            write(logObj,'error','Blob already exists.');
        end
    end

    if ~isempty(p.Results.leaseid)
        requestConditions = com.azure.storage.blob.models.BlobRequestConditions;
        requestConditions = requestConditions.setLeaseId(p.Results.leaseid);

        obj.Handle.uploadFromFile(filePath, [], [], [], [], requestConditions, []);
    else
        obj.Handle.uploadFromFile(filePath,p.Results.overwrite);
    end

end