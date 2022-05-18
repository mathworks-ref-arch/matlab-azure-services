classdef AuthenticationRecord < azure.object
    % Represents the account information relating to an authentication request
    % Held as a Java reactor.core.publisher.MonoMap.

    % Copyright 2021 The MathWorks, Inc.

    methods
        function obj = AuthenticationRecord(varargin)
            if length(varargin) == 1
                arj = varargin{1};
                if isa(arj, 'reactor.core.publisher.MonoMap')
                    obj.Handle = arj;
                else
                    logObj = Logger.getLogger();
                    write(logObj,'error','Expected argument of type reactor.core.publisher.MonoMap');
                end
            elseif isempty(varargin)
            else
                logObj = Logger.getLogger();             
                write(logObj,'error','Unexpected number of arguments');
            end
        end
    end
end