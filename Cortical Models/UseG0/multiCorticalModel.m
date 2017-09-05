classdef multiCorticalModel < Model
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        numNeurons
        params
    end
    
    methods
        function obj=multiCorticalModel(varargin)
            obj.numNeurons = 0;
            obj.params = {};
            vars = {varargin{1:2:end}};
            vals = {varargin{2:2:end}};
            
            fields = fieldnames(obj);
            
            for i = 1:length(vars),
                if ~isempty(intersect(vars{i},fields))
                    switch class(vals{i})
                        case 'char',
                            eval(['obj.' vars{i} '=''' vals{i} ''';']);
                        otherwise
                            disp(vals{i});
                            t = ['obj.' vars{i} '=' vals{i} ';'];
                            disp(t);
                            eval(t);val(['obj.' vars{i} '=' vals{i} ';']);
                    end
                end
            end
            
            for i = 1: obj.numNuerons+1
                tempNeuron = CorticalNueron(obj.params{i});
                obj.elements(i) = tempNeuron;
            end
            
            for i = 1: length(obj.elements)
                for k = 1: length(obj.elements)
                    obj.elements(i).addInput(obj.elements(k), .344);
                end
            end
        end
    end
    
end

