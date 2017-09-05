classdef varyFieldsTwoModel
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        selfExc
        neighborExc
        input1
        input2
        twc
    end
    
    methods
        function obj=twoCorticalModel(cellArray1, cellArray2, varargin)
            obj.selfExc = 0;
            obj.neighborExc = 0;
            obj.input1 = 8;
            obj.input2 = 4;
            
            obj.twc = twoCorticalModel(cellArray1, cellArray2);
            obj.neuron1 = CorticalNeuron(cellArray1{:});
            obj.neuron2 = CorticalNeuron(cellArray2{:});
            
            vars = {varargin{1:2:end}};
            vals = {varargin{2:2:end}};
            
            fields = fieldnames(obj);
            
            for i = 1:length(vars),
                if ~isempty(intersect(vars{i},fields))
                    switch class(vals{i})
                        case 'char',
                            eval(['obj.' vars{i} '=''' vals{i} ''';']);
                        otherwise
                            %disp(['The value is ' mat2str(vals{i}) '.']);
                            t = ['obj.' vars{i} '= vals{i};'];
                            %disp(t);
                            eval(t);
                    end
                end
            end
            
            obj.twc.neuron1.A=8;
            
            obj.elements = [obj.neuron1 obj.neuron2];
        end
    end
    
end

