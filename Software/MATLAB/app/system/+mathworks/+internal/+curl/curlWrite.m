function [tf, result] = curlWrite(url, dataFilename, webOpts, verbose, options)
    % curlWrite webwrite like functionality via curl PoC implementation
    % This function may be changed or removed in a future release without
    % notice. Currently only windows is supported.
    % Currently only the HTTP POST method is supported.
    % This function is provided as a testing mechanism for TCP keep-alive
    % Packets.
    %
    % Required Arguments
    %
    %   url: A MATLAB.net.URI containing the host to connect to an any
    %        required path elements e.g.:
    %        matlab.net.URI("https://myhost.example.com:1234/path1/path2")
    %
    %   dataFilename: A scalar text value for a filename containing the JSON
    %                 request body payload to send to the endpoint.
    %
    %   webOpts: A weboptions object. Used to configure curl arguments.
    %            NB: This value is currently required but NOT yet used.
    %
    % Optional Positional Argument
    %
    %   verbose: A logical in enable or disable increased logging
    %            Default is true
    %
    % Optional Named Arguments
    %
    %   keepaliveTime: An integer number of seconds after which to send a
    %                  keep-alive packet. Default is 60.
    %
    %   additionalArguments: A string array of extra arguments to be appended to
    %                        the generated curl command. Prefix and postfix padding
    %                        will be added.
    %
    %   skipJSONDecode: A logical to skip decoding returned JSON and just
    %                   return a scalar character vector. Default is false.
    %
    % Return Value:
    %
    %   Response: Decoded JSON or a character vector containing the returned JSON
    %             See: skipJSONDecode.
    %
    % Example:
    %
    %   result = mathworks.internal.curl.curlWrite(matlab.net.URI("https://httpbin.org/post"), "", weboptions, true)
    %
    % See also: mathworks.internal.curl.adxCurlWrite

    % Copyright 2024 The MathWorks

    arguments
        url (1,1) matlab.net.URI
        dataFilename string {mustBeTextScalar, mustBeNonzeroLengthText}
        webOpts (1,1) weboptions
        verbose (1,1) logical = true
        options.keepaliveTime (1,1) int32 = 60
        options.additionalArguments string = ""
        options.skipJSONDecode logical = false
    end

    if ismac
        % test equivalent of Linux and macOS curl for Linux, it should work - TODO
        warning("MATHWORKS:curlWrite", "curlWrite is currently tests only Windows & Linux platforms");
    end

    if ispc
        cmd = "curl.exe ";
    else
        cmd = "curl ";
    end
    
    minusD = "--data ""@" + dataFilename + """ ";

    % Write the output to a file and read that back to avoid limits and noise in shell output
    oFilename = string(tempname);
    oFile = "--output """ + oFilename + """ ";

    % This is not an option in webwrite or matlab.net.http
    minusKeepaliveTime = sprintf("--keepalive-time %d ", options.keepaliveTime);

    % Include the path as well, not just the host
    minusUrl = "--url """ + url.EncodedURI + """ ";

    % Used to get status
    minusV = "--verbose ";

    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Handle weboptions properties
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if isprop(webOpts, 'UserAgent')
        minusUserAgent = "--user-agent """ + string(webOpts.UserAgent) + """ ";
    else
        minusUserAgent = "--user-agent """ + string(['MATLAB ', version]) + """ ";
    end

    % Use the same default as webwrite, 5 seconds
    if isprop(webOpts, 'Timeout')
        if ~isempty(webOpts.Timeout) && webOpts.Timeout > 0
            minusConnectTimeout = "--connect-timeout " + string(num2str(webOpts.Timeout)) + " ";
        else
            minusConnectTimeout = "--connect-timeout 5 ";
        end
    else
        minusConnectTimeout = "--connect-timeout 5 ";
    end

    % Assume application JSON
    if isprop(webOpts, 'ContentType')
        if strcmp(webOpts.ContentType, 'auto') || strcmp(webOpts.ContentType, 'json')
            minusAccept = "--header ""Accept:application/json; charset=utf-8"" ";
        else
            minusAccept = "--header ""Accept:" + string(webOpts.ContentType) + """ ";
        end
    else
        minusAccept = "--header ""Accept:application/json; charset=utf-8"" ";
    end

    % Default for webwrite is POST
    if isprop(webOpts, 'RequestMethod')
        if strcmp(webOpts.RequestMethod, 'auto') || strcmpi(webOpts.RequestMethod, 'POST')
            minusRequest = "--request POST ";
        else
            error("MATHWORKS:curlWrite", "Only the POST method is currently supported");
        end
    else
        minusRequest = "--request POST ";
    end

    % Only support JSON for now
    if isprop(webOpts, 'MediaType')
        if strcmp(webOpts.MediaType, 'auto') || strcmpi(webOpts.MediaType, 'json') || startsWith(webOpts.MediaType, "application/json")
            minusContentType = "--header ""Content-Type:application/json;charset=utf-8"" ";
        else
            minusContentType = "--header ""Content-Type:" + string(webOpts.MediaType) + """ ";
        end
    else
        minusContentType = "--header ""Content-Type:application/json;charset=utf-8"" ";
    end

    % Don't handle CertificateFilename for now
    if isprop(webOpts, "CertificateFilename")
        if ~strcmp(webOpts.CertificateFilename, 'default')
            error("MATHWORKS:curlWrite", "Setting a custom CertificateFilename is not currently supported");
        end
    end

    % Don't handle KeyName for now
    if isprop(webOpts, "KeyName")
        if ~strcmp(webOpts.KeyName, '')
            error("MATHWORKS:curlWrite", "Setting a custom KeyName is not currently supported");
        end
    end

    % Don't handle KeyValue for now
    if isprop(webOpts, "KeyValue")
        if ~strcmp(webOpts.KeyValue, '')
            error("MATHWORKS:curlWrite", "Setting a custom KeyValue is not currently supported");
        end
    end

    % Don't handle ContentReader for now
    if isprop(webOpts, "ContentReader")
        if ~isempty(webOpts.ContentReader)
            error("MATHWORKS:curlWrite", "Setting a custom ContentReader is not currently supported");
        end
    end

    % Don't handle ArrayFormat for now
    if isprop(webOpts, "ArrayFormat")
        if ~strcmp(webOpts.ArrayFormat, 'csv') % Default value is 'csv'
            error("MATHWORKS:curlWrite", "Setting a custom ArrayFormat is not currently supported");
        end
    end

    % Apply web opts custom headers
    if isprop(webOpts, "HeaderFields")
        minusWebOptsHeaders = "";
        for n = 1:height(webOpts.HeaderFields)
            kv = webOpts.HeaderFields(n,1:2); % Get 2 values
            minusWebOptsHeaders = minusWebOptsHeaders + "--header " + """"+ string(kv{1}) + ":" + string(kv{2}) + """"  + " ";
        end
    else
        minusWebOptsHeaders = "";
    end

    % MATLAB uses 1.1 by default so match it for consistency
    minusHTTPVer = "--http1.1 ";

    command = cmd + minusHTTPVer + minusUrl + minusD + minusRequest + oFile + minusKeepaliveTime + minusContentType + minusAccept + minusV + minusUserAgent + minusConnectTimeout + minusWebOptsHeaders;

    % Pass arbitrary additional arguments, pad with spaces
    for n = 1:numel(options.additionalArguments)
        command = command + " " + options.additionalArguments(n);
    end
    command = strip(command);

    % TODO test need to unset DYLD_LIBRARY_PATH on macOS
    if isunix && ~ismac
        command = "unset LD_LIBRARY_PATH; " + command;
    end

    if verbose
        fprintf("Running: %s\n", command);
    end

    % Delete the output file on cleanup, if it exists
    cleanup = onCleanup(@() doCleanup(oFilename));

    [cmdStatus, cmdout] = system(command);

    % Will display the bearer token
    if verbose
        disp(cmdout);
    end

    % Curl seems to return 0 in most cases, so it is not that useful
    if cmdStatus ~= 0
        fprintf("Error running: %s\nStatus: %d\nOutput: %s\n", command, cmdStatus, cmdout);
        tf = false;
        result = struct;
    else

        % If HTTP 200 is found return true
        tf = contains(cmdout, "< HTTP/1.1 200");

        if tf
            % Read back the output and return it decoded by default
            if isfile(oFilename)
                if options.skipJSONDecode
                    result = fileread(oFilename);
                else
                    try
                        outputText = fileread(oFilename);
                        result = jsondecode(outputText);
                    catch ME
                        fprintf("Unable to jsondecode output, message: %s\nOutput:\n%s", ME.message, outputText);
                        result = struct;
                    end
                end
            else
                error("MATHWORKS:curlWrite", "Output file not found: %s", oFilename);
            end
        else
            result = struct;
        end
    end
end


function doCleanup(filename)
    % doCleanup Delete the temporary output file if it exists
    arguments
        filename string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    if isfile(filename)
        delete(filename);
    end
end