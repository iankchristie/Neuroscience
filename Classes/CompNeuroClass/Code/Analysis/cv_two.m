% cv_two.m
% requires that dt is already defined, along with an array of spikes.
spiketimes=dt*find(spikes);
isis=diff(spiketimes);
cv=std(isis,1)/mean(isis)

sum2=0.0;
for i=2:length(isis)
    sum2 = sum2 + sqrt((isis(i)-isis(i-1))*(isis(i)-isis(i-1))) ... 
        /(isis(i)+isis(i-1))*(2.0);
end
cv2 = sum2 /(length(isis)-1)

