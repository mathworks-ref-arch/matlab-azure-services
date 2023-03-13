classdef BlobListDetails < azure.object
    % BLOBLISTDETAILS Allows users to specify additional information the service should return with each blob when listing blobs

    % Copyright 2023 The MathWorks, Inc.

    properties
    end
    
    methods
        function obj = BlobListDetails(varargin)
            initialize('loggerPrefix', 'Azure:ADLSG2');
            
            if nargin == 0
                obj.Handle = com.azure.storage.blob.models.BlobListDetails();
            elseif nargin == 1 && isa(varargin{1}, 'com.azure.storage.blob.models.BlobListDetails')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid argument(s), expected no argument or a com.azure.storage.blob.models.BlobListDetails');
            end
        end
    
        function blobListDetails = setRetrieveCopy(obj, tf)
            % SETRETRIEVECOPY Whether blob metadata related to any current or previous Copy Blob operation should be included in the response
            blobListDetails = azure.storage.blob.models.BlobListDetails(obj.Handle.setRetrieveCopy(tf));
        end

        function blobListDetails = setRetrieveDeletedBlobs(obj, tf)
            % SETRETRIEVEDELETEDBLOBS Whether blobs which have been soft deleted should be returned
            blobListDetails = azure.storage.blob.models.BlobListDetails(obj.Handle.setRetrieveDeletedBlobs(tf));
        end

        function blobListDetails = setRetrieveDeletedBlobsWithVersions(obj, tf)
            % SETRETRIEVEDELETEDBLOBSWITHVERSIONS Whether blobs which have been deleted with versioning should be returned
            blobListDetails = azure.storage.blob.models.BlobListDetails(obj.Handle.setRetrieveDeletedBlobsWithVersions(tf));
        end

        function blobListDetails = setRetrieveImmutabilityPolicy(obj, tf)
            % SETRETRIEVEIMMUTABILITYPOLICY Whether blobs which have been deleted with versioning should be returned
            blobListDetails = azure.storage.blob.models.BlobListDetails(obj.Handle.setRetrieveImmutabilityPolicy(tf));
        end

        function blobListDetails = setRetrieveLegalHold(obj, tf)
            % SETRETRIEVELEGALHOLD Whether legal hold for the blob should be returned
            blobListDetails = azure.storage.blob.models.BlobListDetails(obj.Handle.setRetrieveLegalHold(tf));
        end

        function blobListDetails = setRetrieveMetadata(obj, tf)
            % SETRETRIEVEMETADATA Whether blob metadata should be returned
            blobListDetails = azure.storage.blob.models.BlobListDetails(obj.Handle.setRetrieveMetadata(tf));
        end

        function blobListDetails = setRetrieveSnapshots(obj, tf)
            % setRetrieveSnapshots Whether snapshots should be returned
            blobListDetails = azure.storage.blob.models.BlobListDetails(obj.Handle.setRetrieveSnapshots(tf));
        end

        function blobListDetails = setRetrieveTags(obj, tf)
            % setRetrieveTags Whether blob tags should be returned
            blobListDetails = azure.storage.blob.models.BlobListDetails(obj.Handle.setRetrieveTags(tf));
        end

        function blobListDetails = setRetrieveUncommittedBlobs(obj, tf)
            % SETRETRIEVEUNCOMMITTEDBLOBS Whether blob metadata should be returned
            blobListDetails = azure.storage.blob.models.BlobListDetails(obj.Handle.setRetrieveUncommittedBlobs(tf));
        end

        function blobListDetails = setRetrieveVersions(obj, tf)
            % SETRETRIEVEUNCOMMITTEDBLOBS Whether versions should be returned
            blobListDetails = azure.storage.blob.models.BlobListDetails(obj.Handle.setRetrieveVersions(tf));
        end

        function tf = getRetrieveCopy(obj)
            % GETRETRIEVECOPY Whether blob metadata related to any current or previous Copy Blob operation should be included in the response
            tf = obj.Handle.getRetrieveCopy();
        end
        
        function tf = getRetrieveDeletedBlobs(obj)
            % GETRETRIEVEDELETEDBLOBS Whether blobs which have been soft deleted should be returned
            tf = obj.Handle.getRetrieveDeletedBlobs();
        end
    
        function tf = getRetrieveDeletedBlobsWithVersions(obj)
            % GETRETRIEVEDELETEDBLOBSWITHVERSIONS Whether blobs which have been deleted with versioning
            tf = obj.Handle.getRetrieveDeletedBlobsWithVersions();
        end

        function tf = getRetrieveImmutabilityPolicy(obj)
            % GETRETRIEVEIMMUTABILITYPOLICY Whether immutability policy for the blob should be returned
            tf = obj.Handle.getRetrieveImmutabilityPolicy();
        end

        function tf = getRetrieveLegalHold(obj)
            % GETRETRIEVELEGALHOLD Whether legal hold for the blob should be returned
            tf = obj.Handle.getRetrieveLegalHold();
        end

        function tf = getRetrieveMetadata(obj)
            % GETRETRIEVEMETADATA Whether blob metadata should be returned
            tf = obj.Handle.getRetrieveMetadata();
        end

        function tf = getRetrieveSnapshots(obj)
            % GETRETRIEVESNAPSHOTS Whether snapshots should be returned
            tf = obj.Handle.getRetrieveSnapshots();
        end

        function tf = getRetrieveTags(obj)
            % GETRETRIEVETAGS Whether blob tags should be returned
            tf = obj.Handle.getRetrieveTags();
        end

        function tf = getRetrieveUncommittedBlobs(obj)
            % GETRETRIEVEUNCOMMITTEDBLOBS Whether blob tags should be returned
            tf = obj.Handle.getRetrieveUncommittedBlobs();
        end

        function tf = getRetrieveVersions(obj)
            % GETRETRIEVEVERSIONS Whether versions should be returned
            tf = obj.Handle.getRetrieveVersions();
        end
    end
end