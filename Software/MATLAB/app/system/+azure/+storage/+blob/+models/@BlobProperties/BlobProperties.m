classdef BlobProperties < azure.object
    % BlobProperties Properties of a blob

    % Copyright 2023 The MathWorks, Inc.

    properties
    end
    
    methods
        function obj = BlobProperties(varargin)
            initialize('loggerPrefix', 'Azure:ADLSG2');
            
            if nargin == 0
                obj.Handle = com.azure.storage.blob.models.BlobProperties();
            elseif nargin == 1 && isa(varargin{1}, 'com.azure.storage.blob.models.BlobProperties')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid argument(s), expected no argument or a com.azure.storage.blob.models.BlobProperties');
            end
        end %constructor

        function value = getCacheControl(obj)
            % GETCACHECONTROL Get the the cache control of the blob
            value = char(obj.Handle.getCacheControl);
        end

        function value = getContentEncoding(obj)
            % GETCONTENTENCODING Get the content encoding of the blob
            value = char(obj.Handle.getContentEncoding);
        end

        function value = getContentLanguage(obj)
            % GETCONTENTLANGUAGE Get the content language of the blob
            value = char(obj.Handle.getContentLanguage);
        end

        function value = getContentType(obj)
            % GETCONTENTTYPE Get the content type of the blob
            value = char(obj.Handle.getContentType);
        end

        function value = getContentMd5(obj)
            % GETCONTENTMD5 Get the MD5 of the blob's content
            % Return the base64 value shown in the Azure portal
            b64int8 = obj.Handle.getContentMd5;
            b64int8 = b64int8';
            b64uint8 = zeros(1,numel(b64int8), 'uint8');
            for n = 1:numel(b64int8)
                if b64int8(n) < 0
                    b64uint8(n) = int32(b64int8(n)) + 256;
                else
                    b64uint8(n) = b64int8(n);
                end
            end
            uint8Val = matlab.net.base64encode(b64uint8);
            value = char(uint8Val);
        end

    end %methods
end %class
