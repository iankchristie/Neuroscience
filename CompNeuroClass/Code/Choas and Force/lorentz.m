% lorentz.m

sigma = 10;

beta = 8/3;

rho = 28;

dt = 0.0001;
tmax = 8;

t = 0:dt: tmax;
x = zeros(size(t));
y = zeros(size(t));
z = zeros(size(t));

x(1) = -10.0;
y(1) = -10.0;
z(1) = 10.00;

for i = 1:length(t)-1
    dxdt = sigma*(y(i) - x(i));

    dydt = x(i)*(rho - z(i)) - y(i);
    
    dzdt = x(i)*y(i) - beta*z(i);
    
    x(i+1) = x(i) + dxdt*dt;
    y(i+1) = y(i) + dydt*dt;
    z(i+1) = z(i) + dzdt*dt;

end
figure(1)

plot3(x(1),y(1),z(1),'o','LineWidth',2,'MarkerSize',10)

hold on
plot3(x,y,z,'g')

plot3(x(end),y(end),z(end),'x','LineWidth',2,'MarkerSize',10)

figure(2)
plot(x(1),y(1),'o','LineWidth',2,'MarkerSize',10)

hold on
plot(x,y,'g')

plot(x(end),y(end),'x','LineWidth',2,'MarkerSize',10)