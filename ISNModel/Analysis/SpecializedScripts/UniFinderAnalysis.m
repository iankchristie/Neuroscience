%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

actual = {};

strong = 7;
weak = 6;

w = [1 0; 1 0; 0 1; 0 1];

t0 = 0;
dt = .001;
tend = 2;
time = t0:dt:tend;
tau = .004;

z = zeros(2,.2/dt);
os = (1.15)*strong*ones(1,.6/dt);
ow = (1.15)*weak*ones(1,.6/dt);
ou = [os;ow];
od = [ow;os];

inputu = [z ou z [0;0]];
inputd = [z od z];

Itotal = [inputu inputd];

v = zeros(4,length(time));

for i = 1: 21,
    
    load(sprintf('/Users/ianchristie/Documents/MATLAB/Data/ISNUniFinder/uniType1%d.mat', i))
    disp(['Working on: ' num2str(i) '     size: ' num2str(length(x))]);
    
    for j = 1: length(x),
        
        Wee = x{j}.Wee;
        Wii = x{j}.Wii;
        Wei = x{j}.Wei;
        Wie = x{j}.Wie;
        Wxe1 = x{j}.Wxe1;
        Wxe2 = x{j}.Wxe2;
        Wxi1 = x{j}.Wxi1;
        Wxi2 = x{j}.Wxi2;
    
        m = [Wee     Wei      Wxe1         Wxi1;
            Wie     Wii      0         0;
            0       Wxi2       Wee       Wei;
            Wxe2       0        Wie       Wii];

        r = runISNTime(time, dt, tau, m, Itotal, w, v);
        
        if unidirectionalType1(r,dt) == 1,
            if ~any([oscillating(r(1,:),4) oscillating(r(2,:),4) oscillating(r(3,:),4) oscillating(r(3,:),4)])
                actual{end+1} = x{j};
            end
        end
        
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sumIdea = zeros(3, length(actual));
    
for i = 1: length(actual),

    Wee = actual{i}.Wee;
    Wii = actual{i}.Wii;
    Wei = actual{i}.Wei;
    Wie = actual{i}.Wie;
    Wxe1 = actual{i}.Wxe1;
    Wxe2 = actual{i}.Wxe2;
    Wxi1 = actual{i}.Wxi1;
    Wxi2 = actual{i}.Wxi2;
    
    sumIdea(1,i) = Wee+Wxe2+Wie-(Wii+Wei+Wxi2);
    sumIdea(2,i) = Wee+Wxe1+Wie-(Wii+Wei+Wxi1);
    sumIdea(3,i) = sumIdea(1,i)/sumIdea(2,i);

end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Wxe1v = zeros(1,length(actual));
Wxe2v = zeros(1,length(actual));
Wxi1v = zeros(1,length(actual));
Wxi2v = zeros(1,length(actual));

for i = 1: length(actual),
    Wxe1v(i) = actual{i}.Wxe1;
    Wxe2v(i) = actual{i}.Wxe2;
    Wxi1v(i) = actual{i}.Wxi1;
    Wxi2v(i) = actual{i}.Wxi2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
plot3(Wxe1v,Wxi1v,Wxi2v,'o')

hold on

[s,p] = best_fit_plane(Wxe1v', Wxi1v', Wxi2v');
[x y] = meshgrid(0:.05:1);
z = (-p(4)-p(2)*y-p(1)*x)/p(3);
hsurf = surf(x,y,z)
set(hsurf,'FaceColor',[1 0 0],'FaceAlpha',0.5);
hold on

[m,p,s] = best_fit_line(Wxe1v', Wxi1v', Wxi2v');
t = linspace(-.6,.46);
x = m(1) + p(1)*t;
y = m(2) + p(2)*t;
z = m(3)+p(3)*t;
line = [x;y;z];
plot3(x,y,z);

xlabel('Wxe1')
ylabel('Wxi1')
zlabel('Wxi2')
%axis([0 1 0 1 0 1]);


grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ox = [];
oy = [];
oz = [];

[~, width] = size(line);

for i = 1: 5: width,
    disp(['Working on ' num2str(i)]);
    for r = 0: .1: .2,
        [tx, ty, tz] = sphere_shell(r,line(1,i),line(2,i),line(3,i));
        ox = [ox tx];
        oy = [oy ty];
        oz = [oz tz];
    end
end
figure
for i = 1: 20
    plot3(ox,oy,oz)
    hold on
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[l, width] = size(ox);
points = zeros(3,l*width);
count = 1;

for i = 1: l,
    disp(['Working on ' num2str(i)]);
    for j = 1: width,
        m = [.5     .25      ox(i,j)         oy(i,j);
           -.25     0      0         0;
            0       oz(i,j)       .5      .25;
            .15       0        -.25       0];
                
         r = runISNTime(time, dt, tau, m, Itotal, w, v);
         
        if unidirectionalType1(r,dt) == 1,
             points(1, count) = ox(i,j);
             points(2, count) = oy(i,j);
             points(3, count) = oz(i,j);
             count = count + 1;
         end
    end
end

plot3(points(1,:),points(2,:),points(3,:),'og')


