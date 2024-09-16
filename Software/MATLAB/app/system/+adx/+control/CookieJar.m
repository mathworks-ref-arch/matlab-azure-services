classdef CookieJar < handle
    % COOKIEJAR helper class in MATLAB Generator for OpenAPI package,
    % provides a cookie jar. A cookie jar holds cookies which are typically 
    % set by Set-Cookie headers in HTTP(S) requests and it can return the
    % cookies which should be included in a request to a given URL.
    %
    % CookieJar Properties:
    %   path       - Directory where to save cookies.mat
    %
    % CookieJar Methods:
    %   setCookies - Adds cookies to the jar.
    %   getCookies - Return an array of cookies which match the given URL
    %
    %   persist    - Forces cookie jar to be saved to disk
    %   load       - Forces cookie jar to be loaded from disk
    %   purge      - Empties the entire cookie jar and deletes cookies from
    %                disk
    
    % Copyright 2022 The MathWorks, Inc.
    
    properties(Access=private)
        cookiejar
    end
    properties
        path
    end
    
    methods

        function obj = CookieJar(path)
            if nargin == 0
                path = prefdir;
            end
            % CookieJar Constructor
            obj.path = path;
            obj.load;
        end

        function setCookies(obj, cookies)
            % SETCOOKIES Adds cookies to the jar. Expects an array of
            % matlab.net.http.CookieInfo as input. This can for example be
            % obtained using matlab.net.http.CookieInfo.collectFromLog or
            % by manually instantiating matlab.net.http.CookieInfo.
            %
            % See Also: matlab.net.http.CookieInfo.collectFromLog
            
            % For each cookie
            for cookie = cookies
                % Form a key based on cookie info
                key = sprintf('%s|%s|%d|%d|%d|%s',cookie.Domain,cookie.Path,cookie.Secure,cookie.HttpOnly,cookie.HostOnly,cookie.Cookie.Name);
                
                % Use they to automatically either add or update
                obj.cookiejar(key) = cookie;
            end
            obj.persist;
        end

        function cookies = getCookies(obj, uri)
            % GETCOOKIES returns an array of matlab.net.http.Cookie for the
            % given URI which must be provided as first input.
            if isempty(obj.cookiejar)
                cookies = [];
            else
                % Start a new Map
                c = containers.Map;
                % Sort cookies such that broadest applicable cookies are
                % evaluated first. They may then get overwritten with
                % a more specific cookie later. First sort by whether
                % Cookie is Host specific and then by path length
                cs = cellfun(@(x)[x.HostOnly,strlength(x.Path)],obj.cookiejar.values,'UniformOutput',false);
                [~,ii] = sortrows(vertcat(cs{:}));
                % Go through the cookies in this sorted order
                allCookies = obj.cookiejar.values;
                for i = ii'
                    % Get current cookie
                    cc = allCookies{i};
                    
                    if  (~endsWith(uri.Host, cc.Domain, "IgnoreCase", true)) || ...                           % Do NOT add if host does not match
                        (~startsWith(uri.EncodedPath,cc.Path, "IgnoreCase", true)) || ... % Do NOT add if path does not match
                        (cc.Secure && uri.Scheme ~= "https") || ...                       % Do NOT add if secure cookie but not HTTPS
                        (cc.ExpirationTime < datetime('now','timezone','local'))          % Do NOT add if cookie expired
                        continue
                    end
                    
                    % If everything matches, include cookie, this may add a
                    % new cookie to the map or overwrite a less specific one
                    c(cc.Cookie.Name) = cc.Cookie;
                end

                % Then return all matching cookies
                cookies = c.values;
                cookies = [cookies{:}];
            end
        end

        function persist(obj, path)
            % PERSIST forces cookie jar to be saved to disk. This method is
            % also called automatically by setCookies if new cookies are
            % added. Can be called with a alternative directory as input to
            % force saving cookies.mat to this alternative location. The
            % CookieJar instance is then also reconfigured to continue 
            % working with this new location.
            if nargin == 2
                obj.path = path;
            end
            cookies = obj.cookiejar;
            save(fullfile(obj.path,'cookies.mat'),'cookies');
        end

        function load(obj,path)
            % LOAD forces cookie jar to be loaded from disk. This method is
            % also called automatically by the constructor. Can be called
            % with a alternative directory as input to force saving
            % cookies.mat to this alternative location. The CookieJar
            % instance is then also reconfigured to continue working with
            % this new location.
            if nargin == 2
                obj.path = path;
            end
            if isfile(fullfile(obj.path,'cookies.mat'))
                c = load(fullfile(obj.path,'cookies.mat'),'cookies');
                obj.cookiejar = c.cookies;
            else
                obj.cookiejar = containers.Map();
            end
        end

        function purge(obj)
            % PURGE completely empties the cookie jar and also deletes
            % cookies.mat from disk.
            obj.cookiejar = containers.Map;
            if isfile(fullfile(obj.path,'cookies.mat'))
                delete(fullfile(obj.path,'cookies.mat'))
            end
        end

    end
end