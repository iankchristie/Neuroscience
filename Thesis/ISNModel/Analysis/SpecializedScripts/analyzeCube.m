function [out,DSSpace,DSSupSpace,UniSpace,UniSupSpace,HalfUniSpace,HalfUniSupSpace,UnSelSpace,NoneRespSpace,UnSSSpace] = analyzeCube(x, s, w, varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


out = 0;

xlab = 'Wxe2';
ylab = 'Wxi1';
zlab = 'Wxi2';

leg = {};

assign(varargin{:});


[m, n, o] = size(x);

DSSpace = [];
DSSupSpace = [];
UniSpace = [];
UniSupSpace = [];
HalfUniSpace = [];
HalfUniSupSpace = [];
UnSelSpace = [];
NoneRespSpace = [];
UnSSSpace = []; %%UnSteadyState. As in the space doesn't fallback to a steady state of 0 after input ceases. Probably because excitatory inputs are positive feedback


for i = 1: m,
    for j = 1: n,
        for k = 1: o,
        
            if x{i,j,k}.SS == 0,
                eval(['UnSSSpace(1,end+1) = x{i,j,k}.' xlab ';']);
                eval(['UnSSSpace(2,end) = x{i,j,k}.' ylab ';']);
                eval(['UnSSSpace(3,end) = x{i,j,k}.' zlab ';']);
            else
                tempLUe = x{i,j,k}.LUe;
                tempLDe = x{i,j,k}.LDe;
                tempRUe = x{i,j,k}.RUe;
                tempRDe = x{i,j,k}.RDe;
                tempSS = x{i,j,k}.SS;
                tempLUi = x{i,j,k}.LUi;
                tempLDi = x{i,j,k}.LDi;
                tempRUi = x{i,j,k}.RUi;
                tempRDi = x{i,j,k}.RDi;
                tempLDI = (tempLUe - tempLDe) / (tempLUe + tempLDe);
                tempRDI = (tempRDe - tempRUe) / (tempRUe + tempRDe);
                tempLSI = (tempLUi - tempLDi) / (tempLUi + tempLDi);
                tempRSI = (tempRDi - tempRUi) / (tempRDi + tempRUi);
                
                tempDS = DirectionalSelective(tempLUe, tempLDe, tempRUe, tempRDe, tempLUi, tempLDi, tempRUi, tempRDi, tempSS);
                if tempDS == 2,
                    eval(['DSSupSpace(1,end+1) = x{i,j,k}.' xlab ';']);
                    eval(['DSSupSpace(2,end) = x{i,j,k}.' ylab ';']);
                    eval(['DSSupSpace(3,end) = x{i,j,k}.' zlab ';']);
                    DSSupSpace(4,end) = 30+mean([tempLDI, tempRDI])*50;
                elseif tempDS == 1,
                    eval(['DSSpace(1,end+1) = x{i,j,k}.' xlab ';']);
                    eval(['DSSpace(2,end) = x{i,j,k}.' ylab ';']);
                    eval(['DSSpace(3,end) = x{i,j,k}.' zlab ';']);
                    DSSpace(4,end) = 30+mean([tempLDI, tempRDI])*50;
                end

                tempUni = UniDirectional(tempLUe, tempLDe, tempRUe, tempRDe, tempLUi, tempLDi, tempRUi, tempRDi, tempSS);
                if tempUni == 2,
                    eval(['UniSupSpace(1,end+1) = x{i,j,k}.' xlab ';']);
                    eval(['UniSupSpace(2,end) = x{i,j,k}.' ylab ';']);
                    eval(['UniSupSpace(3,end) = x{i,j,k}.' zlab ';']);
                    UniSupSpace(4,end) = 30+abs(mean([tempLDI, tempRDI]))*50;
                elseif tempUni == 1,
                    eval(['UniSpace(1,end+1) = x{i,j,k}.' xlab ';']);
                    eval(['UniSpace(2,end) = x{i,j,k}.' ylab ';']);
                    eval(['UniSpace(3,end) = x{i,j,k}.' zlab ';']);
                    UniSpace(4,end) = 30+abs(mean([tempLDI, tempRDI]))*50;
                end

                tempHalfUni = HalfUniDirectional(tempLUe, tempLDe, tempRUe, tempRDe, tempLUi, tempLDi, tempRUi, tempRDi, tempSS);
                if tempHalfUni == 2,
                    eval(['HalfUniSupSpace(1,end+1) = x{i,j,k}.' xlab ';']);
                    eval(['HalfUniSupSpace(2,end) = x{i,j,k}.' ylab ';']);
                    eval(['HalfUniSupSpace(3,end) = x{i,j,k}.' zlab ';']);
                    HalfUniSupSpace(4,end) = 30+abs(mean([tempLDI, tempRDI]))*50;
                elseif tempHalfUni == 1,
                    eval(['HalfUniSpace(1,end+1) = x{i,j,k}.' xlab ';']);
                    eval(['HalfUniSpace(2,end) = x{i,j,k}.' ylab ';']);
                    eval(['HalfUniSpace(3,end) = x{i,j,k}.' zlab ';']);
                    HalfUniSpace(4,end) = 30+abs(mean([tempLDI, tempRDI]))*50;
                end

                if UnSelective2(tempLUe, tempLDe, tempRUe, tempRDe, tempLUi, tempLDi, tempRUi, tempRDi, tempSS),
                    eval(['UnSelSpace(1,end+1) = x{i,j,k}.' xlab ';']);
                    eval(['UnSelSpace(2,end) = x{i,j,k}.' ylab ';']);
                    eval(['UnSelSpace(3,end) = x{i,j,k}.' zlab ';']);
                end

                if UnResponsive(tempLUe, tempLDe, tempRUe, tempRDe, tempLUi, tempLDi, tempRUi, tempRDi, tempSS),
                    eval(['NoneRespSpace(1,end+1) = x{i,j,k}.' xlab ';']);
                    eval(['NoneRespSpace(2,end) = x{i,j,k}.' ylab ';']);
                    eval(['NoneRespSpace(3,end) = x{i,j,k}.' zlab ';']);
                end
            end
        end
    end
end

        
figure;
if ~isempty(DSSpace),
    scatter3(DSSpace(1,:),DSSpace(2,:),DSSpace(3,:),DSSpace(4,:),'r');
    hold on
    leg{end+1} = 'DSSpace';
end

if ~isempty(DSSupSpace),
    scatter3(DSSupSpace(1,:),DSSupSpace(2,:),DSSupSpace(3,:),DSSupSpace(4,:),'r','MarkerFaceColor','m');
    hold on
    leg{end+1} = 'DSSupSpace';
end

if ~isempty(UniSpace),
    scatter3(UniSpace(1,:),UniSpace(2,:),UniSpace(3,:),UniSpace(4,:),'b');
    hold on
    leg{end+1} = 'UniSpace';
end

if ~isempty(UniSupSpace),
    scatter3(UniSupSpace(1,:),UniSupSpace(2,:),UniSupSpace(3,:),UniSupSpace(4,:),'b','MarkerFaceColor','c');
    hold on
    leg{end+1} = 'UniSupSpace';
end

if ~isempty(HalfUniSpace),
    scatter3(HalfUniSpace(1,:),HalfUniSpace(2,:),HalfUniSpace(3,:),HalfUniSpace(4,:),'g');
    hold on
    leg{end+1} = 'HalfUniSpace';
end

if ~isempty(UnSelSpace),
    scatter3(UnSelSpace(1,:),UnSelSpace(2,:),UnSelSpace(3,:),'k');
    hold on
    leg{end+1} = 'UnSelSpace';
end

if ~isempty(NoneRespSpace),
    scatter3(NoneRespSpace(1,:),NoneRespSpace(2,:),NoneRespSpace(3,:),'y');%'Color',[.7 .5 0]);
    hold on
    leg{end+1} = 'NoneRespSpace';
end

% if ~isempty(UnSSSpace),
%     scatter3(UnSSSpace(1,:),UnSSSpace(2,:),UnSSSpace(3,:),'yo');
%     leg{end+1} = 'UnSSSpace';
% end

title(sprintf('Strong %d     Weak%d',s,w));
xlabel(xlab);
ylabel(ylab);
zlabel(zlab);
legend(leg);
grid on

out = out + 1;

end
