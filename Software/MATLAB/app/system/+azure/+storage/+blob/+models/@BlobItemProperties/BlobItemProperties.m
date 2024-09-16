classdef BlobItemProperties < azure.object
    % BlobItemProperties Properties of a blob

    % Copyright 2023 The MathWorks, Inc.

    properties
    end
    
    methods
        function obj = BlobItemProperties(varargin)
            initialize('loggerPrefix', 'Azure:ADLSG2');
            
            if nargin == 0
                obj.Handle = com.azure.storage.blob.models.BlobItemProperties();
            elseif nargin == 1 && isa(varargin{1}, 'com.azure.storage.blob.models.BlobItemProperties')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid argument(s), expected no argument or a com.azure.storage.blob.models.BlobItemProperties');
            end
        end %constructor

        function value = getCacheControl(obj)
            % GETCACHECONTROL Get the cacheControl property
            value = char(obj.Handle.getCacheControl);
        end

        function value = getContentEncoding(obj)
            % GETCONTENTENCODING Get the getContentEncoding property
            value = char(obj.Handle.getContentEncoding);
        end

        function value = getContentLanguage(obj)
            % GETCONTENTLANGUAGE Get the getContentLanguage property
            value = char(obj.Handle.getContentLanguage);
        end

        function value = getContentType(obj)
            % GETCONTENTTYPE Get the getContentType property
            value = char(obj.Handle.getContentType);
        end

        function value = getContentLength(obj)
            % GETCONTENTLENGTH Get the contentType property
            str = string(obj.Handle.getContentLength.toString);
            value = sscanf(str,'%ld');
        end

        function value = getContentMd5(obj)
            % GETCONTENTMD5 Get the getContentMd5 property
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
