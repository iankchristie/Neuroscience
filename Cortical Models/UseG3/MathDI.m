
u1 = [10; 5];
u2 = [5; 10];

W = eye(2);

M = [.344 -.2; -.2 .344];

v = [0 ; 0];

%%Theoretical%%
Vss1 = -((M'-1)\(W*u1));
Vss2 = -((M'-1)\(W*u2));

DItheor = (Vss2 - Vss1)./(Vss2+Vss1);

%%Simulation%%
T = 0;  
dT = .0001;         
endTime = 3;        
time = T:dT:endTime;

tau = 0.001;

matr1 = zeros(length(v), length(time));
matr2 = zeros(length(v), length(time));

for i = 1: length(time)-1,
    matr1(:,i+1) =  matr1(:,i) + dT*(-matr1(:,i) + rectify(W*u1 + M'*(matr1(:,i))))/tau;
end

for i = 1: length(time)-1,
    matr2(:,i+1) =  matr2(:,i) + dT*(-matr2(:,i) + rectify(W*u2 + M'*(matr2(:,i))))/tau;
end

end1 = matr1(:,end);
end2 = matr2(:,end);

DIsim = (end2 - end1) ./ (end2+end1);
