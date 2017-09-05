function [performance, actvsclass,errormatrix] = noise_analysis2(standards,numrep)

straincov=[];
for k=1:length(standards)
    [strain thecov]=strain_cov(standards(k));
    straincov=cat(2,straincov,thecov); 
end
mycov=sum(straincov,2);
mycov=mycov/size(mycov,2);


noisystandards = standards([]); 
noisystandards = noisystandards([]);

for k=1:length(standards)
        noisecluster=noise_cluster_rev(standards(k),mycov,numrep);
        noisystandards(end+1) = noisecluster;
end

[performance,actvsclass,errormatrix]=check_classifier(standards, noisystandards,'classify_melt_curve');
h=probability_classification(actvsclass,standards,noisystandards);
