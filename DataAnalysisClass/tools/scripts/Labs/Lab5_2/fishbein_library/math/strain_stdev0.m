function [strain avgstdev]= strain_stdev(standard)
stdevtotal=0;
    [T mean]=mean_standard(standard);
    errorw=[];
    stdev=[];
    stdevtotal=zeros(size(mean,1),length(standard.data));
     for i=1:length(standard.data)   
        for j=1:size(mean,1)
            errorw =sum((standard.data{i}(j+1,:)-mean(j)).^2)/length(standard.data{i}(1,:));
            stdev=sqrt(errorw);
            stdevtotal(j,i)=stdev;
        end
     end
    for j=1:size(mean,1)    
        avgstdev=sum(stdevtotal,2)/(size(standard.data,2));
        strain=standard.strain;
    end