function [ resp, cmap ] = drawSlice( slice , ISN_stats)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

out = 0;

[~, n, m] = size(slice);

resp = zeros(n,m);

for i = 1: n,
    for j = 1: m,
        if slice{1, i, j}.Nan == 1,
            resp(i,j) = 12;
        elseif slice{1, i, j}.BlowsUp == 1,
            resp(i,j) = 13;
        %elseif slice{1, i, j}.Oscillates == 1,
            %resp(i,j) = 13;
        else
            resp(i,j) = slice{1, i, j}.Response;
        end
	resp(i,j) = correct_ISN_classification(resp(i,j),ISN_stats{1,i,j});
    end
end

%cmap = getColorMap();
%cmap = getColorMap2();
%cmap = getColorMap3();
%cmap = getColorMap4();
cmap = getColorMap5();

figure;
image(slice{1,1,1}.Wxi1:.02:slice{1,n,1}.Wxi1, slice{1,1,1}.Wxi2:.02:slice{1,1,m}.Wxi2, round(resp), 'ButtonDownFcn', @point);
colormap(gcf, cmap);
%title(['Wxe = ' num2str(slice{1,1,1}.Wxe)]);
set(gca, 'YDir', 'normal');
axis off

out = out + 1;

    function point(gcbo, eventdata, handles)
        disp('Clicked');
        disp(get(gca, 'Currentpoint'));
        currPoint = get(gca, 'Currentpoint')
        x = round(currPoint(1,1) / (slice{1,2,1}.Wxi1 - slice{1,1,1}.Wxi1)) + 1,
        y = round(currPoint(1,2) / (slice{1,1,2}.Wxi2 - slice{1,1,1}.Wxi1)) + 1,
        slice{1,x,y}
        plot_ISN4d_output(slice{1,x,y})
        
    end

end

