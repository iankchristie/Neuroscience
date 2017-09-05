classdef Model
    %UNTITLED9 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        t
        dT
        steps
        elements
    end
    
    methods
        function obj = Model(varargin)
            
            obj.t = 0;
            obj.dT = .001;
            obj.steps = 500;
            
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
        
        function [time data] = run(obj)
            time = zeros(1,obj.steps);
            data = zeros(2,obj.steps);
            stepNum = 0;
            
            for k=obj.t:obj.dT:obj.t+(obj.steps*obj.dT)
                stepNum = stepNum+1;
                for i = 1:length(obj.elements),
                    nextState(obj.elements(i));
                end
                for i = 1:length(obj.elements)
                    step(obj.elements(i));
                    data(i,stepNum) = obj.elements(i).r;
                end
                time(stepNum) = k;
            end            
        end
    end
    
end

