function [data_meansubtracted,themean] = subtract_mean(data)

% SUBTRACT_MEAN - Subtract the mean of columns of data
%
%  DATA_MEANSUBTRACTED = SUBTRACT_MEAN(DATA)
%
%  Returns mean-subtracted data for columns of data.

[M,N] = size(data);
% subtract off the mean for each dimension
mn = mean(data,2);
data = data - repmat(mn,1,N);

data_meansubtracted = data;
themean = mn;

