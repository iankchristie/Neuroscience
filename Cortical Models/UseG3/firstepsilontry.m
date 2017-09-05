T = 0;  
dT = .001;         
endTime = .5;        
time = T:dT:endTime;

u1 = [10; 5];
u2 = [5; 10];

W = eye(2);

M = [.344 .1; .1 .344];

v = zeros(2,length(time));

epsilon = .0001;
comparisonVect = ones(length(v),1);

delta = Inf(length(v),1);

tau = 0.004;

%%activation function parameters
alpha = 100;
beta = .08;
gamma = 1.984;
x0 = 26;

% while isequal(abs(delta) > epsilon, comparisonVect),
%     disp('numcalls');
%     I = W*u1 - M*v(:,end);
%     f = rectify((alpha ./ (1+exp(beta*(I+x0)))) - gamma);
%     delta = dT*(-v(:,end)+f)/tau;
%     v(:,end+1) = v(:,end)+delta;
% end

for i = 2:length(time),
    I = W*u1*FFI(time(i)) - M'*v(:,i-1);
    f = F(I);     
    delta = dT*(-v(:,i-1)+f)/tau;
    v(:,i) = v(:,i-1)+delta;
end

figure;
plot(time,v');
legend('neuron1','neuron2');




