function [result] = getSmallestMeanPeak( histograms )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

peaks = max(histograms);

sortedPeaks = sort(peaks);

topFivePeaks = sortedPeaks(1:5);

result = mean(topFivePeaks);

end

