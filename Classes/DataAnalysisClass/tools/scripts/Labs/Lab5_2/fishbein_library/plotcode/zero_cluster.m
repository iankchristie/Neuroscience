function [standards]=zero_cluster(standards)

avgstddev = [];

for i=1:length(standards),
	[dummyT,mymean]=mean_standard(standards(i));
	stdevtotal = 0 * mymean;
	for j=1:size(standards(i).data,2)
		errorw =sum((standards(i).data{j}(2,:)-mymean).^2)/length(standards(i).data{j}(1,:));
		stdev=sqrt(errorw);
		stdevtotal=stdevtotal+stdev;
	end
    	avgstddev = cat(1,avgstddev,stdevtotal/size(standards(i).data,2));
end;

avgstddev = mean(avgstddev,1);

mynewdata={};
for k=1:size(standards(1).data,2)
	mynewdata{k}=[];
	mynewfluor=zeros(size(standards(1).data{k}(1,:)))+randn(size(standards(1).data{k}(1,:)))*mean(avgstddev(:));
	mynewcurve=[standards(1).data{k}(1,:); mynewfluor];
	mynewdata{k}=[mynewdata{k};mynewcurve];
end

mynewstructure.strain = 'Nothing';
mynewstructure.plate = standards(1).plate;
mynewstructure.mutation = 'Nothing';
mynewstructure.data = mynewdata;
standards(end+1)=mynewstructure;
