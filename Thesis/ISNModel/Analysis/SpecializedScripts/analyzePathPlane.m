function [ out ] = analyzePathPlane(path, slopes, varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

out = 0;

x = 'Wxi';
y = 'Wxe1';
z = 'Wxe2';

works = [];

for  s = 1: length(slopes),
%     load(sprintf([path '/Slope%d/AllDS.mat'], s));
%     AllDS = x;
%     load(sprintf([path '/Slope%d/AllUni'], s));
%     AllUni = x;
%     if ~isempty(AllDS) && ~isempty(AllUni),
        works(1,end+1) = s;
%     end
end

assign(varargin{:});

for k = 1: length(works),
        
    leg = {};

    load(sprintf([path '/Slope%d/AllDS.mat'], works(1,k)));
    AllDS = x;
    load(sprintf([path '/Slope%d/AllDSSup.mat'], works(1,k)));
    AllDSSup = x;
    load(sprintf([path '/Slope%d/AllUni.mat'], works(1,k)));
    AllUni = x;
    load(sprintf([path '/Slope%d/AllHalfUni.mat'], works(1,k)));
    AllUni2 = x;
    load(sprintf([path '/Slope%d/AllUnSel.mat'], works(1,k)));
    AllUnSel = x;


    DSSpace = zeros(3,length(AllDS));
    DSSupSpace = zeros(3,length(AllDSSup));
    UniSpace = zeros(3,length(AllUni));
    BUniSpace = zeros(3,length(AllUni2));
    UnSelSpace = zeros(3,length(AllUnSel));

    if ~isempty(AllDS), 
        for i = 1: length(AllDS),
            DSSpace(1,i) = AllDS{i}.Wxi2;
            DSSpace(2,i) = AllDS{i}.Wxe1;
            DSSpace(3,i) = AllDS{i}.Wxe2;
        end
        leg{end+1} = 'DS';
    end

    if ~isempty(AllDSSup), 
        for i = 1: length(AllDSSup),
            DSSupSpace(1,i) = AllDSSup{i}.Wxi2;
            DSSupSpace(2,i) = AllDSSup{i}.Wxe1;
            DSSupSpace(3,i) = AllDSSup{i}.Wxe2;
        end
        leg{end+1} = 'DSSup';
    end

    if ~isempty(AllUni), 
        for i = 1: length(AllUni),
            UniSpace(1,i) = AllUni{i}.Wxi2;
            UniSpace(2,i) = AllUni{i}.Wxe1;
            UniSpace(3,i) = AllUni{i}.Wxe2;
        end
        leg{end+1} = 'Uni';
    end

    if ~isempty(AllUni2), 
        for i = 1: length(AllUni2),
            BUniSpace(1,i) = AllUni2{i}.Wxi2;
            BUniSpace(2,i) = AllUni2{i}.Wxe1;
            BUniSpace(3,i) = AllUni2{i}.Wxe2;
        end
        leg{end+1} = 'HalfUni';
    end

    if ~isempty(AllUnSel), 
        for i = 1: length(AllUnSel),
            UnSelSpace(1,i) = AllUnSel{i}.Wxi2;
            UnSelSpace(2,i) = AllUnSel{i}.Wxe1;
            UnSelSpace(3,i) = AllUnSel{i}.Wxe2;
        end
        leg{end+1} = 'UnSel';
    end

    figure;
    plot3(DSSpace(1,:),DSSpace(2,:),DSSpace(3,:),'ro');
    hold on
    plot3(DSSupSpace(1,:),DSSupSpace(2,:),DSSupSpace(3,:),'ro', 'MarkerFaceColor','m');
    hold on
    plot3(UniSpace(1,:),UniSpace(2,:),UniSpace(3,:),'o');
    hold on
    plot3(BUniSpace(1,:),BUniSpace(2,:),BUniSpace(3,:),'go');
    hold on
    plot3(UnSelSpace(1,:),UnSelSpace(2,:),UnSelSpace(3,:),'ko');
    hold on
    title(sprintf('Slope  %d', works(1,k)));
    xlabel('Wxi');
    ylabel(y);
    zlabel(z);
    legend(leg);
    grid on
end

out = out + 1;

end

