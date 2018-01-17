function [T,U,Y,P,F,p,opts] = vesasa(A,B,D,tm,tf,emax,umax,dumax,ell,opts,p)

%% phase 1
p.t0 = 0; p.tf = tm;

% dynamics
d = cell(length(A),1);
d{2,1} = D{1};
d{4,1} = D{2};

% objective
% maximize initial bus angle
M(1).right = 4; % initial states
M(1).matrix = [-1,zeros(1,length(A)-1)];

% simple bounds
% initial conditions
UB(1).right = 4; % initial states
UB(1).matrix = [Inf;zeros(length(A)-1,1)];
LB(1).right = 4; % initial states
LB(1).matrix = [-Inf;zeros(length(A)-1,1)];
% final conditions

% control amplitude constraint
UB(2).right = 1; % controls
UB(2).matrix = umax; % umax
LB(2).right = 1; % controls
LB(2).matrix = -umax; % umax
% strain constraint
UB(3).right = 2; % states
UB(3).matrix = [Inf;Inf;emax*ell;Inf(length(A)-3,1)];
LB(3).right = 2; % states
LB(3).matrix = -UB(3).matrix;

% combine
setup(1).A = A; setup(1).B = B; setup(1).d = zeros(length(A),1); setup(1).M = M;
setup(1).UB = UB; setup(1).LB = LB; setup(1).p = p;

%% phase 2
clear M UB LB
p.t0 = tm; p.tf = tf;

% dynamics
d = cell(length(A),1);
d{2,1} = D{1};
d{4,1} = D{2};

% control amplitude constraint
UB(1).right = 1; % controls
UB(1).matrix = umax;
LB(1).right = 1; % controls
LB(1).matrix = -umax;
% holding and strain constraint
UB(2).right = 2; % states
UB(2).matrix = [10^(-12);10^(-12);emax*ell;Inf(length(A)-3,1)];
LB(2).right = 2; % states
LB(2).matrix = -UB(2).matrix;

% combine
setup(2).A = A; setup(2).B = B; setup(2).d = zeros(length(A),1);
setup(2).UB = UB; setup(2).LB = LB; setup(2).p = p;

%% solve
[T,U,Y,P,F,p,opts] = DTQP_solve(setup,opts);