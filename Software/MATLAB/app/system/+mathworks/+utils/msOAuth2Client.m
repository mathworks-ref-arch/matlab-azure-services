classdef msOAuth2Client < handle
    % msOAuth2Client obtains and caches tokens for the Microsoft
    % Identity Platform.
    %
    % OAuth2Client Methods:
    %   OAuth2Client    - Constructor
    %   getToken        - Obtain an access token for a requested scope
    %   getFullToken    - Obtain the full token for a requested scope
    %
    % Note: the access tokens and refresh tokens are stored inside a
    % MAT-file in plain-text and are not encrypted. The MAT-file is saved
    % as .mlMsTokenCache in your home directory. This file should be kept
    % confidential.

    % Copyright 2022-2024 The MathWorks, Inc.

    properties (Access=private, Constant)
        CACHEFILENAME = fullfile(char(java.lang.System.getProperty('user.home')),'.mlMsTokenCache')
    end
    
    properties (Access=private)
        clientId
        clientSecret
        tenantId
        tokenCache
        refreshWindow = minutes(15)
        additionalOptions
    end

    methods
        function obj = msOAuth2Client(tenantId,clientId,clientSecret,additionalOptions)
            % msOAuth2Client Constructor
            %
            %   Create a client for user principals through Device Code 
            %   authentication:
            %
            %     client = msOAuth2Client(tenantId,clientId);
            %
            %   When working with Device Code authentication, user
            %   interaction is needed if a new token has to be requested.
            %   If the requested token already exists in the cache (and can
            %   be refreshed if needed) no further user interaction should
            %   be required.
            %
            %   Create a client for service principals through Client
            %   Secret authentication:
            %
            %       client = msOAuth2Client(tenantId,clientId,clientSecret);
            %
            %   When working with Client Secret authentication, no user
            %   interaction is required.
            arguments
                tenantId string
                clientId string
                clientSecret string = string.empty
                additionalOptions.CopyCode = true
                additionalOptions.OpenBrowser = true
                additionalOptions.Method = string.empty
                additionalOptions.ServiceMetadataURI = matlab.net.URI
            end
            % Set object properties
            obj.tenantId = tenantId;
            obj.clientId = clientId;
            obj.clientSecret = clientSecret;
            obj.additionalOptions = additionalOptions;
        end

    
        function token = getToken(obj, scopes)
            % GETTOKEN Obtain and return an access token for the configured
            % Tenant, ClientID and Scopes.
            %
            %   If a token for configured Tenant, ClientID and Scopes:
            %       - IS found in the cache and it
            %           - Has NOT expired, it is returned
            %           - HAS expired and a refresh token IS available, it
            %             is refreshed and then returned, if refresh fails
            %             a new token is requested and returned
            %           - HAS expired and there is NO refresh token, a new
            %             token is requested and returned
            %       - Is NOT found in the cache, a new token is requested 
            %         and returned upon success 
            %
            %   Note: to obtain a refresh token, explicitly include 
            %   "offline_access" in the requested scopes.
            %
            %   Examples:
            %
            %       Obtain an access token for Azure Key Vault Scope with
            %       refresh token:
            %
            %           access_token = GETTOKEN(["https://vault.azure.net/.default","offline_access"])
            %
            %       Obtain an access token for Azure Storage without
            %       refresh token:
            %
            %           access_token = GETTOKEN(["https://storage.azure.com/.default"])
            
            arguments
                obj (1,1) mathworks.utils.msOAuth2Client
                scopes string
            end

            % Get the full token
            fullToken = obj.getFullToken(scopes);
            % Only actually return the access token
            % token = fullToken.accessToken;
            % TODO - cleanup
            token = fullToken;
        end
    
        function token = getFullToken(obj, scopes)
            % GETFULLTOKEN Obtains a token in the same way as getToken,
            % only instead of only returning the access token itself, a
            % struct is returned which contains the accessToken, an
            % expiresAt field, and if available also a refreshToken. Then
            % syntax for this method is the same as for getToken.
            %
            % See Also: GETTOKEN

            arguments
                obj (1,1) mathworks.utils.msOAuth2Client
                scopes string
            end

            % For consistency sort the scopes alphabetically
            scopes = sort(scopes);

            % Refresh the cache from disk or create a new one
            obj.initializeCache();

            % Try to find a token in the cache
            if ~isempty(obj.clientSecret)
                principal = "service";
            else
                principal = "user";
            end

            % TODO reenable caching
            %token = findTokenInCache(obj,principal,scopes);
            token = '';
            
            if ~isempty(token)
                % Check expiry
                if (token.expiresAt - datetime('now') > obj.refreshWindow)
                    % Token is not expired, return token
                    return
                end
                % Token has expired, if there is refresh token try to
                % refresh
                if isfield(token,'refreshToken')
                    token = obj.refreshToken(principal,scopes,token);
                    if ~isempty(token)
                        % Token refreshed successfully, return  token
                        return
                    end
                end
            end
            % If there was no token in the first place, there is no refresh
            % token or refresh failed, try to obtain an entirely new one
            token = obj.acquireToken(scopes);
        end
    end


    methods (Access=private)

        function token = refreshToken(obj, principal, scopes, token)
            % Perform the refresh

            arguments
                obj (1,1) mathworks.utils.msOAuth2Client
                principal string {mustBeTextScalar, mustBeNonzeroLengthText}
                scopes string
                token string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            url = sprintf('https://login.microsoftonline.com/%s/oauth2/v2.0/token',obj.tenantId);
            body = matlab.net.QueryParameter(...
                'tenant',obj.tenantId,...
                'client_id',obj.clientId,...
                'grant_type','refresh_token',...
                'refresh_token', token.refreshToken);
            req = matlab.net.http.RequestMessage('POST',...
                matlab.net.http.field.ContentTypeField('application/x-www-form-urlencoded'),...
                body);
            res = req.send(url);
            if res.StatusCode ~= 200
                % If not successful, throw a *warning* (we can still try to
                % obtain a brand new token, so do not error out entirely)
                warning('Refreshing token failed:\n%s\n%s',res.StatusLine,char(res.Body));
                token = [];
                return
            end
            % If successful, update the old token
            token.accessToken = res.Body.Data.access_token;
            token.expiresAt = datetime('now') + seconds(res.Body.Data.expires_in);
            if isfield(res.Body.Data,'refresh_token')
                token.refreshToken = res.Body.Data.refresh_token;
            end
            if isfield(res.Body.Data,'id_token')
                token.idToken = res.Body.Data.id_token;
            end
            % Save new token in cache
            obj.addTokenToCache(principal,scopes,token);
        end

        function token = acquireToken(obj,scopes)
            arguments
                obj (1,1) mathworks.utils.msOAuth2Client
                scopes string
            end

            switch lower(obj.additionalOptions.Method)
                case string.empty
                    if ~isempty(obj.clientSecret)
                        % Obtain using client credential grant
                        token = obj.acquireClientCredentialToken(scopes);
                    else
                        % Obtain using devicecode flow
                        token = obj.acquireDeviceCodeToken(scopes);
                    end

                case "devicecode"
                    token = obj.acquireDeviceCodeToken(scopes);

                case "clientsecret"
                    token = obj.acquireClientCredentialToken(scopes);

                case "interactivebrowser"
                    token = obj.acquireInteractiveBrowserToken(scopes, obj.additionalOptions.ServiceMetadataURI);
            
                case "managedidentity"
                    token = obj.acquireManagedIdentityToken(scopes);
            
                otherwise
                    error('Unexpected authentication Method value: %s',obj.additionalOptions.Method);
            end
        end

        function token = acquireManagedIdentityToken(obj, scopes)
            arguments
                obj (1,1) mathworks.utils.msOAuth2Client
                scopes string
            end

            builder = azure.identity.ManagedIdentityCredentialBuilder();
            builder = builder.clientId(obj.clientId);
            builder = builder.httpClient();
            builder = builder.maxRetry(int32(1));
            credentials = builder.build();
    
            tr = azure.core.credential.TokenRequestContext;
            for n=1:numel(scopes)
                tr = tr.addScopes(scopes(n));
            end
            token = string(credentials.getToken(tr).getToken());
        end

        function token = acquireInteractiveBrowserToken(obj, scopes, serviceMetadataURI)
            arguments
                obj (1,1) mathworks.utils.msOAuth2Client
                scopes string
                serviceMetadataURI (1,1) matlab.net.URI
            end

            scopeFields = split(string(scopes)," ");
            redirectUrl = "http://localhost:8765";
            webOpts = weboptions('Timeout', 30);
            kustoMetaData = webread(serviceMetadataURI, webOpts);
            if isfield(kustoMetaData, 'AzureAD')
                if isfield(kustoMetaData.AzureAD, 'KustoClientAppId')
                    KustoClientAppId = kustoMetaData.AzureAD.KustoClientAppId;
                else
                    error('KustoClientAppId field not found in kustoMetaData.AzureAD');
                end
            else
                error('AzureAD field not found in kustoMetaData');
            end

            % Build credential
            builder = azure.identity.InteractiveBrowserCredentialBuilder();
            builder = builder.clientId(KustoClientAppId);
            builder = builder.tenantId(obj.tenantId);
            builder = builder.redirectUrl(redirectUrl);
            builder = builder.httpClient();
            builder = builder.authorityHost(strcat('https://login.microsoftonline.com/', obj.tenantId));
            credentials = builder.build();

            tr = azure.core.credential.TokenRequestContext;
            for n=1:numel(scopeFields)
                tr = tr.addScopes(scopeFields(n));
            end
            token = string(credentials.getToken(tr).getToken());
        end

        function token = acquireClientCredentialToken(obj,scopes)
            arguments
                obj (1,1) mathworks.utils.msOAuth2Client
                scopes string
            end

            scopes = strjoin(scopes," ");
            % Obtain the token through client secret flow
            url = sprintf('https://login.microsoftonline.com/%s/oauth2/v2.0/token',obj.tenantId);
            body = matlab.net.QueryParameter(...
                'tenant',obj.tenantId,...
                'client_id',obj.clientId,...
                'client_secret',obj.clientSecret,...
                'scope',scopes,...
                'grant_type','client_credentials');
            req = matlab.net.http.RequestMessage('POST',...
                matlab.net.http.field.ContentTypeField('application/x-www-form-urlencoded'),...
                body);
            res = req.send(url);
            if res.StatusCode ~= 200
                error('Error occurred while obtaining token using Client Secret:\n%s\n%s',res.StatusLine,char(res.Body));
            end
            % Cache the token information
            token.accessToken = res.Body.Data.access_token;
            token.expiresAt = datetime('now') + seconds(res.Body.Data.expires_in);
            % Save the token to the cache
            obj.addTokenToCache('service',scopes,token);
        end

        function token = acquireDeviceCodeToken(obj,scopes)
            % Initiate Device Code Authentication
            arguments
                obj (1,1) mathworks.utils.msOAuth2Client
                scopes string
            end

            scopes = strjoin(scopes," ");
            url = sprintf('https://login.microsoftonline.com/%s/oauth2/v2.0/devicecode',obj.tenantId);
            body = matlab.net.QueryParameter(...
                'tenant',obj.tenantId,...
                'client_id',obj.clientId,...
                'scope',scopes);
            req1 = matlab.net.http.RequestMessage('POST',[ ...
                    matlab.net.http.field.ContentTypeField('application/x-www-form-urlencoded'),...
                    matlab.net.http.HeaderField('Accept','application/json') ...
                  ],body);
            res1 = req1.send(url);
            if res1.StatusCode ~= 200
                error('Error occurred while initiating Device Login:\n%s\n%s',res1.StatusLine,char(res1.Body));
            end
            
            % Display instructions
            disp(res1.Body.Data.message);
            
            % Copy code to clipboard and open browser
            if obj.additionalOptions.CopyCode
                clipboard("copy",res1.Body.Data.user_code)
            end
            if obj.additionalOptions.OpenBrowser
                web(res1.Body.Data.verification_uri);
            end

            % Poll for response
            expires = datetime('now') + seconds(res1.Body.Data.expires_in);
            interval = res1.Body.Data.interval;
            fprintf('Waiting for authorization...')
            % Configure Token URL
            url = sprintf('https://login.microsoftonline.com/%s/oauth2/v2.0/token',obj.tenantId);
            % Prepare request
            body = matlab.net.QueryParameter(...
                'tenant',obj.tenantId,...
                'client_id',obj.clientId,...
                'grant_type','urn:ietf:params:oauth:grant-type:device_code',...
                'device_code', res1.Body.Data.device_code);
            req2 = matlab.net.http.RequestMessage('POST',...
                matlab.net.http.field.ContentTypeField('application/x-www-form-urlencoded'),...
                body);
            while datetime('now') < expires
                % Perform the actual request
                res2 = req2.send(url);
                % Check the response
                switch res2.StatusCode
                    case 200 % Success
                        fprintf('success\n');
                        % Grab the relevant fields from the response
                        token.accessToken = res2.Body.Data.access_token;
                        token.expiresAt = datetime('now') + seconds(res2.Body.Data.expires_in);
                        if isfield(res2.Body.Data,'refresh_token')
                            token.refreshToken = res2.Body.Data.refresh_token;
                        end
                        if isfield(res2.Body.Data,'id_token')
                            token.idToken = res2.Body.Data.id_token;
                        end
                        % Store the obtained token in the cache
                        obj.addTokenToCache('user',scopes,token);
                        return
                    case 400 % Still pending or an actual error
                        switch res2.Body.Data.error
                            case "authorization_pending"
                                % No real error, the user simply has not
                                % entered the code yet, just wait and try
                                % again
                                pause(interval)
                                fprintf('.')
                            case "authorization_declined"
                                % The user actively declined the request
                                error('The end user denied the authorization request.')
                            case "expired_token"
                                error('Authorization did not complete within timeout period.')
                            otherwise
                                error('Error occurred while polling for Device Login to complete:\n%s\n%s',res2.StatusLine,char(res2.Body));
                        end % error in body
                    otherwise % Unknown StatusCode
                        error('Error occurred while polling for Device Login to complete:\n%s\n%s',res2.StatusLine,char(res2.Body));
                end % end StatusCode
            end % end while
            error('Authorization did not complete within timeout period.');
        end


        function addTokenToCache(obj,principal,scopes,token)
            % Check whether any tokens have been cached for the given
            % tenant at all
            arguments
                obj (1,1) mathworks.utils.msOAuth2Client
                principal string {mustBeTextScalar, mustBeNonzeroLengthText}
                scopes string
                token
            end

            if ~obj.tokenCache.isKey(obj.tenantId)
                obj.tokenCache(obj.tenantId) = containers.Map();
            end
            cache = obj.tokenCache(obj.tenantId);
            % Check whether any tokens have been cached for the given
            % principal at all
            if ~cache.isKey(principal)
                cache(principal) = containers.Map();
            end
            cache = cache(principal);
            
            % Check whether any tokens have been cached for the given
            % clientId at all
            if ~cache.isKey(obj.clientId)
                cache((obj.clientId)) = containers.Map();
            end
            cache = cache(obj.clientId);

            % Store the token in the cache under the right scopes key
            scopesKey = strjoin(scopes," ");
            cache(scopesKey) = token;

            % And save the cache
            obj.saveCache
        end

        function token = findTokenInCache(obj,principal,scopes)
            % Return an empty token if returning early
            arguments
                obj (1,1) mathworks.utils.msOAuth2Client
                principal string {mustBeTextScalar, mustBeNonzeroLengthText}
                scopes string
            end

            token = [];
            % Check whether any tokens have been cached for the given
            % tenant at all
            if ~obj.tokenCache.isKey(obj.tenantId)
                return
            end
            cache = obj.tokenCache(obj.tenantId);
            % Check whether any tokens have been cached for the given
            % principal at all
            if ~cache.isKey(principal)
                return
            end
            cache = cache(principal);
            
            % Check whether any tokens have been cached for the given
            % clientId at all
            if ~cache.isKey(obj.clientId)
                return
            end
            cache = cache(obj.clientId);

            % Check whether any tokens have been cached for the requested
            % scopes
            scopesKey = strjoin(scopes," ");
            if ~cache.isKey(scopesKey)
                return
            end
            
            % Return the one and only token which was found if we got to
            % here
            token = cache(scopesKey);
        end

        function initializeCache(obj)
            % Load cache from disk if it exists or start a new one
            if exist(obj.CACHEFILENAME,'file') == 2
                data = load(obj.CACHEFILENAME,'-mat');
                obj.tokenCache = data.cache;
            else
                obj.tokenCache = containers.Map;
            end
        end

        function saveCache(obj)
            % Save the cache to disk
            cache = obj.tokenCache;
            save(obj.CACHEFILENAME,'cache');
        end
    end
end