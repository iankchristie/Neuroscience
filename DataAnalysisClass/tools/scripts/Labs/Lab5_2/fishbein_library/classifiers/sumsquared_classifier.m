function [ bestmatch, error] = normalize_sumsquared_classifier( standards, new_curve )

% A classifier that first normalizes all data sets to be compared by
% dividing by the first value of the data set. Then proceeds to classify
% using the sum-squared method.

bestmatch=zeros(length(standards),1);
error=zeros(length(standards),1);
standardmeans = zeros(length(standards),size(standards(1).data{1},2));

for i=1:length(standards),
	[T,standardmeans(i,:)] = mean_standard(standards(i));
	standardmeans(i,:)=standardmeans(i,:)./standardmeans(i,1); % I moved this up here so it only gets done once
end

new_curve(2,:)=new_curve(2,:)./new_curve(2,1);

for i=1:length(standards)
        sumsqdif=sum((new_curve(2,:)-standardmeans(i,:)).^2);
        error(i)=sumsqdif;
end
[dummy, bestmatch] = min(error);
