clear all;
clc;

%%

pf1 = pf_near; %% Input time series
Fs_p = 10000; % Sampling frequency

t1 = 0.0001:1/Fs_p:3; % 3 is the length of time series data (in seconds)

%%
Fs_p = 10000;
[WT_p,f_p,coi_p] = cwt(pf1,Fs_p);

% Create figure
figure1 = figure('InvertHardcopy','off','WindowState','maximized',...
    'Color',[1 1 1]);
colormap(jet);

% Create axes
axes1 = axes('Parent',figure1,...
    'Position',[0.0514322916666667 0.625 0.483984375 0.335202991452991]);
hold(axes1,'on');
levs = 0:0.05:1;
[C_p,h_p] = contourf(t1,f_p,abs(WT_p),levs);
set(h_p,'LineColor','none')
% Uncomment the following line to preserve the X-limits of the axes
%     xlim(axes1,[0.45 0.65]);
% Uncomment the following line to preserve the Y-limits of the axes
ylim(axes1,[0 800]);
box(axes1,'on');
hold(axes1,'off');
% Set the remaining axes properties
set(axes1,'TickDir','out','BoxStyle','full','Layer','top','LineWidth',1,...
    'TickLabelInterpreter','latex');
% Create colorbar
colorbar(axes1,'TickLabelInterpreter','latex','LineWidth',1,'FontSize',8.5);
caxis([0 1]);