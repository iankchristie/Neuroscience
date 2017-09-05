function [actvsclass,errormatrix,noisystandards] = noise_analysis3(standards,numrep, usetotalstd)

strainstdev=[];
for k=1:length(standards)
    [strain stdev]=strain_stdev(standards(k));
    strainstdev=cat(2,strainstdev,stdev); 
end
stdev=sum(strainstdev,2);
stdev=stdev/size(strainstdev,2);

noisystandards = standards([]);

for k=1:length(standards)
	if usetotalstd,
		mystddev = stdev;
	else,
		[dummy, mystdev] = strain_stdev(standards(k));
	end;
        noisecluster=noise_cluster_rev(standards(k),stdev,numrep);
        noisystandards(end+1) = noisecluster;
end

[actvsclass,errormatrix]=check_classifier_name(standards, noisystandards,'classify_melt_curve');
h=probability_classification_name(actvsclass,standards,noisystandards);


