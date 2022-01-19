clc
clearvars

set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(0,'defaultAxesFontSize',20);

fs = 20000;
EqRatio = 1:-0.04:0.36;

for j = 1:length(EqRatio)
    phi = EqRatio(j)
    a = ['' sprintf('%1.0f',j) '.txt'];
    data = importdata(a);
    p1 = 1000/0.2175*data(:,2); % 0.2175 sensitivity factor to convert mV values to Pa units
    p1_mean = mean(p1); p1_f = p1-p1_mean; p1_frms = rms(p1_f); % Calculating fluctuations
    p2 = 1000/0.2175*data(:,3);
    p2_mean= mean(p2); p2_f = p2-p2_mean; p2_frms = rms(p2_f);
    q1 = 1000/0.2175*data(:,4);
    q1_mean = mean(q1); q1_f = q1-q1_mean; q1_frms = rms(q1_f);
    q2 = 1000/0.2175*data(:,5);
    q2_mean= mean(q2); q2_f = q2-q2_mean; q2_frms = rms(q2_f);
    
    t = 0+1/fs:1/fs:size(p1)/fs;
    %% Calculate phase difference
    
    p1_p = hilbert(p1_f); % Assuming that a centre of rotation exists
    p2_p = hilbert(p2_f);
    q1_p = hilbert(q1_f);
    q2_p = hilbert(q2_f);
    
    [phase_p1]=unwrap(angle(p1_p));
    [phase_p2]=unwrap(angle(p2_p));
    [phase_q1]=unwrap(angle(q1_p));
    [phase_q2]=unwrap(angle(q2_p));
    
    %     phase_p1p2 = rad2deg(wrapToPi(phase_p1-phase_p2));
    %     phase_q1q2 = rad2deg(wrapToPi(phase_q1-phase_q2));
    %     phase_p1q1 = rad2deg(wrapToPi(phase_p1-phase_q1));
    %     phase_p2q2 = rad2deg(wrapToPi(phase_p2-phase_q2));
    
    phase_p1p2 = phase_p1-phase_p2;
    phase_q1q2 = phase_q1-phase_q2;
    phase_p1q1 = phase_p1-phase_q1;
    phase_p2q2 = phase_p2-phase_q2;
    
    plv_p1p2 = abs(sum(exp(1i*(phase_p1-phase_p2)))/length(phase_p1p2)); % phase locking value
    plv_q1q2 = abs(sum(exp(1i*(phase_q1-phase_q2)))/length(phase_q1q2));
    plv_p1q1 = abs(sum(exp(1i*(phase_p1-phase_q1)))/length(phase_p1q1));
    plv_p2q2 = abs(sum(exp(1i*(phase_p2-phase_q2)))/length(phase_p2q2));
    
    figure(1)
    subplot(221)
    plot(t,phase_p1p2,'k');
    % ylim([-180 180])
    % yticks([-180 -90 0 90 180])
    % yticklabels({'-180','-90','0','90','180'})
    xlabel('$t(s)$','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
    ylabel('$\Delta \theta_{p_1^\prime,p_2^\prime}$','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
    title(['PLV = ' num2str(plv_p1p2)],'interpreter','latex')
    set(gca,'TickDir','out');
    set(gca,'TickLabelInterpreter','latex','fontsize',20,'fontweight','n','FontAngle','italic')
    
    subplot(222)
    plot(t,phase_q1q2,'k');
%     ylim([-180 180])
%     yticks([-180 -90 0 90 180])
%     yticklabels({'-180','-90','0','90','180'})
    xlabel('$t(s)$','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
    ylabel('$\Delta \theta_{q_1^\prime,q_2^\prime}$','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
    title(['PLV = ' num2str(plv_q1q2)],'interpreter','latex')
    set(gca,'TickDir','out');
    set(gca,'TickLabelInterpreter','latex','fontsize',20,'fontweight','n','FontAngle','italic')
    
    subplot(223)
    plot(t,phase_p1q1,'k');
%     ylim([-180 180])
%     yticks([-180 -90 0 90 180])
%     yticklabels({'-180','-90','0','90','180'})
    xlabel('$t(s)$','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
    ylabel('$\Delta \theta_{p_1^\prime,q_1^\prime}$','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
    title(['PLV = ' num2str(plv_p1q1)],'interpreter','latex')
    set(gca,'TickDir','out');
    set(gca,'TickLabelInterpreter','latex','fontsize',20,'fontweight','n','FontAngle','italic')
    
    subplot(224)
    plot(t,phase_p2q2,'k');
%     ylim([-180 180])
%     yticks([-180 -90 0 90 180])
%     yticklabels({'-180','-90','0','90','180'})
    xlabel('$t(s)$','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
    ylabel('$\Delta \theta_{p_2^\prime,q_2^\prime}$','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
    title(['PLV = ' num2str(plv_p2q2)],'interpreter','latex')
    set(gca,'TickDir','out');
    set(gca,'TickLabelInterpreter','latex','fontsize',20,'fontweight','n','FontAngle','italic')
    
    set(gcf, 'Position', get(0, 'Screensize'));
    
    jpg_files = '/home/ankit/ankit/Research/TARA/AD/Results/Jan/16_01/5/coupled/Phase_diff_PLV/';
    baseFileName =  sprintf('%.2f_eqvratio.jpg',phi);
    fullFileName = fullfile(jpg_files, baseFileName);
    saveas(gcf, fullFileName,'jpg');
    close all
end