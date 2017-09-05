strong = 5;
weak = 2;

u = [strong;weak];

W = eye(2);

start = -2;
stop = 2;
inc = .25;

%Creating increment vectors
W11 = start:inc:stop;
W12 = start:inc:stop;
W21 = start:inc:stop;
W22 = start:inc:stop;

blowups = {};
anomalies = {};
works = {};
oscillatingWorks = {};
oscillatingNoWorks = {};

for i=1:length(W11),
    for j=1:length(W12),
        for k=1:length(W21),
            for l=1:length(W22),
                %create connection matrix M
                M = [W11(i) W12(j); W21(k) W22(l)];
                %Run the model and store in v
                [v, t] = RunLinearModel(M, u, W);
                
                r1 = v(1,end);
                r2 = v(2,end);
                
                avg = mean(v');
                r1_mean = avg(1);
                r2_mean = avg(2);
                
                r1_theory = (W21(k)*u(2) - (W22(l)-1)*u(1)) / ((W11(i) - 1)*(W22(l) - 1) - W12(j) * W21(k));
                r2_theory = (W12(j)*u(1) - (W11(i)-1)*u(2)) / ((W11(i) - 1)*(W22(l) - 1) - W12(j) * W21(k));
                
                s = struct('M',M,'r1',r1,'r2',r2,'r1_theory',r1_theory,'r2_theory',r2_theory);
                
%                 if abs(r1) > 500 || abs(r2) > 500,
%                     blowups{end+1} = s;
%                 elseif abs(r1-r1_theory) < 1 && abs(r2-r2_theory) < 1,
%                     works{end+1} = s;
%                 elseif abs(r1_mean-r1_theory) < 2 && abs(r2_mean-r2_theory) < 2,
%                     oscillatingWorks{end+1} = s;
%                 elseif oscillating(v(1,:), 5) || oscillating(v(2,:), 5),
%                     oscillatingNoWorks{end+1} = s;
%                 else
%                     anomalies{end+1} = s; 
%                 end
                
                if abs(r1-r1_theory) < 1 && abs(r2-r2_theory) < 1,
                    works{end+1} = s;
                elseif abs(r1_mean-r1_theory) < 2 && abs(r2_mean-r2_theory) < 2,
                    oscillatingWorks{end+1} = s;
                elseif oscillating(v(1,:), 5) || oscillating(v(2,:), 5),
                    oscillatingNoWorks{end+1} = s;
                elseif abs(r1) > 500 || abs(r2) > 500,
                    blowups{end+1} = s;
                else
                    anomalies{end+1} = s;
                end
            end
        end
    end
    disp(['W11: ']);
    disp(i);
end

%%%%%%%%%%%%%%%GRAPHING%%%%%%%%%%%%%%%%%%

map = [1 0 0; %red, anomalie
        0 1 0; %green, oscillating
        0 0 1; %blue, working
        .5 .5 .5]; %grey, blowup
   

responseM = zeros(length(W11),length(W12),length(W21),length(W22));    
    
for i=1:length(anomalies),
    M = anomalies{i}.M;
    j = reCounter(M(1,1),start,stop,inc);
    k = reCounter(M(1,2),start,stop,inc);
    l = reCounter(M(2,1),start,stop,inc);
    m = reCounter(M(2,2),start,stop,inc);
    responseM(j,k,l,m) = 1;
end
    
for i=1:length(blowups),
    M = blowups{i}.M;
    j = reCounter(M(1,1),start,stop,inc);
    k = reCounter(M(1,2),start,stop,inc);
    l = reCounter(M(2,1),start,stop,inc);
    m = reCounter(M(2,2),start,stop,inc);
    responseM(j,k,l,m) = 4;
end

for i=1:length(works),
    M = works{i}.M;
    j = reCounter(M(1,1),start,stop,inc);
    k = reCounter(M(1,2),start,stop,inc);
    l = reCounter(M(2,1),start,stop,inc);
    m = reCounter(M(2,2),start,stop,inc);
    responseM(j,k,l,m) = 3;
end

for i=1:length(oscillatingWorks),
    M = oscillatingWorks{i}.M;
    j = reCounter(M(1,1),start,stop,inc);
    k = reCounter(M(1,2),start,stop,inc);
    l = reCounter(M(2,1),start,stop,inc);
    m = reCounter(M(2,2),start,stop,inc);
    responseM(j,k,l,m) = 2;
end

for i=1:length(oscillatingNoWorks),
    M = oscillatingNoWorks{i}.M;
    j = reCounter(M(1,1),start,stop,inc);
    k = reCounter(M(1,2),start,stop,inc);
    l = reCounter(M(2,1),start,stop,inc);
    m = reCounter(M(2,2),start,stop,inc);
    responseM(j,k,l,m) = 2;
end

[m, ~, ~, n] = size(responseM);

plotLength = floor(sqrt(n));
plotWidth = ceil(sqrt(n));

while(plotLength*plotWidth < n),
    plotLength = plotLength + 1;
end

for i=1: m,
    temp = num2str(W11(i));
    titleString = ['W11 set to ' temp];
    figure('name', titleString);
    
    for j=1: n,
        subplot(plotLength,plotWidth,j);
        temp2 = num2str(W22(j));
        plot4Color(W12, W21, permute(responseM(i,:,:,j), [2 3 1 4]), ['W22 set to' temp2],'W12','W21');
        colormap(map);
    end
end