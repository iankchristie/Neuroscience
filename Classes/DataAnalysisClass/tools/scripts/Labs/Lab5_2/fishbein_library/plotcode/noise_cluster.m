function [noisestandard]= noise_cluster(standard,stddev,numreplicates)
[T mean]=mean_standard(standard);

        for k=1:numreplicates
           mynewdata{k}=[];
           mynewfluor=mean+randn(size(standard.data{1}(1,:)))*stdev(2,1);
           mynewcurve=[standard.data{1}(1,:); mynewfluor];
           mynewdata{k}=[mynewdata{k};mynewcurve];
        end

noisestandard.strain = standard.strain;
noisestandard.plate = standard.plate;
noisestandard.mutation = standard.mutation;
noisestandard.data = mynewdata;