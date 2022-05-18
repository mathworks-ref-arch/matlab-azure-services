function startup(varargin)
% STARTUP Script to add paths to the MATLAB path
% This script will add the paths below the root directory into the MATLAB
% path.

% Copyright 2021-2022 The MathWorks

% If deployed in a .ctf or .exe do not do anything in startup.m & return
if isdeployed()
    return;
end

p = inputParser;
p.addParameter('useStatic', true, @islogical);
p.parse(varargin{:});
useStatic = p.Results.useStatic;

displayBanner('Adding Azure Paths');

azCommonJar = 'azure-common-sdk-0.2.0.jar';

% Set up the paths to add to the MATLAB path
% This should be the only section of the code that you need to modify
% The second argument specifies whether the given directory should be
% scanned recursively
commonMATLABDir = fileparts(mfilename('fullpath'));
commonRoot = fileparts(fileparts(commonMATLABDir));
if ~exist(commonRoot, 'dir')
    % Cannot find the dependencies
    error('Azure:Services', 'Could not find matlab-azure-common directory: %s', commonRoot);
end
commonDirs = {fullfile(commonRoot, 'Software', 'MATLAB', 'app'),true;...
    fullfile(commonRoot, 'Software', 'MATLAB', 'lib'),false;...
    fullfile(commonRoot, 'Software', 'MATLAB', 'config'),false;...
    fullfile(commonRoot, 'Software', 'Utilities'),false;...
};
addFilteredFolders(commonDirs);

if useStatic
    disp('Checking for matlab-azure-common jar on static javaclasspath');
    staticPath = javaclasspath('-static');
    azCommonJarPath = fullfile(commonRoot, 'Software', 'MATLAB', 'lib', 'jar', azCommonJar);
    if ~any(contains(staticPath, azCommonJarPath, 'IgnoreCase', true))
        error('Azure:Services', '%s not found in static class path: %s', azCommonJar, azCommonJarPath);
    end
else
    % Check if the JAR file exists
    commonJarPath = fullfile(commonRoot,'Software','MATLAB','lib','jar',char(azCommonJar)); 
    if exist(commonJarPath,'file')
        iSafeAddToJavaPath(commonJarPath);
    else
        error('Azure:Services', 'Could not find jar file, see documentation for instructions on building the file using Maven: %s', commonJarPath);
    end
end

disp('Ready');
end

function addFilteredFolders(rootDirs)
% Helper function to add all folders to the path
% Loop through the paths and add the necessary subdirectories to the MATLAB path
for pCount = 1:size(rootDirs,1)
    
    rootDir=rootDirs{pCount,1};
    if rootDirs{pCount,2}
        % recursively add all paths
        rawPath=genpath(rootDir);
        
        if ~isempty(rawPath)
            rawPathCell=textscan(rawPath,'%s','delimiter',pathsep);
            rawPathCell=rawPathCell{1};
        end
        
    else
        % Add only that particular directory
        rawPath = rootDir;
        rawPathCell = {rawPath};
    end
    
    % if rawPath is empty then we have an entry in rootDir that does not
    % exist on the path so we should not try to add an entry for them
    if ~isempty(rawPath)
        % remove undesired paths
        svnFilteredPath=strfind(rawPathCell,'.svn');
        gitFilteredPath=strfind(rawPathCell,'.git');
        slprjFilteredPath=strfind(rawPathCell,'slprj');
        sfprjFilteredPath=strfind(rawPathCell,'sfprj');
        rtwFilteredPath=strfind(rawPathCell,'_ert_rtw');
        
        % loop through path and remove all the .svn entries
        if ~isempty(svnFilteredPath)
            for pCount=1:length(svnFilteredPath) %#ok<FXSET>
                filterCheck=[svnFilteredPath{pCount},...
                    gitFilteredPath{pCount},...
                    slprjFilteredPath{pCount},...
                    sfprjFilteredPath{pCount},...
                    rtwFilteredPath{pCount}];
                if isempty(filterCheck)
                    iSafeAddToPath(rawPathCell{pCount});
                else
                    % ignore
                end
            end
        else
            iSafeAddToPath(rawPathCell{pCount});
        end
    end
end
end


function iSafeAddToPath(pathStr)
% Helper function to add to MATLAB path.
% Add to path if the file exists
if exist(pathStr,'dir')
    disp(['Adding ',pathStr]);
    addpath(pathStr);
else
    disp(['Skipping ',pathStr]);
end
end


function iSafeAddToJavaPath(pathStr) 
% Helper function to add to the Dynamic Java classpath
% Check the current java path
jPaths = javaclasspath('-dynamic');

% Add to path if the file exists
if exist(pathStr,'dir')||exist(pathStr,'file')
    jarFound = any(strcmpi(pathStr, jPaths));
    if ~isempty(jarFound)
        disp(['Adding: ',pathStr]);
        javaaddpath(pathStr);
    else
        disp(['Skipping: ',pathStr]);
    end
else
    disp(['Skipping: ',pathStr]);
end
end


function displayBanner(appStr)
% Helper function to create a banner
disp(appStr);
disp(repmat('-',1,numel(appStr)));
end
