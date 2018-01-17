%--------------------------------------------------------------------------
% moveVars.m
% Move 2 variable a*x to the N variable A*X with specified locations in X
% for the 2 variables
%--------------------------------------------------------------------------
% Aout = moveVars(A,N,I1,I2)
%    A : n x 2 matrix that form the linear constraints
%    N : total number of variables
%   I1 : new index for 1st variable, between 1 and N
%   I2 : new index for 2nd variable, between 1 and N
% Aout : n x N matrix that form the linear constraints
%--------------------------------------------------------------------------
% Author: Daniel R. Herber, Graduate Student, University of Illinois at
% Urbana-Champaign
% Date: 04/12/2016
%--------------------------------------------------------------------------
function Aout = moveVars(A,N,I1,I2)

% number of linear constraints
n = size(A,1);

% initialize new A matrix
Aout = zeros(n,N); 

% move 1st variable to correct column
Aout(:,I1) = A(:,1);

% move 2nd variable to correct column
Aout(:,I2) = A(:,2);

return