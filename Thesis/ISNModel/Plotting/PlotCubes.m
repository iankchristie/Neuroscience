strong = 2:18;
weak = 1:17;

startVal = 50;
endVal = 150;
count = 1;

for s = 1: length(strong),
    for w = 1: length(weak),
        if strong(s) > weak(w),
            if startVal <= count && count <= endVal,
            
                load(sprintf([pwd '/WholeCubesData4/S%dW%d/Cube.mat'], strong(s),weak(w)));

                analyzeWholeCube(x,strong(s),weak(w));
                
            end
            count = count + 1;
        end
    end
end