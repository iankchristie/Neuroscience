function [result] = oscillates(array)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

result = 0;

E1 = array(1,:);
E2 = array(3,:);

b1 = E1(E1~=0);
b2 = E2(E2~=0);

b1Mean = mean(b1);
b2Mean = mean(b2);

countb1 = 0;
for i = 1: length(b1)-1,
    if b1(i) < b1Mean && b1(i+1) >= b1Mean,
        countb1 = countb1 + 1;
    end
end

countb2 = 0;
for i = 1: length(b2)-1,
    if b2(i) < b2Mean && b2(i+1) >= b2Mean,
        countb2 = countb2 + 1;
    end
end

result = (countb1 >= 3) || (countb2 >= 3);

end

