function createSky(YMatrix1)
%CREATEFIGURE(YMatrix1)
%  YMATRIX1:  matrix of y data

%  Auto-generated by MATLAB on 07-May-2019 12:51:15

% Create figure
figure1 = figure('Name','Skyline Providers');

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create multiple lines using matrix input to plot
plot1 = plot(YMatrix1);
set(plot1(1),'DisplayName','Temporal IaaS Skyline without Dominant QoS',...
    'LineStyle','--');
set(plot1(2),'DisplayName','Temporal IaaS Skyline with Dominant QoS',...
    'Color',[0 0 0]);

% Create ylabel
ylabel('Number of Providers in the Skyline','FontSize',16);

% Create xlabel
xlabel('Number of Providers','FontSize',16);

% Uncomment the following line to preserve the X-limits of the axes
 xlim(axes1,[4 60]);
% Uncomment the following line to preserve the Y-limits of the axes
 ylim(axes1,[1 50]);
box(axes1,'on');
% Create legend
legend1 = legend(axes1,'show');
set(legend1,'FontSize',14);

