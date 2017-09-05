
function [bestmatch, sumerror]=classify_melt_curve(standards, new_curve)

bestmatch=zeros(length(standards),1);
error=zeros(length(standards),size(new_curve,1)-1);
standardmeans = {};

for i=1:length(standards),  % calculates the mean of all standard elements
	standardmeans{i}=[];
	[T,standardmeans{i}] = mean_standard(standards(i));
end

for j=1:(size(new_curve,1)-1)
    for i=1:length(standards)
        sumsqdif=sum((new_curve(j+1,:)-standardmeans{i}(j,:)).^2);
        error(i,j)=sumsqdif;
    end
end

sumerror=sum(error,2);
[mylowesterrorvalue, bestmatch] = min(sumerror);

  
