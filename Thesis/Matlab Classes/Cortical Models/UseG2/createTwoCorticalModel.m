function [model] = createTwoCorticalModel(connection_Matrix, neuron1, neuron2)
%createModel takes 
%   Detailed explanation goes here

neuron1.setSelfWeight(connection_Matrix(1,1));
neuron2.setSelfWeight(connection_Matrix(2,2));

neuron1.input{2,2} = connection_Matrix(2,1);        
neuron2.input{2,2} = connection_Matrix(1,2);

model = [neuron1 neuron2];

end

