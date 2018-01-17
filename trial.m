
t = linspace(0,1,100);

t1 = 0.2; t2 = 0.7;
b1 = 0.3; b2 = -5 ; b3 = -7;

% kernel function
Kv = (t<=t1).*(-exp(b1*t)+2) + (t>t1).*(-exp(b1*t1)+3).*exp(b2*(t-t1))
%Kv = a0*Kv;
%Kv = 1000*exp(-t/2);
%%}


plot(t,Kv,'ro-')