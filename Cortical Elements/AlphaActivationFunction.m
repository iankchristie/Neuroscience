classdef AlphaActivationFunction
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        alpha
    end
    
    methods
        function obj = AlphaActivationFunction(varargin)
            obj.alpha = 1.5;
            
            vars = {varargin{1:2:end}};
            vals = {varargin{2:2:end}};
            
            fields = fieldnames(obj);
            
            for i = 1:length(vars),
                if ~isempty(intersect(vars{i},fields))
                    switch class(vals{i})
                        case 'char',
                            eval(['obj.' vars{i} '=''' vals{i} ''';']);
                        otherwise
                            eval(['obj.' vars{i} '=' vals{i} ';']);
                    end
                end
            end
        end
        
        function out = func(obj, x)
            out = rectify(-x)^obj.alpha;
        end
        
        function out = test(obj, x1, x2, dx)
            xVector = x1:dx:x2;
            out = zeros(1,length(xVector));
            for i = 1:length(xVector)
                out(i) = obj.func(xVector(i));
            end
        end
    end
    
end

