strong = 5;
weak = 2;

M = [.25   .1;
   .1    .25];

u_up = [strong; weak];
u_down = [weak; strong];

W = eye(2,2);

[v1, t1] = RunLinearModel(M, u_up, W);
[v2, t2] = RunLinearModel(M, u_down, W);

max_upA = v1(1,ceil(length(v1)/2))
max_downA = v2(1,ceil(length(v1)/2))

max_upB = v1(2,ceil(length(v1)/2))
max_downB = v2(2,ceil(length(v1)/2))

DIA = (max_upA - max_downA)/(max_upA + max_downA)
DIB = (max_downB - max_upB)/(max_upB + max_downB)
figure;
subplot(2,1,1);
plot(t1, v1(1,:));
hold on
plot(t2,v2(1,:),'r');
subplot(2,1,2);
plot(t1, v1(2,:));
hold on
plot(t2, v2(2,:),'r');