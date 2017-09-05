function [str]= probability_classification(actvsclass,standards_base, standards_test)
straincount=[];
strain={};
basecounter=0;
basevalue=[];
for i=1:length(standards_base)
    strain{i}=[];
    strain{i}=standards_base(i).strain;
    basevalue=find(actvsclass(:,1)==i);
    basecounter=length(basevalue);
    testcounter=0;
    for j=1:length(basevalue)
        if (actvsclass(basevalue(j),1)==actvsclass(basevalue(j),2))
            testcounter=testcounter+1;
        end
    end
    straincount=[straincount;basecounter,testcounter];
    testcounter=0;
end
for m=1:length(standards_base)
    str=fprintf('The probability that sample was %s and we said it was %s is: %0.5f \n',strain{m},strain{m},(straincount(m,2)/straincount(m,1)));
end
