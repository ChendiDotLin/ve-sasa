function [TT,U,Y,P,F,p,opts] = vesasa_scaled(A,B,D,tm,tf,emax,umax,dumax,ell,opts,p)

% Ts = 1;
% us = 1;
% Ds = 1;
% ts = 1;

Ts = 1e-3;
us = umax;
Ds = emax*ell;
ts = tm;

Tdiag = [Ts,Ts/ts,Ds,Ds/ts,ones(1,length(A)-4)];
T = diag(Tdiag);
Tinv = diag(1./Tdiag);

%% phase 1
p.t0 = 0/ts; p.tf = tm/ts;

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
UB(1).matrix = [Inf;zeros(length(A)-1,1)]; % 
LB(1).right = 4; % initial states
LB(1).matrix = [-Inf;zeros(length(A)-1,1)]; % 
% final conditions

% control amplitude constraint
UB(2).right = 1; % controls
UB(2).matrix = umax/us;
LB(2).right = 1; % controls
LB(2).matrix = -umax/us;
% strain constraint
UB(3).right = 2; % states
UB(3).matrix = [Inf;Inf;emax*ell/Ds;Inf(length(A)-3,1)]; % emax*ell
LB(3).right = 2; % states
LB(3).matrix = -UB(3).matrix;

% combine
setup(1).A = ts*Tinv*A*T; setup(1).B = ts*us*Tinv*B; setup(1).d = ts*Tinv*zeros(length(A),1); setup(1).M = M;
setup(1).UB = UB; setup(1).LB = LB; setup(1).p = p;

%% phase 2
clear M UB LB
p.t0 = tm/ts; p.tf = tf/ts;

% dynamics
d = cell(length(A),1);
d{2,1} = D{1};
d{4,1} = D{2};

% control amplitude constraint
UB(1).right = 1; % controls
UB(1).matrix = umax/us;
LB(1).right = 1; % controls
LB(1).matrix = -umax/us;
% holding and strain constraint
UB(2).right = 2; % states
UB(2).matrix = [10^(-12)/Ts;10^(-12)*ts/Ts;emax*ell/Ds;Inf(length(A)-3,1)]; % emax*ell
LB(2).right = 2; % states
LB(2).matrix = -UB(2).matrix;

% combine
setup(2).A = ts*Tinv*A*T; setup(2).B = ts*us*Tinv*B; setup(2).d = ts*Tinv*zeros(length(A),1);
setup(2).UB = UB; setup(2).LB = LB; setup(2).p = p;

%% solve
% opts.disp = 'iter';
[TT,U,Y,P,F,p,opts] = DTQP_solve(setup,opts);

F = F*Ts;