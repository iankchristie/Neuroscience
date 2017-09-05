function [output] = createConnection(preNeuron, synapse, postNeuron)
%UNTITLED16 Summary of this function goes here
%   Detailed explanation goes here

output = 0;

preNeuron.addPreSynapse(synapse);
synapse.addPre(preNeuron);
synapse.addPost(postNeuron);
postNeuron.addPostSynapse(synapse);


output = 1;

end

