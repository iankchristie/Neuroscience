classdef FeedForwardInput
    %UNTITLED7 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Tp
        A1
        A2
        B
        duration
    end
    
    methods
        function obj = FeedForwardInput(varargin)
            obj.Tp = .150;
            obj.A1 = -1;
            obj.A2 = 1;
            obj.B = -1;
            obj.duration = .300;
            
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
        
        function out = ffi(obj,t)
            if t >= 0 && t <= obj.Tp
                out = obj.A1*t+obj.B;
            elseif t > obj.Tp && t <= obj.duration
                out = obj.A2*(t - obj.Tp) + obj.Tp*obj.A1 + obj.B;
            else
                out = 0;
            end
        end
    end
    
end

