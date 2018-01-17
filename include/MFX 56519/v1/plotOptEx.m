%--------------------------------------------------------------------------
% plotOptEx.m
% Small optimization example with and without the ellipse constraint 
% approximation
%--------------------------------------------------------------------------
% plotOptEx(h,k,a,b,p,N)
% h : x center coordinate
% k : y center coordinate 
% a : x axis scaling
% b : y axis scaling
% p : tilt of the ellipse, in radians
% N : number of unique points to generate
%--------------------------------------------------------------------------
% Author: Daniel R. Herber, Graduate Student, University of Illinois at
% Urbana-Champaign
% Date: 04/12/2016
%--------------------------------------------------------------------------
function plotOptEx(h,k,a,b,p,N)

% generate approximate ellipse points
[X,Y] = genEllipsePoints(h,k,a,b,p,N);

% generate A and B matrix for A*X <= B
[A,B] = vertxy2lcon(X,Y);

% original ellipse points
[Xo,Yo] = genEllipsePoints(h,k,a,b,p,10000);

figure('Color',[1 1 1]); % change the background to white

% plot options
hfig = gca; hfig.TickLabelInterpreter = 'latex';
hfig.Box = 'on'; hfig.BoxStyle = 'full';
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(gcf,'DefaultTextInterpreter', 'latex');
hold all

% objective function
fxy = @(x1,x2) x1.^2 + x2.^2;
f = @(x) fxy(x(1),x(2));

% constraint function
A1 = (b*cos(p))^2  + (a*sin(p))^2;
B1 = -2*cos(p)*sin(p)*(a^2 - b^2);
C1 = (b*sin(p))^2  + (a*cos(p))^2;
D1 = -2*A1*h - k*B1;
E1 = -2*C1*k - h*B1;
F1 = -(a*b)^2 + A1*h^2 + B1*h*k + C1*k^2;
gxy = @(x1,x2) [ 0, A1*x1.^2 + B1*x1.*x2 + C1*x2.^2 + D1*x1 + ...
    E1*x2 + F1];
g = @(x) gxy(x(1),x(2));

% solve the problem with approximate ellipse with linear constraints as a
% quadratic program
options = optimoptions('quadprog','Display','none');
tic
for i = 1:20 % solve it 20 times
    Xopt = quadprog(eye(2),[],A,B,[],[],[],[],[],options);
end
t = toc; disp(['Quadratic program time: ',num2str(t/20),' s'])

% solve the problem with nonlinear ellipse constraint
options = optimoptions('fmincon','Display','none');
tic
for i = 1:20 % solve it 20 times
    Xopt2 = fmincon(@(x) f(x),[h k],[],[],[],[],[],[],@(x) nonlincon(x,g),options);
end
t = toc; disp(['Nonlinear program time: ',num2str(t/20),' s'])

% custom colors
% myr = [192 57 43]/255;
myo = [230 126 34]/255; % orange
% mydo = [128 24 0]/255; % darker orange
myg = [39 174 96]/255; % green
% mydg = [0 72 0]/255; % darker green

% grid of points for objective function contours
xv = linspace(-3,1,100);
yv = linspace(-4,0,100);
[Xv,Yv] = meshgrid(xv,yv);

% change the colormap to gray
colormap(gray)

% plot objective function contours
[~,hC] = contourf(Xv,Yv,fxy(Xv,Yv),200);
set(hC,'LineStyle','none');

% plot original ellipse
plot([Xo,Xo(1)],[Yo,Yo(1)],'linewidth',2,'color',myo);

% plot linear constraints
plot([X,X(1)],[Y,Y(1)],'w','linewidth',2,'color',myg);

% plot optimal value found using original ellipse constraint
plot(Xopt2(1),Xopt2(2),'.','markersize',20,'color',myo);

% plot optimal value found using linear constraint approximation
plot(Xopt(1),Xopt(2),'.','markersize',20,'color',myg);

% create legend
hL = legend('$f(x)$','$g(x) \leq 0$','$Ax \leq b$','$x^*_{g}$','$x^*_{Ax}$');
% set(hL,'interpreter','latex','Location','northoutside','Orientation','horizontal')
set(hL,'interpreter','latex','Location','eastoutside','Orientation','vertical')

% set labels
xlabel('$x_1$')
ylabel('$x_2$')

% set axis limits
axis equal
xlim([min(xv) max(xv)])
ylim([min(yv) max(yv)])

end

% nonlinear constraint function
function [c,ceq] = nonlincon(x,g)
ceq = [];
c = g(x);
end