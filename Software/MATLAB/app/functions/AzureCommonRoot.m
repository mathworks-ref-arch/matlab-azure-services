function [str] = AzureCommonRoot(varargin)
    % AZURECOMMONROOT Return Azure Services root location
    % Locate the installation of the Azure interface package to allow easier construction
    %
    % The special argument of a negative number will move up folders, e.g.
    % the following call will move up two folders, and then into
    % Documentation.
    %
    %  docDir = AzureCommonRoot(-2, 'Documentation')
    
    % Copyright 2020-2024 The MathWorks, Inc.
    
    str = fileparts(fileparts(fileparts(mfilename('fullpath'))));

    for k=1:nargin
        arg = varargin{k};
        if isstring(arg) || ischar(arg)
            str = fullfile(str, arg);
        elseif isnumeric(arg) && arg < 0
            for levels = 1:abs(arg)
                str = fileparts(str);
            end
        else
            error('Azure:AzureCommonRoot_bad_argument', 'Bad argument for AzureCommonRoot');
        end
    end
end %function
