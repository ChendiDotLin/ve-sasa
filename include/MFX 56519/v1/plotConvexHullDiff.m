%--------------------------------------------------------------------------
% plotConvexHullDiff.m
% Plot the difference between the original ellipse and convex approximate
% with N points
%--------------------------------------------------------------------------
% plotConvexHullDiff(Xo,Yo,Xl,Yl)
% Xo : vector of original ellipse x coordinate values
% Yo : vector of original ellipse y coordinate values
% Xl : vector of linear constraint x coordinate values
% Yl : vector of linear constraint y coordinate values
%--------------------------------------------------------------------------
% Author: Daniel R. Herber, Graduate Student, University of Illinois at
% Urbana-Champaign
% Date: 04/12/2016
%--------------------------------------------------------------------------
function plotConvexHullDiff(Xo,Yo,Xl,Yl)

figure('Color',[1 1 1]); % change the background to white

% plot options
hfig = gca; hfig.TickLabelInterpreter = 'latex';
hfig.Box = 'on'; hfig.BoxStyle = 'full';
set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(gcf,'DefaultTextInterpreter', 'latex');
hold all

% custom colors
myo = [230 126 34]/255; % orange
mydo = [128 24 0]/255; % darker orange
myg = [39 174 96]/255; % green
mydg = [0 72 0]/255; % darker green

% original feasible area
patch([Xo,Xo(1)],[Yo,Yo(1)],myo,'EdgeColor',mydo,'LineWidth',2)

% approximate feasible area with linear constraints
patch([Xl,Xl(1)],[Yl,Yl(1)],myg,'EdgeColor',mydg,'LineWidth',2)

% legend
hL = legend('$F(X) \leq 0$','$A X \leq b$');
set(hL,'interpreter','latex','Location','northoutside','Orientation','horizontal')

% set axis limits
axis equal
xlb = min(Xo); xub = max(Xo); xlen = xub - xlb;
ylb = min(Yo); yub = max(Yo); ylen = yub - ylb;
xlim([xlb-0.20*xlen xub+0.20*xlen]) % 20 percent extra on each side
ylim([ylb-0.20*ylen yub+0.20*ylen]) % 20 percent extra on each side

% set labels
xlabel('$x_1$')
ylabel('$x_2$')

return