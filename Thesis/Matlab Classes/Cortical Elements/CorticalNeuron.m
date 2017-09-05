classdef CorticalNeuron < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name = '';
        initial = 0;
        r = 0;
        rReset = 0;
        next = 0;
        dT = .001;
        steps = 1000;
        tau = .004;
        t = 0;
        tReset = 0;
        At_t = .344;
        A=1;
        
        activationFunction
        feedForwardInput
        
        input
        
    end
    
    methods
        function obj = CorticalNeuron(varargin)
            obj.name = '';
            obj.initial = 0;
            obj.r = 0;
            obj.next = 0;
            obj.dT = .001;
            obj.steps = 1000;
            obj.tau = .004;
            obj.t = 0;
            obj.At_t = .344;
            obj.A=1;
            
            obj.activationFunction = SigmoidalActivationFunction('','');
            obj.feedForwardInput = FeedForwardInput('','');

            obj.input= {};
            
            vars = {varargin{1:2:end}};
            vals = {varargin{2:2:end}};
            
            fields = fieldnames(obj);
            
            for i = 1:length(vars),
                if ~isempty(intersect(vars{i},fields))
                    switch class(vals{i})
                        case 'char',
                            eval(['obj.' vars{i} '=''' vals{i} ''';']);
                        otherwise
                            eval(['obj.' vars{i} '= vals{i};']);
                    end
                end
            end
            
            obj.input{1,end+1} = obj;
            obj.input{2,end} = obj.At_t;
        end
        
        function nextState(obj)
            drive = 0;
            for k = 1:length(obj.input(1,:)),
                drive = obj.input{1,k}.r*obj.input{2,k} + drive;
            end
            temp = obj.A*obj.feedForwardInput.ffi(obj.t) - drive;
            %disp(temp);
            drive = obj.activationFunction.func(temp);
            
            obj.next = obj.dT*((-obj.r) + drive)/obj.tau;
        end
        
        function step(obj)
            obj.r = obj.r + obj.next;
            obj.t = obj.t + obj.dT;
        end
        
        function addInput(obj, potential, strength)
            tf = eq(obj,potential);
            %if tf == 1,
                obj.input{1,end+1} = potential;
                obj.input{2,end} = strength;
            %end
        end
        
        function setSelfWeight(obj, weight)
            obj.input{2,1} = weight;
        end
        
        function reset(obj)
            obj.r = obj.rReset;
            obj.t = obj.tReset;
        end
    end
    
end

