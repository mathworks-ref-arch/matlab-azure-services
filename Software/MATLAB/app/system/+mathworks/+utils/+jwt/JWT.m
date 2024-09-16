classdef JWT
    % JWT Represent a Java Web Token
    % All times as assumed to be UTC
    %
    % This is not a generic JWT interface and is intended for use with
    % Azure Data Explorer only at this point.

    % Copyright 2023 The MathWorks, Inc.

    properties
        header struct
        claims struct
        signature string
        token string
    end

    methods
        function obj = JWT(token)
            % JWT Create a JWT object from a token string
            arguments
                token string {mustBeTextScalar}
            end
            obj.token = token;

            parts = split(token,'.');
            if numel(parts) < 3
                error("JWT:JWT", "Expected a JWT with at least 3 '.' separated fields");
            end
            header = char(matlab.net.base64decode(parts{1}));
            claims = char(matlab.net.base64decode(parts{2}));
            obj.signature = parts{3};
            
            header = strip(header, char(uint8(0)));
            claims = strip(claims, char(uint8(0)));

            obj.header = jsondecode(header);
            claimsJM = mathworks.utils.jwt.ClaimsJM(claims);
            claimsJSON = jsondecode(claims);
            
            claimsJMprops = properties(claimsJM);
            for n = 1:numel(claimsJMprops)
                if isfield(claimsJSON, claimsJMprops{n})
                    claimsJSON.(claimsJMprops{n}) = claimsJM.(claimsJMprops{n});
                end
            end
            obj.claims = claimsJSON;
        end

        
        function tf = isTimeValid(obj)
            if ~isfield(obj.claims, 'nbf')
                error("JWT:isTimeValid", "Expected nbf field not found");
            end
            if ~isfield(obj.claims, 'exp')
                error("JWT:isTimeValid", "Expected exp field not found");
            end

            pt = posixtime(datetime('now','TimeZone', 'UTC'));
            if pt > obj.claims.nbf && pt < obj.claims.exp
                tf = true;
            else
                tf = false;
            end
        end


        function exp = expiryTime(obj)
            if ~isfield(obj.claims, 'exp')
                error("JWT:expiryTime", "Expected exp field not found");
            end
            exp = datetime(obj.claims.exp, 'ConvertFrom', 'posixtime', 'TimeZone', 'UTC');
        end


        function nbf = notBeforeTime(obj)
            if ~isfield(obj.claims, 'nbf')
                error("JWT:notBeforeTime", "Expected nbf field not found");
            end
            nbf = datetime(obj.claims.nbf, 'ConvertFrom', 'posixtime', 'TimeZone', 'UTC');
        end


        function tf = isExpired(obj)
            if ~isfield(obj.claims, 'exp')
                error("JWT:isExpired", "Expected exp field not found");
            end
            if posixtime(datetime('now', 'TimeZone', 'UTC')) < obj.claims.exp
                tf = false;
            else
                tf = true;
            end
        end
    end
end