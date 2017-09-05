s = 18;
w = 16;

t0 = 0;
dt = .001;
tend = 2;
time = t0:dt:tend;
tau = .004;

inputMatrix = [1 0;
               1 0;
               0 1;
               0 1];
 
tempVector = zeros(4,length(time));

%%%%%The model%%%%%
%       E1      I1      E2      I2
%E1     Wee     Wei     Wxe1    Wxi1
%I1     Wie     Wii     0       0
%E2     Wxe2    Wxi2    Wee     Wei
%I2     0       0       Wie     Wii

Wee = .5;
Wei = .25;
Wie = -.25;
Wii = 0;

Wxe = 0:.02:2;
Wxi1 = 0:.02:2;
Wxi2 = 0:.02:2;

Itotal = createInputISN(s, w, dt);

dsSpace = [];
uniSpace = [];
halfUniSpace = [];

for i = 1: length(Wxe),
    disp(['Working on ' num2str(Wxe(i))]);
    for j = 1: length(Wxi1),
        disp(['          Working on ' num2str(Wxi1(j))]);
        for k = 1: length(Wxi2),
            
            m = getConnectionMatrix('Wxe',Wxe(i),'Wxi1',Wxi1(j),'Wxi2',Wxi2(k));
                        
            r = runISNTime(time,dt,tau,m,Itotal,inputMatrix,tempVector);
            
            if DirectionalType1(r,dt) == 1,
                dsSpace(1,end+1) = Wxe(i);
                dsSpace(2,end) = Wxi1(j);
                dsSpace(3,end) = Wxi2(k);
            end
            if unidirectionalType1(r,dt) == 1,
                uniSpace(1,end+1) = Wxe(i);
                uniSpace(2,end) = Wxi1(j);
                uniSpace(3,end) = Wxi2(k);
            end
            if unidirectionalType2(r,dt) == 1,
                halfUniSpace(1,end+1) = Wxe(i);
                halfUniSpace(2,end) = Wxi1(j);
                halfUniSpace(3,end) = Wxi2(k);
            end
        end
    end
end

figure;
plot3(uniSpace(1,:),uniSpace(2,:),uniSpace(3,:),'o');
hold on
plot3(dsSpace(1,:),dsSpace(2,:),dsSpace(3,:),'ro');
hold on
plot3(halfUniSpace(1,:),halfUniSpace(2,:),halfUniSpace(3,:),'go');
title(sprintf('Strong %d     Weak%d', works(1,k),works(2,k)));
xlabel('Wxe');
ylabel('Wxi1');
zlabel('Wxi2');
legend('uniSpace','dsSpace','HalfUni');
grid on

