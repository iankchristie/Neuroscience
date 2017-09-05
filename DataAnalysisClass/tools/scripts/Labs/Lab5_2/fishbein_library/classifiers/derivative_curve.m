function [bestmatch,error] = derivative_curve(standards,mymeltcurve)
  % error and bestmatch need to be reversed, the check_classifer function expects bestmatch to be first argument, error to be second

error=zeros(length(standards),1);
dstandardmeans = zeros(length(standards),(size(standards(1).data{1},2))-1);

%dT=zeros(size(standards(1).data{1},2))-1;
dmymeltcurve=zeros(2,length(mymeltcurve)-1);

for i=1:length(standards),
    [T,standardmeans(i,:)] = mean_standard(standards(i));
    %dT(1,:)=diff(T(1,:));
    dstandardmeans(i,:)=diff(standardmeans(i,:));
end
%dmymeltcurve(1,:)=(mymeltcurve(1,1:end-1));  % don't want to differentiate the X variable!
dmymeltcurve=diff(mymeltcurve(2,:));

for i=1:length(standards)
        sumsqdif=sum((dmymeltcurve-dstandardmeans(i,:)).^2);
        error(i)=sumsqdif;
end
[dummy, bestmatch] = min(error);
