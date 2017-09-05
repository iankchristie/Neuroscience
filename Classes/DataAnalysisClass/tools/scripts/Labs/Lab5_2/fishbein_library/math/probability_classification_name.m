function [str]= probability_classification_names(actvsclass,standards_base, standards_test)
straincount=[];
nostraincount = [];
strain={};
basecounter=0;
basevalue=[];
for i=1:length(standards_base)
    strain{i}=[];
    strain{i}=standards_base(i).strain;
    basevalue = [];
    for j=1:size(actvsclass,1),
	if strcmp(actvsclass{j,1},strain{i}), basevalue(end+1) = j; end;
    end;
    basecounter=length(basevalue);
    testcounter=0;
    for j=1:length(basevalue)
        if strcmp(actvsclass{basevalue(j),1},actvsclass{basevalue(j),2})
            testcounter=testcounter+1;
        end
    end
    straincount=[straincount;basecounter,testcounter];

    notestcounter = 0;
    % now count number of times we say it was standards_base(i) but it really wasn't
    nobasevalue = [];
    for j=1:size(actvsclass,1),
	if ~strcmp(actvsclass{j,1},strain{i}), nobasevalue(end+1) = j; end;
    end;
    nobasecounter = length(nobasevalue);
    for j=1:length(nobasevalue)
        if strcmp(strain{i},actvsclass{nobasevalue(j),2})
            notestcounter=notestcounter+1;
        end
    end
    nostraincount = [nostraincount; nobasecounter, notestcounter];
end



for m=1:length(standards_base)
    fprintf('------------------------------------\n');
    str=fprintf('The probability that sample was %s and we said it was %s is: %0.5f \n',strain{m},strain{m},(straincount(m,2)/straincount(m,1)));
    str=fprintf('The probability that sample was %s and we said it was NOT is: %0.5f \n',strain{m},1-(straincount(m,2)/straincount(m,1)));
    str=fprintf('The probability that sample was NOT %s and we said it was %s is: %0.5f \n',strain{m},strain{m}, (nostraincount(m,2)/nostraincount(m,1)));
end
