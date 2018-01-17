%--------------------------------------------------------------------------
% vertxy2lcon.m
% Given a set of (x,y) points, compute the linear inequality constraints
% that bound the convex hull
%--------------------------------------------------------------------------
% See the function vert2lcon for a more general implementation
% http://www.mathworks.com/matlabcentral/fileexchange/30892
%--------------------------------------------------------------------------
% [A,b] = vertxy2lcon(X1,Y1)
% X1 : N x 1 vector of x coordinate values
% Y1 : N x 1 vector of y coordinate values
%  A : N x 2 matrix that forms the matrix term in Ax <= b
%  b : N x 1 vector that forms the constant term in Ax <= b
%--------------------------------------------------------------------------
% Author: Daniel R. Herber, Graduate Student, University of Illinois at
% Urbana-Champaign
% Date: 04/12/2016
%--------------------------------------------------------------------------
function [A,b] = vertxy2lcon(X1,Y1)

% compute convex hull
K = convhull(X1,Y1);

% reassign points to make convex hull
X1 = X1(K);
Y1 = Y1(K);

% remove final (duplicate) point
X1(end) = [];
Y1(end) = [];

% need column vectors
X1 = X1(:); Y1 = Y1(:);

% shift values back one position
X2 = circshift(X1,-1); 
Y2 = circshift(Y1,-1);

% matrix term
A = [ Y2 - Y1, X1 - X2 ];

% constant term, all b values are the same
b = X1.*Y2 - X2.*Y1;

return