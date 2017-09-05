function [noisestandard]= noise_cluster_rev(standard,stddev,numreplicates)
[T mean]=mean_standard(standard);
mynewdata={};

mynewfluor=[];
    for k=1:numreplicates
        mynewdata{k}=[];
        mynewfluor=mean+randn(size(standard.data{1}(1,:))).*stddev;
        mynewcurve=[standard.data{1}(1,:); mynewfluor];
        mynewdata{k}=[mynewdata{k};mynewcurve];
    end
noisestandard = standard;
noisestandard.data = mynewdata;
