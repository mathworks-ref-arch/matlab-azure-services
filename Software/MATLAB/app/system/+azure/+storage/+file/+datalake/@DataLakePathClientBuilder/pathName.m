function builder = pathName(obj, pathName)
% PATHNAME Sets the name of the file/directory
% If the path name contains special characters, pass in the url encoded version
% of the path name.
% An updated builder object is returned.

% Copyright 2022 The MathWorks, Inc.

if ~(ischar(pathName) || isStringScalar(pathName))
    logObj = Logger.getLogger();
    write(logObj,'error','Invalid pathName argument');
else
    builderj = obj.Handle.pathName(pathName);
    builder = azure.storage.file.datalake.DataLakePathClientBuilder(builderj);
end

end