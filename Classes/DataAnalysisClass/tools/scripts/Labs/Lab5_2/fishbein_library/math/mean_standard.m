function [T,mnf] = mean_standard(standard)
mnf=[];

% MEAN_STANDARD - Calculate the mean of a standard replicate set of melt curves
%
%   [T,MNF] = MEAN_STANDARD(STANDARD)
%
%  Calculates the mean of a set of standard replicates.
%
%  STANDARD is assumed to be a structure that has a field 'data' that
%  contains a cell list of melt curves that are size 2 X N, where the first
%  row represents the temperatures where measurements were taken and 
%  and the second row represents fluorescent measurement values.
%
%  T is the list of temperatures, and MNF is a list of the fluorescent means.
%

T = standard.data{1}(1,:);

mnf  = [];

for j=1:size(standard.data{1},1)-1, % loop over dimensions
	values = [];
	for i=1:length(standard.data), % looping over replicants
        	if ~all(T==standard.data{i}(1,:)), 
			error(['Temperatures of replicants are not all the same.']);
		end;
        	values=cat(1,values,standard.data{i}(j+1,:));
        end;
    end;
    mnf = cat(1,mnf,mean(values,1));
end


