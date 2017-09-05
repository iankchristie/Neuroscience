classdef SimpleSynapse < handle
    %UNTITLED15 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name = '';
        Pr = .5;
        D = 1;
        Vrev = 0;
        Gmax = 1;
        taus = .002;
        taud = .2;
        Pre
        Post
        s
    end
    
    methods
        function obj = SimpleSynapse(varargin)
            obj.name = '';
            obj.Pr = .5;
            obj.D = 1;
            obj.Vrev = 0;
            obj.Gmax = 0;
            
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
        
        function addPre(obj,pren)
            obj.Pre = pren;
        end
        
        function addPost(obj,postn)
            obj.Post = postn;
        end
        
        function step(obj,dT,s)
            obj.s = dT*(-obj.s/obj.taus);
            obj.D = dT*(1-obj.D/obj.taud);
        end
        
        function preSpike(obj)
            disp([obj.name 'called']);
            obj.s = obj.s + obj.Pr*obj.D*(1-obj.s);
            obj.D = obj.D*(1-obj.Pr);
        end
    end
    
end

