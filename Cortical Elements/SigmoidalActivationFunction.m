classdef SigmoidalActivationFunction
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        alpha
        beta
        gamma
        x0
    end
    
    methods
        function obj = SigmoidalActivationFunction(varargin)
            obj.alpha = 100;
            obj.beta = .15;
            obj.gamma = 1.984;
            obj.x0 = 26;
            
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
            out = (obj.alpha / (1+exp(obj.beta*(x + obj.x0)))) - obj.gamma;
        end
    end
    
end

