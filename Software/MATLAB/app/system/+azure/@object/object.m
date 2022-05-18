classdef object < dynamicprops
    % OBJECT Root Class for all Azure wrapper objects
    
    % Copyright 2016-2022 The MathWorks, Inc.
    
    properties (Constant, Access=private)
        systemProperties = azure.object.setSystemProperties
    end

    properties (Hidden)
        Handle;
    end
    
    methods
        %% Constructor
        function obj = object(~, varargin)
            % logObj = Logger.getLogger();
            % write(logObj,'debug','Creating root object');
        end
    end

    methods (Static, Access=private)
        function v = setSystemProperties

            v = true;
        end
    end
    
end %class
