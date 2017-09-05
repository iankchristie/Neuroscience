function [strain stddev]= strain_stdev(standard)
strain=standard.strain;
data=[];
for i=1:size(standard.data,2)
	data = [data ; standard.data{i}(2,:)]; % assumes 1-D
end

stddev = std(data);
