classdef (Abstract) TokenCredential < azure.object
    % TOKENCREDENTIAL Credential that can provide an access token

    % Copyright 2020-2021 The MathWorks, Inc.

    methods
        function accessToken = getToken(obj, request)
            % GETTOKEN Retrieves an AccessToken
            % An azure.core.credential.AccessToken is returned.

            % Copyright 2020-2022 The MathWorks, Inc.

            if ~isa(request, 'azure.core.credential.TokenRequestContext')
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid credential argument');
            end

            accessTokenj = obj.Handle.getToken(request.Handle);
            accessToken = azure.core.credential.AccessToken(accessTokenj);

        end
    end

end
