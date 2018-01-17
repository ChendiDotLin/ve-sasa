function optimize()
close all
clear
warning('off','optim:quadprog:NullHessian')

% obtain the kernel function approximation
n = 20;
kernel = 'Function5.mat';
[As,Bs,Cs] = LTI(n,kernel);

% paramters in SI units
p.rho = 7800;
p.h = 0.018;
p.J_theta = 372.49;
p.r = 1.02;
p.E = 1.57*10^9;
p.A0 = 3;
p.umax = 20;
p.emax = 5;
% number of optimization variables
nx = 1;

% bounds for k
LB_true = 10;
UB_true = 1000                  ;
p.LB_true = LB_true;
p.UB_true = UB_true;

% initial guess
k0 = 0;
% no damper
%x0 = [k0,0,1];
x0 = [k0];
% options
opt = optimset('Display','iter');

% solve
[x,fval,exitflag] = fmincon(@(x) inner(x,As,Bs,Cs,p,1),x0,[],[],[],[],zeros(nx,1),ones(nx,1),[],opt);

% optimal stiffness and length
xunscaled = (UB_true - LB_true)*x + LB_true;
kopt = xunscaled(1);
lopt =  ((p.A0*p.E*p.h^3)/(6*kopt))^(1/2);

[TT,Y1,F] = plot_inner([x,0,1],As,Bs,Cs,p,0);


% with damper
nx = 3;

x0 = [k0,0,1];
%x0 = [k0];
% options
opt = optimset('Display','iter');

% solve
[x,fval,exitflag] = fmincon(@(x) inner(x,As,Bs,Cs,p,1),x0,[],[],[],[],zeros(nx,1),ones(nx,1),[],opt);

% optimal stiffness and length
xunscaled = (UB_true - LB_true)*x + LB_true;
kopt = xunscaled(1);
lopt =  ((p.A0*p.E*p.h^3)/(6*kopt))^(1/2);

[TT,Y2,F] = plot_inner(x,As,Bs,Cs,p,0);
display ('Without damper')
Y1(1,1)
display ('With damper')
Y2(1,1)


plot(TT,Y2(:,1:4)); hold on
title('States')
xlabel('time (s)')
legend('\theta', '\theta dot','\delta','\delta dot')
end


function F = inner(x,As,Bs,Cs,p,flag)

% extract from p
rho = p.rho; E = p.E;
A0 = p.A0; J_theta = p.J_theta;
h = p.h;
r = p.r;
lb = p.LB_true; ub = p.UB_true;

% unscale k
k = (ub-lb)*x(1) + lb;

% calculate length and width
l = ((A0*E*h^3)/(6*k))^(1/2); % k = 2EI/L
w = A0/l;

% time horizon
tm = 0.2; % first phase
tf = 1; % final

% ve material
n = length(As);
if length(x) == 3
    
    Ks = (10000-10)*x(2) + 10;
    ts = x(3);
else
    Ks = 0;
    ts = 1;
end
% calculate terms in the dynamics
m = rho*l*w*h;
J_delta = 1/12 * m * (l^2 + h^2);
m11 = J_theta + 2*J_delta + 2*m*r^2 + 1/2*m*l^2 + 2*l*m*r;
m12 = 2*J_delta + m*r*l + 1/2*m*l^2;
m21 = m12;
m22 = 2*J_delta + 1/2*m*l^2;

k22 = 2*k;
a21 = 2;
Delta = 1/(m11*m22 - m12*m21);

A = zeros(4,4);
A(1,2) = 1; A(3,4) = 1;
A(2,3) = Delta*k22*m12;
A(4,3) = -Delta*k22*m11;

zero_vec = zeros(1,n);
A = [A,[zero_vec;Delta*m12*Ks*Cs;zero_vec;-Delta*m11*Ks*Cs]];
A = [A;[zero_vec',zero_vec',zero_vec',Bs,ts*As]];
B = [0;-Delta*a21*m12;0;Delta*a21*m11;zero_vec'];
D{1} = 0;
D{2} = @(t) 1*sin(2*t);

% constraints
emax = p.emax;
umax = p.umax;
dumax = []; % none at the moment

% DT QP options
opts = [];
opts.displevel = 0;
opts.Defectmethod = 'HS'; % Hermite-Simpson
opts.Quadmethod = 'CQHS'; %
p.nt = 100;

% solve
if flag
    [~,~,~,~,F,~,~] = vesasa_scaled(A,B,D,tm,tf,emax,umax,dumax,l,opts,p);
else
    [~,~,~,~,F,~,~] = vesasa(A,B,D,tm,tf,emax,umax,dumax,l,opts,p);
end
end

function [TT,Y,F] = plot_inner(x,As,Bs,Cs,p,flag)

% extract from p
rho = p.rho; E = p.E;
A0 = p.A0; J_theta = p.J_theta;
h = p.h;
r = p.r;
lb = p.LB_true; ub = p.UB_true;

% unscale k
k = (ub-lb)*x(1) + lb;

% calculate length and width
l = ((A0*E*h^3)/(6*k))^(1/2); % k = 3EI/L^3
w = A0/l;

% time horizon
tm = 0.2; % first phase
tf = 1; % final

% ve material
n = length(As);
%Ks = 0;
%ts = 1;
Ks = x(2);
ts = x(3);

% calculate terms in the dynamics
m = rho*l*w*h;
J_delta = 1/12 * m * (l^2 + h^2);
m11 = J_theta + 2*J_delta + 2*m*r^2 + 1/2*m*l^2 + 2*l*m*r;
m12 = 2*J_delta + m*r*l + 1/2*m*l^2;
m21 = m12;
m22 = 2*J_delta + 1/2*m*l^2;

k22 = 2*k;
a21 = 2;
Delta = 1/(m11*m22 - m12*m21);

A = zeros(4,4);
A(1,2) = 1; A(3,4) = 1;
A(2,3) = Delta*k22*m12;
A(4,3) = -Delta*k22*m11;

zero_vec = zeros(1,n);
A = [A,[zero_vec;Delta*m12*Ks*Cs;zero_vec;-Delta*m11*Ks*Cs]];
A = [A;[zero_vec',zero_vec',zero_vec',Bs,ts*As]];
B = [0;-Delta*a21*m12;0;Delta*a21*m11;zero_vec'];
D{1} = 0;
D{2} = @(t) 0.001*sin(2*t);

% constraints
emax = p.emax;
umax = p.umax;
dumax = []; % none at the moment

% DT QP options
opts = [];
opts.displevel = 0;
opts.Defectmethod = 'HS'; % Hermite-Simpson
opts.Quadmethod = 'CQHS'; %
p.nt = 100;

% solve
if flag
    [TT,~,Y,~,F,~,~] = vesasa_scaled(A,B,D,tm,tf,emax,umax,dumax,l,opts,p);
else
    [TT,~,Y,~,F,~,~] = vesasa(A,B,D,tm,tf,emax,umax,dumax,l,opts,p);
end
end