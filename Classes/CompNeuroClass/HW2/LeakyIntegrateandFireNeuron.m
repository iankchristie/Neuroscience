classdef LeakyIntegrateandFireNeuron < handle
    
    
    properties
        name = '';
        C = 5E-9;
        El = -.070;         %Leak Potential (-.070 V)
        Rm = 20E6;          %Membrane Resistance (12e6 ohms)
        taum = .015;        %Membrane Time Constant (.015 sec)

        Vth = -.055;        %Threshold potential (-0.50 V)
        Vreset = -.075;     %Reset potential (-0.065 V)
        Vspike = .030;      %Spike potential (0.030 V)

        Vm = -.070;            %Initially set membrane potential to leak potential
        
        sigma = 0;
        
        PostSynapses = [];
        PreSynapses = [];
        output = [];
    end
    
    methods
        function obj = LeakyIntegrateandFireNeuron(varargin)
            obj.name = '';
            obj.C = 5E-9;
            obj.El = -.070;         %Leak Potential (-.070 V)
            obj.Rm = 12E6;          %Membrane Resistance (12e6 ohms)
            obj.taum = .015;        %Membrane Time Constant (.015 sec)

            obj.Vth = -.050;        %Threshold potential (-0.50 V)
            obj.Vreset = -.065;     %Reset potential (-0.065 V)
            obj.Vspike = .030;      %Spike potential (0.030 V)

            obj.Vm = -.070;            %Initially set membrane potential to leak potential
            
            obj.PostSynapses = [];
            obj.PreSynapses = [];
            obj.output = [];
            
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
            
        end
        
        function addPreSynapse(obj, syn)
            obj.PreSynapses = [obj.PreSynapses syn];
        end
        
        function addPostSynapse(obj, syn)
            obj.PostSynapses = [obj.PostSynapses syn];
        end
        
        function step(obj,current,dT,s)
            if obj.Vm >= obj.Vspike         %Check to see if just spiked
                obj.Vm = obj.Vreset;        %Reset to reset potential if true
                for i = 1: length(obj.PreSynapses)
                    obj.PreSynapses.preSpike();
                end
                disp([obj.name 'fired']);
            end
            %Calculate synaptic input
            g = 0;
            for i=1: length(obj.PostSynapses)
                g = g + obj.PostSynapses(i).Gmax*obj.PostSynapses(i).s*(obj.PostSynapses(i).Vrev - obj.Vm);
            end
            %Calculate next voltage
            obj.Vm = obj.Vm + dT*((obj.El-obj.Vm)/obj.Rm)+g+current+(obj.sigma*randn(1)/dT)/obj.C;
            
            %Add noise
            if obj.Vm >= obj.Vth            %Check to see if spiking
                obj.Vm = obj.Vspike;        %We're Spiking!!! Set to Spike Potential
            end
            disp(obj.Vm);
            disp(obj.output);
            obj.output(s) = obj.Vm;
        end 
        
        
    end
    
end

