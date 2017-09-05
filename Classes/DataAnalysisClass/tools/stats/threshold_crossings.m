function [ index_values ] = threshold_crossings( input, threshold )
%THRESHOLD_CROSSINGS Detect thershold crossings in data
% 
%  INDEX_VALUES = THRESHOLD_CROSSINGS(INPUT, THRESHOLD)
%
%  Finds all places where the data INPUT crosses the threshold
%  THRESHOLD.  The index values where this occurs are returned in
%  INDEX_VALUES.
%

index_values = 1+find( input(1:end-1)<threshold & ...
         input(2:end) >= threshold);
end