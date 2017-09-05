function [bestmatch, error]=classify_melt_curve_T(standards, new_curve)

 % impose a particular set of temperatures Ts = [25:65];
 % interpolate all values to be in this range using interp1
 % (see 'help interp1' to get information on this function)

if 0,
    Ts=[];
 m=24.5;
 j=1;                           % this will work but is slower
 while (m<69.5)&&(m>24)         %I wanted to define the temperature vector as from 25-69 with 0.5 degree intervals, like the machine.
    m=m+0.5;                    %Let me know if there's an easier way
     Ts(j)=m;
    j=j+1;
 end

end;

Ts = 24.5:0.5:69;                   % this is the easier way :-)   form is start:stepsize:stop

bestmatch=zeros(length(standards),1);
error=zeros(length(standards),1);
standardmeans = zeros(length(standards),size(standards(1).data{1},2));
standardmeans_mod=zeros(length(standards),size(Ts));
for i=1:length(standards),
	[T,standardmeans(i,:)] = mean_standard(standards(i));
	standardmeans_mod(i,:) = interp1(T,standardmeans(i,:),Ts,'linear');
end;

for i=1:length(standards)
    newcurve_interp = interp1(newcurve(1,:),newcurve(2,:),Ts); % don't forget to translate this to the same temperature base
    sumsqdif=sum((new_curve_interp-standardmeans_mod(i,:)).^2);
    error(i)=sumsqdif;
end
   
[mylowesterrorvalue, bestmatch] = min(error);
