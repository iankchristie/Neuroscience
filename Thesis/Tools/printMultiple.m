start = 1;
if length(actual) > 50
    finish = 50;
else
    finish = length(actual);
end

strong = 7;
weak = 6;

for i = start: finish,
    Wee = actual{i}.Wee;
    Wii = actual{i}.Wii;
    Wei = actual{i}.Wei;
    Wie = actual{i}.Wie;
    Wxe1 = actual{i}.Wxe1;
    Wxe2 = actual{i}.Wxe2;
    Wxi1 = actual{i}.Wxi1;
    Wxi2 = actual{i}.Wxi2;
    
    runParams(Wee, Wii, Wei, Wie, Wxe1, Wxe2, Wxi1, Wxi2, strong, weak);
end