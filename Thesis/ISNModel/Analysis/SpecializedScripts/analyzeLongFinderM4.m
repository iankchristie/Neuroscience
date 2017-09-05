num = 21;
 strong = 9:16;
 weak = 6:13;

 cd /Users/ianchristie/Documents/MATLAB

works = [];

for  s = 1: length(strong),
    for w = 1: length(weak),
        if strong(s) > weak(w),
            load(sprintf('LongFinderM4Data/S%dW%d/AllDS.mat', strong(s),weak(w)));
            load(sprintf('LongFinderM4Data/S%dW%d/AllUni', strong(s),weak(w)));
            if ~isempty(ds) && ~isempty(uni),
                works(1,end+1) = strong(s);
                works(2,end) = weak(w);
            end
        end
    end
end


for k = 1: length(works),
    if works(1,k) > works(2,k),
        load(sprintf('LongFinderM4Data/S%dW%d/AllDS.mat', works(1,k),works(2,k)));
        load(sprintf('LongFinderM4Data/S%dW%d/AllUni.mat', works(1,k),works(2,k)));
        load(sprintf('LongFinderM4Data/S%dW%d/AllHalfUni.mat', works(1,k),works(2,k)));

        UniSpace = zeros(3,length(uni));
        DSSpace = zeros(3,length(ds));
        BUniSpace = zeros(3,length(halfuni));

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


        figure;
        plot3(UniSpace(1,:),UniSpace(2,:),UniSpace(3,:),'o');
        hold on
        plot3(DSSpace(1,:),DSSpace(2,:),DSSpace(3,:),'ro');
        hold on
        plot3(BUniSpace(1,:),BUniSpace(2,:),BUniSpace(3,:),'go');
        title(sprintf('Strong %d     Weak%d', works(1,k),works(2,k)));
        xlabel('Wxe');
        ylabel('Wxi1');
        zlabel('Wxi2');
        legend('UniSpace','DSSpace','HalfUni');
        grid on
        %savefig(sprintf('FinderM3Data/S%dW%d/Space.fig', works(1,k),works(2,k)));
    end
end