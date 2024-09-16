function buildSettingsFile(options)
    % buildSettingsFile Gets user input for JSON settings file fields
    % Template files can be found in <package directory>/Software/MATLAB/config
    %
    % Optional argument
    %   filename: Filename to store settings, default is <package directory>/Software/MATLAB/config/adx.Client.Settings.json>

    % (c) 2023 MathWorks Inc.

    arguments
        options.filename string {mustBeTextScalar, mustBeNonzeroLengthText} = mathworks.adx.adxRoot("config", "adx.Client.Settings.json")
    end

    authMethodsShort = ["clientSecret", "deviceCode", "interactiveBrowser"];
    authMethodsLong = ["Client Secret", "Device Code", "Interactive Browser"];

    fprintf("\n");
    disp("Enter configuration and authentication settings");
    disp("===============================================");
    fprintf("\n");

    if ~overwrite(options.filename)
        disp("Exiting");
        return;
    end

    s = struct;
    s.preferredAuthMethod = getAuth(authMethodsShort, authMethodsLong);
    settingsFields = getTemplateFields(s.preferredAuthMethod);

    for n = 1:numel(settingsFields)
        if ~strcmp(settingsFields{n}, "preferredAuthMethod")
            s.(settingsFields{n}) = getField(settingsFields{n});
        end
    end

    writeSettingsFile(s, options.filename)
    disp("Configuration complete");
    disp(["  As a simple test run: [result, success] = mathworks.adx.run('print mycol=""Hello World""') ", newline])
end


function writeSettingsFile(s, filename)
    fid = fopen(filename, 'w');
    if fid == -1
        error("adx:buildSettingsFile", "Error writing to file: %s", filename);
    end
    closeAfter = onCleanup(@() fclose(fid));
    fprintf(fid, "%s", jsonencode(s, PrettyPrint=true));
    fprintf("Settings written to: %s\n", filename);
end


function value = getField(fieldname)
    switch fieldname
        case "subscriptionId"
            value = getSubscriptionId();
        case "tenantId"
            value = getTenantId();
        case "clientId"
            value = getClientId();
        case "clientSecret"
            value = getClientSecret();
        case "database"
            value = getDatabase();
        case "resourceGroup"
            value = getResourceGroup();
        case "cluster"
            value = getCluster();
        case "preferredAuthMethod"
            error("adx:buildSettingsFile", "Should not request authentication method at this point");

        otherwise
            fprintf("Unknown field name: %s, skipping\n", fieldname)
    end
end


function value = getCluster()
    value = strip(input('Enter a default Azure Data Explorer database URL, e.g. https://mycluster.myregion.kusto.windows.net: ', 's'));
end


function value = getResourceGroup()
    value = strip(input('Enter Azure resource group: ', 's'));
end


function value = getDatabase()
    value = strip(input('Enter a default Azure Data Explorer database name: ', 's'));
end


function value = getClientSecret()
    value = strip(input('Enter Azure Data Explorer Client Secret: ', 's'));
end


function value = getClientId()
    value = strip(input('Enter Azure Data Explorer Client/App Id: ', 's'));
end


function value = getTenantId()
    value = strip(input('Enter Azure Tenant Id: ', 's'));
end


function value = getSubscriptionId()
    value = strip(input('Enter Azure Subscription Id: ', 's'));
end


function settingsFields = getTemplateFields(authMethod)
    basePath = mathworks.adx.adxRoot("config", "adx.Client.Settings.json");
    fullPath = strcat(basePath, ".", string(authMethod), "Template");
    if ~isfile(fullPath)
        error("adx:buildSettingsFile", "Settings template file not found: %s", fullPath);
    end
    s = jsondecode(fileread(fullPath));
    settingsFields = fieldnames(s); 
end


function auth = getAuth(authMethodsShort, authMethodsLong)
    arguments
        authMethodsShort (1,:) string {mustBeNonzeroLengthText}
        authMethodsLong (1,:) string {mustBeNonzeroLengthText}
    end

    if numel(authMethodsShort) ~= numel(authMethodsLong)
        error("adx:buildSettingsFile", "Expected size of authMethodsShort and authMethodsLong to match");
    end

    disp("Enter the preferred authentication method");
    authPath = mathworks.adx.adxRoot(-2, "Documentation", "Authentication.md");
    if ~isfile(authPath)
        warning("adx:buildSettingsFile", "Authentication.md file not found: %s", authPath);
    else
        authLink = sprintf('<a href="matlab: edit(''%s'')">%s</a>', authPath, authPath);
        fprintf('For more details, ctrl-c and see: %s\n', authLink);
    end
    fprintf("The following authentication modes are supported:\n\n");
    for n = 1:numel(authMethodsShort)
        fprintf("%d. %s (%s)\n", n, authMethodsLong(n), authMethodsShort(n));
    end

    inpStr = sprintf("\nEnter authentication method number [1-%d]: ", numel(authMethodsShort));
    authIdx = str2double(strip(input(inpStr,'s')));
    if authIdx < 1 || authIdx > numel(authMethodsShort)
        error("adx:buildSettingsFile", "Invalid authentication method number: %s", authIdx);
    end
    auth = authMethodsShort(authIdx);
end


function tf = overwrite(filename)
    if isfile(filename)
        fprintf("Found an existing settings file: %s\n", filename)
        userInput = strip(input('Overwrite it with new values Y/[N]: ', 's'));
        tf = strcmpi(userInput, 'y');
    else
        tf = true;
    end
end