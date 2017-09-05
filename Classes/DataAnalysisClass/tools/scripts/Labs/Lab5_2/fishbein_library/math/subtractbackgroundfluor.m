function newstandards=subtractbackgroundfluor(standards)
newstandards=standards;
meanmatrix1=[];
meanmatrix2=[];
fluor1=[];
fluor2=[];
for m=1:length(standards(end).data)
    meanmatrix1=[meanmatrix1;standards(end).data{m}(2,:)];
end
for m=1:length(standards(end).data)
    meanmatrix2=[meanmatrix2;standards(end).data{m}(3,:)];
end

fluor1=mean(meanmatrix1);
fluor2=mean(meanmatrix2);
for i=1:length(standards)
      for j=1:length(standards(i).data)
             newstandards(i),data{j}(2,:)=newstandards(i).data{j}(2,:)-fluor1;
             newstandards(i),data{j}(3,:)=newstandards(i).data{j}(3,:)-fluor2;
      end
end