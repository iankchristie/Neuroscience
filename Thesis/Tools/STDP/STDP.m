function w = STDP(n1,n2)
%This function returns a weighted value
%   I haven't done it yet.

    t = 10/1000;
    A_plus = 0.005;
    A_minus = 0.005250;
    
    if isequal(size(n1),size(n2)) == 0
        error('Arrays must be of equal size');
    else
        n1= sort(n1);
        n2 = sort(n2);
        w=0;
        [~,cols1] = size(n1);
        [~,cols2] = size(n2);
        for k=1:cols1
            for j=1:cols2
                x = n2(j) - n1(k);
               if  x > 0
                    w = w + A_plus*exp(-x/t);
               else
                   w = w - A_minus*exp(x/t);
               end
            end
        end
    end
end
