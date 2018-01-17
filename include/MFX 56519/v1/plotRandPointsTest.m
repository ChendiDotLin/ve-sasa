%--------------------------------------------------------------------------
% plotRandPointsTest.m
% Randomly generate n points in a region around the convex hulls and
% visually demonstrate the linear constraints
%--------------------------------------------------------------------------
% plotRandPointsTest(n,Xo,Yo,Xl,Yl)
%  n : number of random points to test
% Xo : vector of original ellipse x coordinate values
% Yo : vector of original ellipse y coordinate values
% Xl : vector of linear constraint x coordinate values
% Yl : vector of linear constraint y coordinate values
%--------------------------------------------------------------------------
% Author: Daniel R. Herber, Graduate Student, University of Illinois at
% Urbana-Champaign
% Date: 04/12/2016
%--------------------------------------------------------------------------
function plotRandPointsTest(n,Xo,Yo,Xl,Yl)

figure('Color',[1 1 1]); % change the background to white

% plot options
hfig = gca; hfig.TickLabelInterpreter = 'latex';
hfig.Box = 'on'; hfig.BoxStyle = 'full';
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(gcf,'DefaultTextInterpreter', 'latex');
hold all

% determine range for testing, 20 percent extra on each side
xlb = min(Xo); xub = max(Xo); xlen = xub - xlb;
ylb = min(Yo); yub = max(Yo); ylen = yub - ylb;
Xlb = xlb-0.20*xlen; Xub = xub+0.20*xlen;
Ylb = ylb-0.20*ylen; Yub = yub+0.20*ylen;

% generate random test points
Xt = Xlb + (Xub-Xlb).*rand(n,1);
Yt = Ylb + (Yub-Ylb).*rand(n,1);

% combine into test points
X = [Xt,Yt]';

% create linear constraint matrices for original ellipse
[A,B] = vertxy2lcon(Xl,Yl);

% check constraint satisfaction  at test points
test = any(bsxfun(@gt,A*X,B),1);

% create linear constraint matrices for original ellipse
[Ao,Bo] = vertxy2lcon(Xo,Yo);

% check constraint satisfaction at test points
% testo = any(Ao*X > Bo(1),1);
testo = any(bsxfun(@gt,Ao*X,Bo),1);

% combine both checks
test = test + 2*testo;

% custom colors and color map
myr = [192 57 43]/255;
myo = [230 126 34]/255; % orange
% mydo = [128 24 0]/255; % darker orange
myg = [39 174 96]/255; % green
mydg = [0 72 0]/255; % darker green
colormap([myg;myo;myr])

% plot original ellipse
plot([Xo,Xo(1)],[Yo,Yo(1)],'-','color',[0 0 0]/255,'linewidth',2);

% plot approximate ellipse with linear constraints
plot([Xl,Xl(1)],[Yl,Yl(1)],'-','color',mydg,'linewidth',2);

% plot points classified by feasibility
scatter(Xt,Yt,[],test,'.')

% replot original ellipse
plot([Xo,Xo(1)],[Yo,Yo(1)],'-','color',[0 0 0]/255,'linewidth',2);

% replot approximate ellipse with linear constraints
plot([Xl,Xl(1)],[Yl,Yl(1)],'-','color',mydg,'linewidth',2);

% set axis limits
axis equal
xlim([Xlb Xub])
ylim([Ylb Yub])

% set labels
xlabel('$x_1$')
ylabel('$x_2$')

return