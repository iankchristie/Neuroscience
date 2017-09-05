load('/Users/ianchristie/Documents/MATLAB/Coupled-Pair/Data/ParFinderData/S10W5/AllDS.mat')
load('/Users/ianchristie/Documents/MATLAB/Coupled-Pair/Data/ParFinderData/S10W5/AllUni1.mat')
load('/Users/ianchristie/Documents/MATLAB/Coupled-Pair/Data/ParFinderData/S10W5/AllUni2.mat')

UniSpace = zeros(3,length(AllUni1));
DSSpace = zeros(3,length(AllDS));
BUniSpace = zeros(3,length(AllUni2));

for i = 1: length(AllUni1),
    UniSpace(1,i) = AllUni1{i}.Wr;
    UniSpace(2,i) = AllUni1{i}.W12;
    UniSpace(3,i) = AllUni1{i}.W21;
end

for i = 1: length(AllDS),
    DSSpace(1,i) = AllDS{i}.Wr;
    DSSpace(2,i) = AllDS{i}.W12;
    DSSpace(3,i) = AllDS{i}.W21;
end

for i = 1: length(AllUni2),
    BUniSpace(1,i) = AllUni2{i}.Wr;
    BUniSpace(2,i) = AllUni2{i}.W12;
    BUniSpace(3,i) = AllUni2{i}.W21;
end

%%%%%%%Plane 1%%%%%%%%%%%%
p1DS = find(DSSpace(1,:) == 0);
p1UniFull = find(UniSpace(1,:) == 0);
p1UniHalf = find(BUniSpace(1,:) == 0);

figure
plot(DSSpace(2,p1DS), DSSpace(3,p1DS),'ro');
hold on
plot(UniSpace(2,p1UniFull), UniSpace(3,p1UniFull),'bo');
hold on
plot(BUniSpace(2,p1UniHalf), BUniSpace(3,p1UniHalf),'go');
title('Recurrent Connections: 0');
xlabel('W12');
ylabel('W21');
legend('Full Unidirectional','Half Unidirectional');
axis([0 1 0 1]);

%%%%%%%Plane 2%%%%%%%%%%%%
p2DS = find(DSSpace(1,:) == .2);
p2UniFull = find(UniSpace(1,:) == .2);
p2UniHalf = find(BUniSpace(1,:) == .2);

figure
plot(DSSpace(2,p2DS), DSSpace(3,p2DS),'ro');
hold on
plot(UniSpace(2,p2UniFull), UniSpace(3,p2UniFull),'bo');
hold on
plot(BUniSpace(2,p2UniHalf), BUniSpace(3,p2UniHalf),'go');
title('Recurrent Connections: .2');
xlabel('W12');
ylabel('W21');
legend('Full Unidirectional','Half Unidirectional');
axis([0 1 0 1]);

%%%%%%%Plane 3%%%%%%%%%%%%
p3DS = find(DSSpace(1,:) == .38);
p3UniFull = find(UniSpace(1,:) == .38);
p3UniHalf = find(BUniSpace(1,:) == .38);

figure
plot(DSSpace(2,p3DS), DSSpace(3,p3DS),'ro');
hold on
plot(UniSpace(2,p3UniFull), UniSpace(3,p3UniFull),'bo');
hold on
plot(BUniSpace(2,p3UniHalf), BUniSpace(3,p3UniHalf),'go');
title('Recurrent Connections: .38');
xlabel('W12');
ylabel('W21');
legend('Directional Selective','Half Unidirectional');
axis([0 1 0 1]);








