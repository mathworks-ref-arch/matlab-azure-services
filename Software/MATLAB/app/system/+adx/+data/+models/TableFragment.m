classdef TableFragment < adx.control.JSONMapper
% TableFragment A part of a returned table

% Copyright 2023 The MathWorks, Inc.

    % Class properties
    properties
        TableId double
        FieldCount double
        TableFragmentType adx.data.models.TableFragmentType
        Rows {adx.control.JSONMapper.JSONArray}
    end

    % Class methods
    methods
        % Constructor
        function obj = TableFragment(s,inputs)
            % To allow proper nesting of object, derived objects must
            % call the JSONMapper constructor from their constructor. This 
            % also allows objects to be instantiated with Name-Value pairs
            % as inputs to set properties to specified values.
            arguments
                s { adx.control.JSONMapper.ConstructorArgument } = []
                inputs.?adx.data.models.TableFragment
            end
            obj@adx.control.JSONMapper(s,inputs);
        end
    end %methods
end