function [input] = randomUpDownInput(len, strong, weak, varargin)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

activeRange = round(4*len/5);
input = zeros(activeRange, 2);
padding = zeros(round(len/10), 2);

NullState = 1;
UpState = 2;
DownState = 3;

currentState = NullState;

Null2Up = 0.01;
Null2Down = 0.01;
Up2Null = 0.01;
Down2Null = 0.01;

NullInput = [0; 0];
UpInput = [strong; weak];
DownInput = [weak; strong];

for i = 1: activeRange,
    if(currentState == UpState),
        input(i, :) = UpInput;
        if(rand() <= Up2Null),
            currentState = NullState;
        end
    elseif(currentState == DownState),
        input(i, :) = DownInput;
        if(rand() <= Down2Null),
            currentState = NullState;
        end
    else
        input(i, :) = NullInput;
        prob = rand();
        if(prob <= Null2Up),
            currentState = UpState;
        end
        if(prob >= (1 - Null2Down)),
            currentState = DownState;
        end
    end
end

input = [padding; input; padding];

while length(input) < len,
    input(end, :) = [0; 0];
end

while length(input) > len,
    input = input(1:end-1, :);
end

%plot(input);

input = input';

end

