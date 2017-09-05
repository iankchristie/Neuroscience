for i = 1: 10,
   
    W = eye(2,2);
    
    a = rand(1)*30;
    b = rand(1)*30;
    if(a > b),
        strong = a;
        weak = b;
    else
        strong = b;
        weak = a;
    end
    
    u_up = [strong; weak];
    u_down = [weak; strong];
    
    deltaU = strong-weak;
    
    for j = 1: 100,
        Wxx = randn(1);
        Wxy = randn(1);
        
        m = [Wxx Wxy;
            Wxy Wxx];
        
        [v1, t1] = RunLinearModel(M, u_up, W);
        [v2, t2] = RunLinearModel(M, u_down, W);
        
        max_upA = v1(1,ceil(length(v1)/2));
        max_downA = v2(1,ceil(length(v1)/2));

        max_upB = v1(2,ceil(length(v1)/2));
        max_downB = v2(2,ceil(length(v1)/2));

        DIA = (max_upA - max_downA)/(max_upA + max_downA);
        DIB = (max_downB - max_upB)/(max_upB + max_downB);
        
        characteristicA = deltaU/((max_upA + max_downA)*(Wxx-Wxy));
        characteristicB = deltaU/((max_upB + max_downB)*(Wxx-Wxy));
        
        if DIA < characteristicA
            disp('Uncharacteristic  A');
            disp('Matrix');
            disp(m);
            disp('Math');
            disp(['DIA: ' num2str(DIA)]);
            disp(['Condition: ' num2str(characteristicA)]);
            disp(['                ' num2str(strong) ' - ' num2str(weak)]);
            disp(['(' num2str(max_upA) ' + '  num2str(max_downA) ')('  num2str(Wxx) ' - '  num2str(Wxy) ')']);
        end
        if DIB < characteristicB
            disp('Uncharacteristic B');
            disp('Matrix');
            disp(m);
            disp('Math');
            disp(['DIB: ' num2str(DIB)]);
            disp(['Condition: ' num2str(characteristicB)]);
            disp(['                ' num2str(strong) ' - ' num2str(weak)]);
            disp(['(' num2str(max_upB) ' + '  num2str(max_downB) ')('  num2str(Wxx) ' - '  num2str(Wxy) ')']);
        end
    end
end