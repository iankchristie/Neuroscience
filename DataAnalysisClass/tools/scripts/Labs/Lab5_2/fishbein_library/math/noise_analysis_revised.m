function [standards, noisystandards, performance, actvsclass,errormatrix] = noise_analysis_revised(filename,numrep)

standards=read_standard_raw_data(filename);

interp_standards = modify_standards(standards,'interpolateNdim_meltcurve');
normalizestandards1 = modify_standards(interp_standards,'normalizeNdim_01');
normalizestandards2 = modify_standards(normalizestandards1,'normalizeNdim_by_lastvalue');
normalizestandards3 = modify_standards(normalizestandards2,'meltcurveNdim_2derivative');
finalnorm=modify_standards(normalizestandards3,'NDto1D');

standards = finalnorm;


strainstdev=[];
for k=1:length(standards)
    [strain stdev]=strain_stdev(standards(k));
    strainstdev=cat(2,strainstdev,stdev); 
end
stdev=sum(strainstdev,2);
stdev=stdev/size(strainstdev,2);


noisystandards = struct('strain','','plate','','replicate','','data','');
noisystandards = noisystandards([]);

for k=1:length(standards)
        noisecluster=noise_cluster_rev(standards(k),stdev,numrep);
        noisystandards(end+1) = noisecluster;
end

[performance,actvsclass,errormatrix]=check_classifier(standards, noisystandards,'classify_melt_curve');
h=probability_classification(actvsclass,standards,noisystandards);
