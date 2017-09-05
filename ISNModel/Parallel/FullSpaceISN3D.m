S = 2:20;
W = 1:19;

for i = 1: length(S),
    for j = 1: length(W),
        if S(i) > W(j),
            ISN3D115(S(i), W(j));
        end
    end
end