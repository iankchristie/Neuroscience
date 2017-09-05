% z = zeros(1,500);
% o = ones(1,500);
% pre_r = [10*o 50*o];
% post_r = [50*o 10*o];

%space1;
pre_r = v1(2,:);
post_r = v1(1,:);

dT = .001;

[w, r] = ratePlasticity1(pre_r, post_r, dT);

disp(w);

figure;
subplot(2,1,1);
plot(pre_r);
hold on;
plot(post_r,'r');
hold off;
subplot(2,1,2);
plot(r);
