%--------------------------------------------------------------------------
% testEllipseConstraints.m
% Test file demonstrating the functions included in this submission
%--------------------------------------------------------------------------
% testEllipseConstraints
%--------------------------------------------------------------------------
% Author: Daniel R. Herber, Graduate Student, University of Illinois at
% Urbana-Champaign
% Date: 04/12/2016
%--------------------------------------------------------------------------
%% Demonstrates the generation of the linear constraints

% ellipse parameters
h = -1; k = -2; a = 2; b = 1; p = pi/4;

% number of unique points to use
N = 8;

% generate approximate ellipse points
[X,Y] = genEllipsePoints(h,k,a,b,p,N);

% generate A and B matrix for A*X <= B
[A,B] = vertxy2lcon(X,Y);
disp('[A B]')
disp([A B])

%% Figures that visualize the difference

% original ellipse points
[Xo,Yo] = genEllipsePoints(h,k,a,b,p,10000);

% plot to visualize area difference between original and approximation
plotConvexHullDiff(Xo,Yo,X,Y)

% area error
error = polyarea(X,Y)/(pi*a*b) - 1;
annotation('textbox',[0.45 0.12 0.1 0.1],'String',[num2str(abs(error)*100,3),...
    '\% error in area'],'interpreter','latex','fontsize',14,'edgecolor','none')

% Randomly generate n points to visually demonstrate the linear constraints
plotRandPointsTest(10000,Xo,Yo,X,Y)

%% Demonstrates the moveVars function

% 6 total variables with x => x3, y => x2 
Am = moveVars(A,6,3,2);
disp(Am)

%% Small optimization example with the approximation
plotOptEx(h,k,a,b,p,N)