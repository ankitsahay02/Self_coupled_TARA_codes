clc
clearvars

set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(0,'defaultAxesFontSize',20);

fs = 20000;
EqRatio = 1:-0.04:0.28;

%% Extract rms values from uncoupled experiments data

dir = '/home/ankit/ankit/Research/TARA/AD/AD in TARA/2020/JAN 2020/01.07.2020/Transition_to_TAI_uncoupled/';

for j = 1:length(EqRatio)
    phi = EqRatio(j)
    a = [dir,'' sprintf('%1.0f',j) '.txt'];
    data = importdata(a);
    p1r = 1000/0.2175*data(:,2);
    p1r_mean = mean(p1r); p1r_f = p1r-p1r_mean; p1r_frms(j,1) = rms(p1r_f);
    p2r = 1000/0.2175*data(:,3);
    p2r_mean= mean(p2r); p2r_f = p2r-p2r_mean; p2r_frms(j,1) = rms(p2r_f);
    q1r = 1000/0.2175*data(:,4);
    q1r_mean = mean(q1r); q1r_f = q1r-q1r_mean; q1r_frms(j,1) = rms(q1r_f);
    q2r = 1000/0.2175*data(:,5);
    q2r_mean= mean(q2r); q2r_f = q2r-q2r_mean; q2r_frms(j,1) = rms(q2r_f);
end

%% Extract rms values from coupled experiments data

dir = '/home/ankit/ankit/Research/TARA/AD/AD in TARA/2020/JAN 2020/01.14.2020/Expt 5/';

for j = 1:length(EqRatio)
    phi = EqRatio(j)
    a = [dir,'' sprintf('%1.0f',j) '.txt'];
    data = importdata(a);
    p1 = 1000/0.2175*data(:,2);
    p1_mean = mean(p1); p1_f = p1-p1_mean; p1_frms(j,1) = rms(p1_f);
    p2 = 1000/0.2175*data(:,3);
    p2_mean= mean(p2); p2_f = p2-p2_mean; p2_frms(j,1) = rms(p2_f);
    q1 = 1000/0.2175*data(:,4);
    q1_mean = mean(q1); q1_f = q1-q1_mean; q1_frms(j,1) = rms(q1_f);
    q2 = 1000/0.2175*data(:,5);
    q2_mean= mean(q2); q2_f = q2-q2_mean; q2_frms(j,1) = rms(q2_f);
    
end

%% Calculate percentage suppression

p1s = (p1r_frms - p1_frms)./p1r_frms;
q1s = (q1r_frms - q1_frms)./q1r_frms;
p2s = (p2r_frms - p2_frms)./p2r_frms;
q2s = (q2r_frms - q2_frms)./q2r_frms;

%% Save figures

figure(1)
subplot(221)
plot(EqRatio,p1s,'-ok', 'MarkerfaceColor','k');
xlabel('$\phi$','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
ylabel('$\Delta p_{1}^\prime$','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
% title(['PLV = ' num2str(plv_p1p2)],'interpreter','latex')
set(gca,'TickDir','out');
set(gca,'TickLabelInterpreter','latex','fontsize',20,'fontweight','n','FontAngle','italic')

subplot(222)
plot(EqRatio,q1s,'-or', 'MarkerfaceColor','r');
xlabel('$\phi$','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
ylabel('$\Delta q_{1}^\prime$','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
set(gca,'TickDir','out');
set(gca,'TickLabelInterpreter','latex','fontsize',20,'fontweight','n','FontAngle','italic')

subplot(223)
plot(EqRatio,p2s,'-ok', 'MarkerfaceColor','k');
xlabel('$\phi$','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
ylabel('$\Delta p_{2}^\prime$','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
set(gca,'TickDir','out');
set(gca,'TickLabelInterpreter','latex','fontsize',20,'fontweight','n','FontAngle','italic')

subplot(224)
plot(EqRatio,q2s,'-or', 'MarkerfaceColor','r');
xlabel('$\phi$','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
ylabel('$\Delta q_{2}^\prime$','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
set(gca,'TickDir','out');
set(gca,'TickLabelInterpreter','latex','fontsize',20,'fontweight','n','FontAngle','italic')

set(gcf, 'Position', get(0, 'Screensize'));

jpg_files = '/home/ankit/ankit/Research/TARA/AD/Results/Jan/14_01/5/coupled/';
baseFileName =  sprintf('suppression.jpg');
fullFileName = fullfile(jpg_files, baseFileName);
saveas(gcf, fullFileName,'jpg');
close all





