%Do Not Clear Variables
%This function works if and only if IappVector, taum, Rm, El, Vreset, and
%Vth are define variables

frequencyCurve = zeros(1,length(IappVector));   %Allocate memory for Curve

for i = 1:length(IappVector) %For the length of the current vector
    %Calculate frequency
    temp = 1/(taum*log(IappVector(i)*Rm+El-Vreset)-taum*log(IappVector(i)*Rm+El-Vth));
    %Because imaginary numbers are possible with log functions, we set all
    %imaginary numbers to 0
    if isreal(temp)
        frequencyCurve(i) =  temp;
    else
        frequencyCurve(i) =  0;
    end
end