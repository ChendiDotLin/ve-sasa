%--------------------------------------------------------------------------
% genEllipsePoints.m
% Given the 5 parameters that define the parametric equation for
% an ellipse, generate N equally spaced points along the ellipse
%--------------------------------------------------------------------------
% [X,Y] = genEllipsePoints(h,k,a,b,p,N)
% h : x center coordinate
% k : y center coordinate 
% a : x axis scaling
% b : y axis scaling
% p : tilt of the ellipse, in radians
% N : number of unique points to generate
% X : row vector of x coordinates for the ellipse
% Y : row vector of y coordinates for the ellipse
%--------------------------------------------------------------------------
% Author: Daniel R. Herber, Graduate Student, University of Illinois at
% Urbana-Champaign
% Date: 04/12/2016
%--------------------------------------------------------------------------
function [X,Y] = genEllipsePoints(h,k,a,b,p,N)

% generate N+1 points between 0 and 2pi
T = linspace(0,2*pi,N+1);

% remove last point as it is redundant
T(end) = [];

% temporary variables
t1 = cos(p); t2 = sin(p); t3 = cos(T); t4 = sin(T);

% X coordinates
% formula: x = h + cos(p)*a*cos(t) - sin(p)*b*sin(t)
X = h + a.*t1.*t3 - b.*t2.*t4; 

% Y coordinates
% formula:  y = k + sin(p)*a*cos(t) + cos(p)*b*sin(t)
Y = k + a.*t2.*t3 + b.*t1.*t4;

return