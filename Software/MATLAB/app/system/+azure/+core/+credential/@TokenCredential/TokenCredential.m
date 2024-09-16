classdef (Abstract) TokenCredential < azure.object
    % TOKENCREDENTIAL Credential that can provide an access token

    % Copyright 2020-2023 The MathWorks, Inc.

    methods
        function accessToken = getToken(obj, request)
            % GETTOKEN Asynchronously retrieves an AccessToken
            % An azure.core.credential.AccessToken is returned.
            % This call is invokes the getTokenSync method rather than
            % getToken intentionally.

            if ~isa(request, 'azure.core.credential.TokenRequestContext')
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid credential argument');
            end
            accessTokenj = obj.Handle.getTokenSync(request.Handle);
            accessToken = azure.core.credential.AccessToken(accessTokenj);
        end

        function accessToken = getTokenSync(obj, request)
            % GETTOKENSYNC Synchronously retrieves an AccessToken
            % An azure.core.credential.AccessToken is returned.

            if ~isa(request, 'azure.core.credential.TokenRequestContext')
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid credential argument');
            end
            accessTokenj = obj.Handle.getTokenSync(request.Handle);
            accessToken = azure.core.credential.AccessToken(accessTokenj);
        end
    end

end
