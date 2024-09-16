function rootStr = adxRoot(varargin)
    % adxRoot Function to return the root folder for the ADX interface
    %
    % ADXRoot alone will return the root for the MATLAB code in the
    % project.
    %
    % ADXRoot with additional arguments will add these to the path
    % 
    %  funDir = mathworks.adx.adxRoot('app', 'functions')
    %
    %  The special argument of a negative number will move up folders, e.g.
    %  the following call will move up two folders, and then into
    %  Documentation.
    %
    %  docDir = mathworks.adx.adxRoot(-2, 'Documentation')

    % Copyright 2022-2023 The MathWorks, Inc.
    
    rootStr = fileparts(fileparts(fileparts(fileparts(fileparts(mfilename('fullpath'))))));

    for k=1:nargin
        arg = varargin{k};
        if isstring(arg) || ischar(arg)
            rootStr = fullfile(rootStr, arg);
        elseif isnumeric(arg) && arg < 0
            for levels = 1:abs(arg)
                rootStr = fileparts(rootStr);
            end
        else
            error('ADX:adxRoot_bad_argument', ...
                'Bad argument for adxRoot');
        end
    end
end %function
