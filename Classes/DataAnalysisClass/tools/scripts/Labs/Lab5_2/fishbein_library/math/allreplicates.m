function [V,names] = allreplicates(standards)
% ALLREPLICATES - Return all replicates
%
%   [V,names] = ALLREPLICATES(STANDARDS)
%
%   Returns all replicates in order, along with the name of the strain of
%   each replicate.
%

V = [];
names = {};

for i=1:length(standards),
	for k=1:size(standards(i).data,2),
		V = [V ; standards(i).data{k}(2,:);]; % 1d for now
		names{end+1} = standards(i).strain;
	end;
end;
