classdef JSONMapperMap < handle 
    % JSONMAPPERMAP Alternative to containers.Map for free-form key-value
    % pairs. The advantage of JSONMAPPERMAP over containers.Map is that
    % instances are not shared when used as a class property.
    
    % Copyright 2022 The MathWorks, Inc.
    
    properties (Access=private)
        map containers.Map
    end
    
    methods
        function obj = JSONMapperMap(varargin)
            % JSONMAPPERMAP Constructor. Can be called with key value pairs
            % as input to initialize the map with those keys and values.

            % Create a new containers.Map internally in the constructor to
            % avoid shared instances of the inner map
            obj.map = containers.Map;

            if nargin > 0
                for i = 1:2:length(varargin)
                    obj.map(varargin{i}) = varargin{i+1};
                end
            end

        end

        function B = subsref(obj,S)
            % SUBSREF retrieve a key value from the map.

            % Simply call the same subsref operation on the inner
            % containers.Map
            B = subsref(obj.map,S);
        end
        function obj = subsasgn(obj,S,B)
            % SUBSASGN Assign or update a key-value pair in the map.

            % If used as a class property obj itself may in fact be an
            % empty 0x0, in that case first create the instance
            if isempty(obj)
                obj = adx.control.JSONMapperMap;
            end
            % Simply call the same subsasgn on the inner containers.Map
            obj.map = subsasgn(obj.map,S,B);
        end

        function out = jsonencode(obj,varargin)
            % JSONENCODE JSON encodes the map.

            % Call jsonencode on the inner containers.Map
            out = jsonencode(obj.map,varargin{:});
        end
        
        function disp(obj)
            % DISP Displays keys and corresponding values in the map.
            if isempty(obj)
                disp 'Empty adx.control.JSONMapperMap'
                return
            end
            fprintf('adx.control.JSONMapperMap with the following key-value pairs:\n\n');
            for k = obj.map.keys
                fprintf('\t%10s : %s\n',k{1},obj.map(k{1}));
            end
        end
    end
end

