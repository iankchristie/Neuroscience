
d = dir('/Users/ianchristie/Documents/MATLAB/Coupled-Pair/Data/ParFinderData');
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name};

nameFolds = nameFolds(3:end);

for i = 1: length(nameFolds),
    for j = 1: length(nameFolds),
        if i~=j,
            load([nameFolds{i} '/AllDS.mat']);
            temp1 = AllDS;
            load([nameFolds{j} '/AllUni1.mat']);
            temp2 = AllUni1;
            
            for k = 1: length(temp1),
                for l = 1: length(temp2),
                    if ((temp1{k}.Wr == temp2{l}.Wr) && (temp1{k}.W12 == temp2{l}.W12) && (temp1{k}.W21 == temp2{l}.W21)),
                        disp(nameFolds{i});
                        disp(nameFolds{j});
                        disp(temp1{k});
                        disp(temp1{l});
                    end
                end
            end
        end
    end
end