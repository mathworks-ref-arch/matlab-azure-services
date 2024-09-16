
function tf = buildAdxControlPlaneClient(options)
    %BUILDADXCONTROLPLANECLIENT builds an Azure Data Explorer Control Plane

    % (c) 2023-2024 The MathWorks Inc.";

    arguments
        % Kusto spec url, repo: https://github.com/Azure/azure-rest-api-specs/tree/main/specification/azure-kusto/
        %options.inputSpec string {mustBeTextScalar} = "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/main/specification/azure-kusto/resource-manager/Microsoft.Kusto/stable/2023-05-02/kusto.json";
        options.inputSpec string {mustBeTextScalar} = fullfile(char(java.lang.System.getProperty('user.home')), 'git', "azure-rest-api-specs", "specification", "azure-kusto", "resource-manager", "Microsoft.Kusto", "stable", "2023-05-02", "kusto.json");
        % Assumes OpenAPI Code in $HOME/git/openapicodegen
        options.codegenPath string {mustBeTextScalar} = fullfile(char(java.lang.System.getProperty('user.home')), 'git', 'openapicodegen');
        % Directory where the autorest command can be found
        options.autorestPath string {mustBeTextScalar} = fullfile(char(java.lang.System.getProperty('user.home')), ".nvm", "versions", "node", "v16.15.1", "bin");
        % Directory where the npx command can be found
        options.npxPath string {mustBeTextScalar} = fullfile(char(java.lang.System.getProperty('user.home')), ".nvm", "versions", "node", "v16.15.1", "bin");
        % Directory where the node command can be found
        options.nodePath string {mustBeTextScalar} = fullfile(char(java.lang.System.getProperty('user.home')), ".nvm", "versions", "node", "v16.15.1", "bin");
    end

    % If startup has been run the in the Software/MATLAB dir can skip this
    if ~(exist('adxRoot.m', 'file') == 2)
        rootStr = fileparts(fileparts(fileparts(mfilename('fullpath'))));
        adxStartup = fullfile(rootStr, 'Software', 'MATLAB', 'startup.m');
        if isfile(adxStartup)
            run(adxStartup);
        else
            error('ADX:buildAdxControlPlaneClient', 'Azure Data Explorer startup.m not found: %s', adxStartup);
        end
    end

    % Run startup to configure the package's MATLAB paths
    codegenStartup = fullfile(options.codegenPath, 'Software', 'MATLAB', 'startup.m');
    if isfile(codegenStartup)
        run(codegenStartup);
    else
        error('ADX:buildAdxControlPlaneClient', 'OpenAPI code generation startup.m not found: %s', codegenStartup);
    end

    % Don't error if autorest itself is included in the path
    if endsWith(options.autorestPath, 'autorest')
        autorestCmd = options.autorestPath;
    else
        autorestCmd = fullfile(options.autorestPath, 'autorest');
    end
    [status,cmdout] = system(autorestCmd + " --version");
    if status ~= 0 || ~startsWith(cmdout, "AutoRest code generation utility [cli version: ")
        error('ADX:buildAdxControlPlaneClient', 'autorest not found: %s', autorestCmd);
    end

    % npx autorest --output-converted-oai3 --input-file=/home/<homedir>/git/azure-rest-api-specs/specification/machinelearning/resource-manager/Microsoft.MachineLearning/stable/2019-10-01/workspaces.json
    % localKusto2 = websave('kusto2.json', options.specURL);
    %% TODO review running in azure-rest-api-specs/specification/azure-kusto/resource-manager
    if ~isfile(options.inputSpec)
        error('ADX:buildAdxControlPlaneClient', 'Input spec not found: %s', options.inputSpec);
    end

    convCmd = autorestCmd + " --output-converted-oai3 --input-file=" + options.inputSpec;
    [status, cmdout] = system(convCmd);
    if status ~= 0
        error('ADX:buildAdxControlPlaneClient', 'autorest conversion failed:\n%s\n', cmdout);
    end
    % Expected generated spec
    
    specStrFields = split(string(options.inputSpec), filesep);
    dateField = specStrFields(end-1);
    specV3 = fullfile(pwd, "generated", "azure-kusto", "resource-manager", "Microsoft.Kusto", "stable", dateField, "kusto.json");
    if ~isfile(specV3)
        error('ADX:buildAdxControlPlaneClient', 'Expected converted v3.x spec file not found: %s', specV3);
    end

    % Create a builder object
    c = openapi.build.Client;
    % Set the package name, defaults to "OpenAPIClient"
    c.packageName = "control";
    % Set the path to the spec., this may also be a HTTP URL
    c.inputSpec = specV3;
    % Set a directory where the results will be stored
    c.output = fullfile(pwd, "adxClient");
    % Pass a string containing some additional arguments to the openapi-generator-cli
    c.skipValidateSpec = true;
    % Insert a copyright notice in generated code
    c.copyrightNotice = "% (c) 2023 MathWorks Inc.";
    % set the npx & node paths
    c.npxPath = options.npxPath;
    c.nodePath = options.nodePath;
    % Trigger the build process
    c.build;

    controlSrc = fullfile(c.output, "+" + c.packageName);
    apiSrc = fullfile(controlSrc, "+api");
    if ~isfolder(apiSrc)
        error('ADX:buildAdxControlPlaneClient', 'Expected api folder not found: %s', apiSrc);
    end
    modelSrc = fullfile(controlSrc, "+models");
    if ~isfolder(modelSrc)
        error('ADX:buildAdxControlPlaneClient', 'Expected models folder not found: %s', modelSrc);
    end

    dst = mathworks.adx.adxRoot("app", "system", "+adx", "+control");
    [status, msg] = mkdir(dst);
    if status ~= 1
        error('ADX:buildAdxControlPlaneClient', 'mkdir failed: %s\n%s', dst, msg);
    end

    apiDst = fullfile(dst, "+api");
    [status, msg] = copyfile(apiSrc, apiDst);
    if status ~= 1
        error('ADX:buildAdxControlPlaneClient', '+api copyfile failed, source: %s destination:%s\n%s', apiSrc, apiDst, msg);
    end
    modelsDst = fullfile(dst, "+models");
    [status, msg] = copyfile(modelSrc, modelsDst);
    if status ~= 1
        error('ADX:buildAdxControlPlaneClient', '+api copyfile failed, source: %s destination:%s\n%s', modelSrc, modelsDst, msg);
    end
    
    miscList = dir(controlSrc + filesep +"*.m");
    for n = 1:numel(miscList)
        src = fullfile(miscList(n).folder, miscList(n).name);
        [status, msg] = copyfile(src, dst);
        if status ~= 1
            error('ADX:buildAdxControlPlaneClient', '.m copyfile failed, source: %s, destination: %s\n%s', src, dst, msg);
        end
    end
    tf = true;
end