classdef oneCorticalModel < Model
    %UNTITLED8 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        neuron1
    end
    
    methods
        function obj = oneCorticalModel(varargin)
            
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
            
            obj.neuron1 = CorticalNeuron(varargin{:});
        end
        
        function [time data] = run(obj)
            time = 0;
            data = 0;
            
            for k=obj.t:obj.dT:obj.t+(obj.steps*obj.dT)
                nextState(obj.neuron1);
                step(obj.neuron1);
                data(end+1) = obj.neuron1.r;
                time(end+1) = k;
            end            
        end
            
    end
    
end

