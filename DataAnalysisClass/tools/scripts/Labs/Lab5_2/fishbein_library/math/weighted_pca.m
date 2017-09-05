function [standards pc themean]=weighted_pca(standards)
mn_list = [];
T = standards(1).data{1}(1,:);
for k=1:length(standards),
	[T,mnf] = mean_standard(standards(k));
	mn_list = [mn_list mnf'];  % might need to be [mn_list; mnf];
end;

[data,themean] = subtract_mean(mn_list);
  % data has the mean-subtracted value for each standard

Mtuberculosis=[];
Mbovis=[];
NTM=[];

i=1;
while i<=length(standards)
    if findstr('tuberculosis',lower(standards(i).strain))
        Mtuberculosis=cat(2,Mtuberculosis,data(:,i));
    elseif findstr('bovis', lower(standards(i).strain))
            Mbovis=cat(2,Mbovis,data(:,i));
    else
            NTM=cat(2,NTM,data(:,i));
    end
    i=i+1;
end

meantb=mean(Mtuberculosis,2);
meanbovis=mean(Mbovis,2);
meanNTM=mean(NTM,2);
badstuffmean=mean([Mtuberculosis Mbovis],2);
dim1=badstuffmean-meanNTM;
dim2=meantb-meanbovis;
pc=[dim1 dim2];
