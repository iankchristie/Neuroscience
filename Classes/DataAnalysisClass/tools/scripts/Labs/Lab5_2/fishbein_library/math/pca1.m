function [signals,PC,V,themean] = pca1(data) 

% PCA1: Perform PCA using covariance. 
% data - MxN matrix of input data 
% (M dimensions, N trials) 
% signals - MxN matrix of projected data 
% PC - each column is a PC 
% V - Mx1 matrix of variances 

[M,N] = size(data); 
[data,themean] = subtract_mean(data);
% calculate the covariance matrix 
covariance = 1 / (N-1) * data * data'; 
% find the eigenvectors and eigenvalues 
[PC, V] = eig(covariance); 
% extract diagonal of matrix as vector 
V = diag(V); 
% sort the variances in decreasing order 
%[junk, rindices] = sort(-1*V); 
[junk, rindices] = sort(-abs(V)); 
V = V(rindices);
PC = PC(:,rindices); 
% project the original data set 
signals = PC' * data;