function [m] = createColumn(varargin)

Wee = .8;
Wii = 0;
Wei = .4;
Wie = -.41;

m = getConnectionMatrix2('Wee', Wee,'Wii', Wii, 'Wei', Wei, 'Wie', Wie);


end

