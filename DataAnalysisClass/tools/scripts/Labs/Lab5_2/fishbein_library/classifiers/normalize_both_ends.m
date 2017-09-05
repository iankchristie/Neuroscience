function [bestmatch,error] = normalize_both_ends(standards,mymeltcurve)
bestmatch=zeros(length(standards),1);
error=zeros(length(standards),1);
standardmeans = zeros(length(standards),size(standards(1).data{1},2));

for i=1:length(standards),
	[T,standardmeans(i,:)] = mean_standard(standards(i));
	standardmeans(i,:)=standardmeans(i,:)-standardmeans(i,1);
	standardmeans(i,:)=standardmeans(i,:)./standardmeans(i,end); % I moved this up here so it only gets done once
end

zerovaluecurve = [mymeltcurve(1,:) ; (mymeltcurve(2,:)-mymeltcurve(2,1))];
onevaluecurve= [zerovaluecurve(1,:); (zerovaluecurve(2,:)./zerovaluecurve(2,end))];

for i=1:length(standards)
        sumsqdif=sum((onevaluecurve(2,:)-standardmeans(i,:)).^2);
        error(i)=sumsqdif;
end
[dummy, bestmatch] = min(error);
