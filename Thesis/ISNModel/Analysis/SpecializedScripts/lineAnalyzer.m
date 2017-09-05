s = 16;
w = 6;

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

Wee = .5;
Wei = .25;
Wie = -.25;
Wii = 0;
Wxbase = .25;
Wxi1 = 1;
Wxi2 = .625;

Wxe = 0:.001:.25;

ds = {};
uni = {};
halfuni = {};
all = {};
none = {};

Itotal = createInputISN(s, w, dt);

RDILog = zeros(1,length(Wxe));
LDILog = zeros(1,length(Wxe));

for i = 1: length(Wxe),
    m = getConnectionMatrix2('Wxe1',Wxbase+Wxe(i),'Wxe2',Wxbase-Wxe(i),'Wxi1',Wxi1,'Wxi2',Wxi2);
                        
    r = runISNTime(time,dt,tau,m,Itotal,inputMatrix,tempVector);

    if DirectionalType1(r,dt) == 1,
        ds{end+1} = struct('m',m,'Wxe',Wxe(i),'Wxi1',Wxi1,'Wxi2',Wxi2,'Strong',s,'Weak', w);
    end
    if unidirectionalType1(r,dt) == 1,
        uni{end+1} = struct('m',m,'Wxe',Wxe(i),'Wxi1',Wxi1,'Wxi2',Wxi2,'Strong',s,'Weak', w);
    end
    if unidirectionalType2(r,dt) == 1,
        halfuni{end+1} = struct('m',m,'Wxe',Wxe(i),'Wxi1',Wxi1,'Wxi2',Wxi2,'Strong',s,'Weak', w);
    end
    
    if AllResponsive(r,dt) == 1,
        all{end+1} = struct('m',m,'Wxe',Wxe(i),'Wxi1',Wxi1,'Wxi2',Wxi2,'Strong',s,'Weak', w);
    end
    
    [~, ~, ~, ~, LDI, RDI] = analyzeISNOutput(r,dt);
    
    RDILog(i) = RDI;
    LDILog(i) = LDI;
    
%     if NoneResponsive(r,dt) == 1,
%         none{end+1} = struct('m',m,'Wxe',Wxe(i),'Wxi1',Wxi1,'Wxi2',Wxi2,'Strong',s,'Weak', w);
%     end
end

UniSpace = zeros(3,length(uni));
DSSpace = zeros(3,length(ds));
BUniSpace = zeros(3,length(halfuni));
AllSpace = zeros(3,length(all));
NoneSpace = zeros(3,length(none));

for i = 1: length(uni),
    UniSpace(1,i) = uni{i}.Wxe;
    UniSpace(2,i) = uni{i}.Wxi1;
    UniSpace(3,i) = uni{i}.Wxi2;
end

for i = 1: length(ds),
    DSSpace(1,i) = ds{i}.Wxe;
    DSSpace(2,i) = ds{i}.Wxi1;
    DSSpace(3,i) = ds{i}.Wxi2;
end

for i = 1: length(halfuni),
    BUniSpace(1,i) = halfuni{i}.Wxe;
    BUniSpace(2,i) = halfuni{i}.Wxi1;
    BUniSpace(3,i) = halfuni{i}.Wxi2;
end

for i = 1: length(all),
    AllSpace(1,i) = all{i}.Wxe;
    AllSpace(2,i) = all{i}.Wxi1;
    AllSpace(3,i) = all{i}.Wxi2;
end

for i = 1: length(none),
    NoneSpace(1,i) = none{i}.Wxe;
    NoneSpace(2,i) = none{i}.Wxi1;
    NoneSpace(3,i) = none{i}.Wxi2;
end

figure;
plot3(UniSpace(1,:),UniSpace(2,:),UniSpace(3,:),'o');
hold on
plot3(DSSpace(1,:),DSSpace(2,:),DSSpace(3,:),'ro');
hold on
plot3(BUniSpace(1,:),BUniSpace(2,:),BUniSpace(3,:),'go');
hold on
plot3(AllSpace(1,:),AllSpace(2,:),AllSpace(3,:),'ko');
% hold on
% plot3(NoneSpace(1,:),NoneSpace(2,:),NoneSpace(3,:),'yo');
title(sprintf('Strong %d     Weak%d', s,w));
xlabel('Wxe');
ylabel('Wxi1');
zlabel('Wxi2');
legend('UniSpace','DSSpace','HalfUni','All','None');
grid on

figure;
plot(Wxe,RDILog);
hold on
plot(Wxe, LDILog, 'r');
title(sprintf('Strong %d     Weak%d', s,w));
xlabel('Wxe');
ylabel('DI');
legend('Right Column','Left Column');



