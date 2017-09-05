function [out, works] = analyzePath(path, strong, weak, varargin)
%analyzePath Prints Data in the directories in the Path from Strong to Weak
%   Given a path like
%   '/Users/ianchristie/Documents/MATLAB/ParFinderM10Data' that contains
%   directories in the format S%dW%d that have 

out = 0;

xlab = 'Wxe';
ylab = 'Wxi1';
zlab = 'Wxi2';

works = [];

for  s = 1: length(strong),
    for w = 1: length(weak),
        if strong(s) > weak(w),
            load(sprintf([path '/S%dW%d/AllDS.mat'], strong(s),weak(w)));
            AllDS = x;
            load(sprintf([path '/S%dW%d/AllUni'], strong(s),weak(w)));
            AllUni = x;
            if ~isempty(AllDS) && ~isempty(AllUni),
                works(1,end+1) = strong(s);
                works(2,end) = weak(w);
            end
        end
    end
end

assign(varargin{:});

for k = 1: length(works),
    if works(1,k) > works(2,k),
        
        leg = {};
        
        load(sprintf([path '/S%dW%d/AllDS.mat'], works(1,k),works(2,k)));
        AllDS = x;
        load(sprintf([path '/S%dW%d/AllDSSup.mat'], works(1,k),works(2,k)));
        AllDSSup = x;
        load(sprintf([path '/S%dW%d/AllUni.mat'], works(1,k),works(2,k)));
        AllUni = x;
        load(sprintf([path '/S%dW%d/AllHalfUni.mat'], works(1,k),works(2,k)));
        AllUni2 = x;
        load(sprintf([path '/S%dW%d/AllUnSel.mat'], works(1,k),works(2,k)));
        AllUnSel = x;
        
        
        DSSpace = zeros(3,length(AllDS));
        DSSupSpace = zeros(3,length(AllDSSup));
        UniSpace = zeros(3,length(AllUni));
        BUniSpace = zeros(3,length(AllUni2));
        UnSelSpace = zeros(3,length(AllUnSel));
        
        if ~isempty(AllDS), 
            for i = 1: length(AllDS),
                eval(['DSSpace(1,i) = AllDS{i}.' xlab ';']);
                eval(['DSSpace(2,i) = AllDS{i}.' ylab ';']);
                eval(['DSSpace(3,i) = AllDS{i}.' zlab ';']);
            end
            leg{end+1} = 'DS';
        end
        
        if ~isempty(AllDSSup), 
            for i = 1: length(AllDSSup),
                eval(['DSSupSpace(1,i) = AllDSSup{i}.' xlab ';']);
                eval(['DSSupSpace(2,i) = AllDSSup{i}.' ylab ';']);
                eval(['DSSupSpace(3,i) = AllDSSup{i}.' zlab ';']);
            end
            leg{end+1} = 'DSSup';
        end
        
        if ~isempty(AllUni), 
            for i = 1: length(AllUni),
                eval(['UniSpace(1,i) = AllUni{i}.' xlab ';']);
                eval(['UniSpace(2,i) = AllUni{i}.' ylab ';']);
                eval(['UniSpace(3,i) = AllUni{i}.' zlab ';']);
            end
            leg{end+1} = 'Uni';
        end

        if ~isempty(AllUni2), 
            for i = 1: length(AllUni2),
                eval(['BUniSpace(1,i) = AllUni2{i}.' xlab ';']);
                eval(['BUniSpace(2,i) = AllUni2{i}.' ylab ';']);
                eval(['BUniSpace(3,i) = AllUni2{i}.' zlab ';']);
            end
            leg{end+1} = 'HalfUni';
        end
        
        if ~isempty(AllUnSel), 
            for i = 1: length(AllUnSel),
                eval(['UnSelSpace(1,i) = AllUnSel{i}.' xlab ';']);
                eval(['UnSelSpace(2,i) = AllUnSel{i}.' ylab ';']);
                eval(['UnSelSpace(3,i) = AllUnSel{i}.' zlab ';']);
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
        title(sprintf('Strong %d     Weak%d', works(1,k),works(2,k)));
        xlabel(xlab);
        ylabel(ylab);
        zlabel(zlab);
        legend(leg);
        grid on
    end
end

out = 1;

end

