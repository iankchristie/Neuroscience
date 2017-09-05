numTrials = 300;
Wrecorder = zeros(4,numTrials+1);
DIrecorder = zeros(2,numTrials);

strong = 18;
weak = 16;

Wee = .5;
Wei = .25;
Wie = -.25;
Wii = 0;
Wxe_initial = .125;
Wxe1 = Wxe_initial;
Wxe2 = Wxe_initial;
Wxy_initial = .5;
Wxi1 = Wxy_initial;
Wxi2 = Wxy_initial;

Wrecorder(1:2,:) = Wxy_initial;
Wrecorder(3:4,:) = Wxe_initial;

t0 = 0;
dt = .001;
tend = 1;
time = t0:dt:tend;
tau = .004;

inputMatrix = [1 0;
               1 0;
               0 1;
               0 1];
           
v = zeros(4,length(time));

Itotal = createInputISN(strong, weak, dt);

IUp = Itotal(:,1:ceil(end/2));
IDown = Itotal(:,ceil(end/2):end);

temp = 0;

for i = 1: numTrials,
    disp(['Trial Num: ' num2str(i)]);
    
    m = getConnectionMatrix2('Wxe1',Wxe1,'Wxe2',Wxe2,'Wxi1',Wxi1,'Wxi2',Wxi2);
    
    if temp == 1,
        temp = 0;
    else
        temp = 1;
    end
    
    if temp,
        disp('UP');
        [r1] = runISNTime(time, dt, tau, m, IUp, inputMatrix, v);
        [r2] = runISNTime(time, dt, tau, m, IDown, inputMatrix, v);
    else
        disp('Down');
        [r1] = runISNTime(time, dt, tau, m, IDown, inputMatrix, v);
        [r2] = runISNTime(time, dt, tau, m, IUp, inputMatrix, v);
    end
    %%Inhibitory Wxi1
%     dWxi1 = ratePlasticityISN(r1(1,:), r1(4,:), dt);
%     Wxi1 = rectify(Wxi1 + dWxi1);
%     %%Inhibitory Wxi2
%     dWxi2 = ratePlasticityISN(r1(3,:), r1(2,:), dt);
%     Wxi2 = rectify(Wxi2 + dWxi2);
    %%Excitatory Wxe1
    dWxe1 = ratePlasticityISN(r1(1,:), r1(3,:), dt);
    Wxe1 = rectify(Wxe1 + dWxe1);
    %%Excitatory Wxe1
    dWxe2 = ratePlasticityISN(r1(3,:), r1(1,:), dt);
    Wxe2 = rectify(Wxe2 + dWxe2);
    
    Wrecorder(1,i+1) = Wxi1;
    Wrecorder(2,i+1) = Wxi2;
    Wrecorder(3,i+1) = Wxe1;
    Wrecorder(4,i+1) = Wxe2;
    
        if temp,
            A_Up_response = r1(1,floor(.7/dt));
            A_Down_response = r2(1,floor(.7/dt));

            B_Up_response = r1(3,floor(.7/dt));
            B_Down_response = r2(3,floor(.7/dt));
        else
            A_Up_response = r2(1,floor(.7/dt));
            A_Down_response = r1(1,floor(.7/dt));

            B_Up_response = r2(3,floor(.7/dt));
            B_Down_response = r1(3,floor(.7/dt));
        end
    
    A_DI = (A_Up_response - A_Down_response) / (A_Up_response + A_Down_response);
    B_DI = (B_Down_response - B_Up_response) / (B_Up_response + B_Down_response);
    
    DIrecorder(1,i) = A_DI;
    DIrecorder(2,i) = B_DI;

    if mod(i,9)==0,
        if temp,
            PlotISN(time, IUp, r1);
            title('Repsonse in Up Direction');
        else
            PlotISN(time, IDown, r1);
            title('Repsonse in Down Direction');
        end
        xlabel('Time (sec)');
        ylabel('Response (Hz)');
        legend('Neuron A','Neuron B');
    end
    
end

figure;
subplot(2,1,1);
plot(Wrecorder(1,:));
hold on
plot(Wrecorder(2,:),'r');
hold on
plot(Wrecorder(3,:),'g');
hold on
plot(Wrecorder(4,:),'k');
title('Bidirectional Training');
xlabel('Trial Number');
ylabel('Strength');
xlim([0 numTrials]);
legend('Wxi1','Wxi2','Wxe1','Wxe2');

subplot(2,1,2);
plot(DIrecorder(1,:));
hold on
plot(DIrecorder(2,:),'r');
title('Bidirectional Training');
xlabel('Trial Number');
ylabel('Index');
xlim([0 numTrials]);s
legend('Neuron A','Neuron B');