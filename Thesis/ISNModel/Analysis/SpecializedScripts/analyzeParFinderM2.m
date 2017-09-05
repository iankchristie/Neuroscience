num = 21;

strong = 9:16;
weak = 6:13;

% for s = 1: length(strong),
%     for w = 1: length(weak),
%         if exist(sprintf('ParFinderM2Data/S%dW%d/AllDS.mat', strong(s), weak(w)))
%             delete(sprintf('ParFinderM2Data/S%dW%d/AllDS.mat', strong(s),weak(w)));
%         end
%         if exist(sprintf('ParFinderM2Data/S%dW%d/AllUn1.mat', strong(s), weak(w)))
%             delete(sprintf('ParFinderM2Data/S%dW%d/AllUni1.mat', strong(s),weak(w)));
%         end
%         if exist(sprintf('ParFinderM2Data/S%dW%d/AllUni2.mat', strong(s), weak(w)))
%             delete(sprintf('ParFinderM2Data/S%dW%d/AllUni2.mat', strong(s),weak(w)));
%         end
%     end
% end
% 
% for s = 1: length(strong),
%     for w = 1: length(weak),
%         if strong(s) > weak(w),
%             AllDS = {};
%             AllUni1 = {};
%             AllUni2 = {};
%             for i = 1: num,
%                 try
%                     load(sprintf('ParFinderM2Data/S%dW%d/DS%d.mat', strong(s),weak(w), i));
%                     AllDS = [AllDS x];
%                     load(sprintf('ParFinderM2Data/S%dW%d/uniType1%d.mat', strong(s),weak(w), i));
%                     AllUni1 = [AllUni1 x];
%                     load(sprintf('ParFinderM2Data/S%dW%d/uniType2%d.mat', strong(s),weak(w), i));
%                     AllUni2 = [AllUni2 x];
% %                     delete(sprintf('ParFinderM2Data/S%dW%d/uniType1%d.mat', strong(s),weak(w), i));
% %                     delete(sprintf('ParFinderM2Data/S%dW%d/uniType2%d.mat', strong(s),weak(w), i));
% %                     delete(sprintf('ParFinderM2Data/S%dW%d/DS%d.mat', strong(s),weak(w), i));
%                 catch err
%                     break
%                 end
%             end
%             save(sprintf('ParFinderM2Data/S%dW%d/AllDS.mat', strong(s),weak(w)), 'AllDS');
%             save(sprintf('ParFinderM2Data/S%dW%d/AllUni1.mat', strong(s),weak(w)), 'AllUni1');
%             save(sprintf('ParFinderM2Data/S%dW%d/AllUni2.mat', strong(s),weak(w)), 'AllUni2');
%         end
%     end
%     
% end

% works = [];
% 
% for  s = 1: length(strong),
%     for w = 1: length(weak),
%         if strong(s) > weak(w),
%             load(sprintf('ParFinderM2Data/S%dW%d/AllDS.mat', strong(s),weak(w)));
%             load(sprintf('ParFinderM2Data/S%dW%d/AllUni1', strong(s),weak(w)));
%             if ~isempty(AllDS) && ~isempty(AllUni1),
%                 works(1,end+1) = strong(s);
%                 works(2,end) = weak(w);
%             end
%         end
%     end
% end
% 
% 
for s = 1: length(strong),
    for w = 1: length(weak),
        if strong(s) > weak(w),
            load(sprintf('ParFinderM2Data/S%dW%d/AllDS.mat', strong(s),weak(w)), 'AllDS');
            load(sprintf('ParFinderM2Data/S%dW%d/AllUni1.mat', strong(s),weak(w)), 'AllUni1');
            load(sprintf('ParFinderM2Data/S%dW%d/AllUni2.mat', strong(s),weak(w)), 'AllUni2');

            UniSpace = zeros(3,length(AllUni1));
            DSSpace = zeros(3,length(AllDS));
            BUniSpace = zeros(3,length(AllUni2));

            for i = 1: length(AllUni1),
                UniSpace(1,i) = AllUni1{i}.Wr;
                UniSpace(2,i) = AllUni1{i}.W12;
                UniSpace(3,i) = AllUni1{i}.W21;
            end

            for i = 1: length(AllDS),
                DSSpace(1,i) = AllDS{i}.Wr;
                DSSpace(2,i) = AllDS{i}.W12;
                DSSpace(3,i) = AllDS{i}.W21;
            end

            for i = 1: length(AllUni2),
                BUniSpace(1,i) = AllUni2{i}.Wr;
                BUniSpace(2,i) = AllUni2{i}.W12;
                BUniSpace(3,i) = AllUni2{i}.W21;
            end


            figure;
            plot3(UniSpace(1,:),UniSpace(2,:),UniSpace(3,:),'o');
            hold on
            plot3(DSSpace(1,:),DSSpace(2,:),DSSpace(3,:),'ro');
            hold on
            plot3(BUniSpace(1,:),BUniSpace(2,:),BUniSpace(3,:),'go');
            title(sprintf('Strong %d     Weak%d', strong(s),weak(w)));
            xlabel('Wr');
            ylabel('W12');
            zlabel('W21');
            legend('UniSpace','DSSpace','BUniSpace');
            grid on
            savefig(sprintf('ParFinderM2Data/S%dW%d/Space.fig', strong(s),weak(w)));
        end
    end
end
