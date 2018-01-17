function [A,B,C] = LTI(n,kernel)

if exist(kernel,'file')
    load(kernel)
else
    
    %Kval = Kval/max(Kval);
    % data
    N = 60; % number of data points
    % tv = logspace(-1,1,N)'; % location of data points
    %tv = linspace(0,1,N)';
    tv  = ((zwgll(N) + 1)/2)'
    %{
    vdv = @(s,e,d) sort([linspace(s(1),e(1),d(1))  linspace(s(2),e(2),d(2))  linspace(s(3),e(3),d(3))]);

    s = [0 0.195 0.21];
    e = [0.19 0.205 1];
    d = [30 100 20];
    tv = vdv(s,e,d)';
    %}
    Kv = Kfun(tv); % evaluate kernel function on the grid
    
    tic
    x0 = -ones(2*n,1);
    options = optimoptions('lsqnonlin','Display','Iter');
    [x,resnorm] = lsqnonlin(@(x) Func(x,n,tv,Kv),x0,[],[],options);
    toc
    
    figure()
    % plot results
    % semilogx(tv,Kv,'.'); hold on
    plot(tv,Kv,'.','markersize',16); hold on
    legend('K')
    xopt = x;
    tv2 = linspace(0,1,10*N)';
    A = [[zeros(1,n-1);eye(n-1)],xopt(1:n)];
    B = xopt(n+1:end);
    C = [zeros(1,n-1,1),1];
    for j = 1:length(tv2)
        f(j) = C*expm(A*tv2(j))*B;
    end
    plot(tv2,f);
    legend('LTI Fitting')
    
    %}
    
    save(kernel,'A','B','C');
end
end

function F = Func(x,n,tv,Kv)
F = Kv - ComputeCeAtB(x,n,tv);
%F(42) = [];
%F(13) = [];
end

function f = ComputeCeAtB(x,n,tv)
% construct matrices
A = [[zeros(1,n-1);eye(n-1)],x(1:n)];
B = x(n+1:end);
C = [zeros(1,n-1,1),1];

% initialize
f = zeros(length(tv),1);

% evaluate
for k = 1:length(tv)
    f(k) = C*expm(A*tv(k))*B;
end

end

function Kv = Kfun(t)
% parameters
%{
t1 = 0.2; t2 = 0.7;
b1 = -3; b2 = -0.5 ; b3 = -7;

% kernel function
Kv = (t<=t1).*exp(b1*t) + (t<=t2 & t>t1).*exp(b1*t1).*exp(b2*(t-t1)) +...
    (t>t2).*exp(b1*t1).*exp(b2*(t2-t1)).*exp(b3*(t-t2));
%Kv = a0*Kv;
%Kv = 1000*exp(-t/2);
Kv = -exp(2*t) +8;
%}
%{
Kv = sign((t-0.2)).*abs((t-0.2).^(1/5));
Kv = -1*Kv;
Kv = Kv - min(Kv);
Kv = Kv/max(Kv);
%}
t1 = 0.2; t2 = 0.7;
b1 = 0.3; b2 = -10 ; b3 = -7;

% kernel function
Kv = (t<=t1).*(-exp(b1*t)+3) + (t>t1).*(-exp(b1*t1)+3).*exp(b2*(t-t1));
Kv = Kv/max(Kv);

end

