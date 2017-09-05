function [PC,V] = lca1(W, B)


[PC,V] = eig(inv(W)*B);
V = diag(V);
[junk,rindices] = sort(-abs(V));
V = V(rindices);
PC = PC(:,rindices);

