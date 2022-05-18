classdef QueueClient < azure.object
% QUEUECLIENT Client performs generic queue operations

% Copyright 2020-2022 The MathWorks, Inc.

properties
end

    methods
        function obj = QueueClient(varargin)
            
            if nargin == 0
                initialize('displayLevel', 'debug', 'loggerPrefix', 'Azure:ADLSG2');
    
                connectStr = getenv('AZURE_STORAGE_CONNECTION_STRING');
            
                if isempty(connectStr)
                    logObj = Logger.getLogger();
                    write(logObj,'error','AZURE_STORAGE_CONNECTION_STRING not set');
                end
        
                httpClient = com.azure.core.http.netty.NettyAsyncHttpClientBuilder;
                queueClientj = com.azure.storage.queue.QueueClientBuilder().httpClient(httpClient.build()).connectionString(connectStr).buildClient();
                obj.Handle = queueClientj;
    
            elseif nargin == 1 && isa(varargin{1}, 'com.azure.storage.queue.QueueClient')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid argument(s)');
            end
    
        end
    
        function delete(obj, varargin)
            % DELETE QueueClient destructor - in MATLAB delete is a
            % reserved method name for the class destructor. This method
            % does not delete Queues on Azure. To delete the Azure
            % Queue use the deleteQueue method in MATLAB.
        end
    end
end
