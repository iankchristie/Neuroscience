% sqnums.m
% produces an array of square numbers
clear
Nmax = 500;

 % We will act as if spikes are produced at the times given when 
 % i is a square number:
spikes = zeros(1,Nmax);

numberout = 0;
for i = 1:Nmax
    
   root = round(sqrt(i)); % root is nearest integer to square root of i
   
   if ( root*root == i ) % only true if i is a square number
       numberout = numberout+1      % tells us how many values stored so far
       array(numberout) = i;        % array stores the square numbers
   end
    
end

% We can produce an array "spikes" in two ways. 
% Between the "if" and "end" we could have written:
% spikes(i) = 1;
% Here, instead, we can do it another way in Matlab:
spikes(array) = 1;

plot(spikes)

array

