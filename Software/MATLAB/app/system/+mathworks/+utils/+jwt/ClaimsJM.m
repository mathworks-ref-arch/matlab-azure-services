classdef ClaimsJM < adx.control.JSONMapper
    % ClaimsJM JWT Claims that use JSON Mapper
    
    % Copyright 2023 The MathWorks, Inc.
    
    % Class properties
    properties
        iat int64 
        nbf int64
        exp int64
        xms_tcdt int64
    end
  
    % Class methods
    methods
        % Constructor
        function obj = ClaimsJM(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?mathworks.utils.jwt.ClaimsJM
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end
