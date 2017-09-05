classdef Input
    %UNTITLED7 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        const
    end
    
    methods
        function obj = Input(constInput, varargin)
            obj.const = constInput;
        end
        
        function out = ffi(obj,t)
            out = obj.const;
        end
    end
    
end

