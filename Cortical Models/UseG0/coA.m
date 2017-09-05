function [A, out] = coA(varargin)
%coA Allows for iteration of single variable in Diff6 model
%   
% Varibles:
% startVal = 0;
% endVal = 2;
% inc = .1;
% out = []; Non-alterable
% A = []; Non-alterable
% variable = 'A';
% ts = []; Non-alterable
% 
% plotIt = 1; boolean for plotting (0 if false, 1 if true)
% 
% plotStyle = 'max'; (styles of plot: 'max','all')

startVal = 0;
endVal = 2;
inc = .1;
out = [];
A = [];
variable = 'A';
ts = [];


plotIt = 1;

plotStyle = 'max';

c = {};

assign(varargin{:});

for j = startVal:inc:endVal
    A(end+1) = j;
    [t r o] = Diff6('input',1,variable,j,varargin{:},'plotIt',0);
    if plotStyle == 'max'
        out(end+1) = max(r);
    end
    if plotStyle == 'all'
        out = [out;r];
        ts = [ts;t];
    end
end

if plotIt
    if plotStyle == 'max'
        plot(A, out)
    end
    if plotStyle == 'all'
        [m n] = size(out);
        figure;
        plot(ts(1,:), out(1,:),'Color',[1 1/m 1/m])
        for k=2:m
            hold on
            plot(ts(k,:), out(k,:),'Color',[1 k/m k/m])
        end
    end
end

end

