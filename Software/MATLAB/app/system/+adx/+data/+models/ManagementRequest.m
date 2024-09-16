classdef ManagementRequest < adx.control.JSONMapper
    % ManagementRequest Defines a Request Object for a management query
    % If a database field is defined in the default configuration file
    % location its value will be used for the db property.

    % Copyright 2023-2024 The MathWorks, Inc.

    % Class properties
    properties
        csl string
        db string
        requestProperties adx.data.models.ClientRequestProperties { adx.control.JSONMapper.fieldName(requestProperties,"properties") }
    end

    % Class methods
    methods
        % Constructor
        function obj = ManagementRequest(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.data.models.ManagementRequest
            end
            obj@adx.control.JSONMapper(s,inputs);

            if isempty(obj.db) || strlength(obj.db) == 0
                cfg = mathworks.internal.adx.loadConfig();
                if isfield(cfg, 'database') && strlength(cfg.database) > 0
                    obj.db = cfg.database;
                end
            end
        end
    end %methods
end