%% Analysis of transition experiments data

clc
clear

%%

MainPresDirectory = '/home/ankit/ankit/Research/TARA/2021 Experiments/December/';
Date              = '10 Dec 2021';
PresDateDir       = ([MainPresDirectory Date '/']);
comb_exp_folder   = 'Combustion Experiments';
comb_trial_fol    = ([PresDateDir comb_exp_folder '/']);
trial_name        = 'Trial 7';
comb_trial_file   = ([comb_trial_fol trial_name '/']);
pres_files        = dir([comb_trial_file, '*.txt']);

MainPMTDirectory = '/home/ankit/ankit/Research/TARA/2021 Experiments/PMT/December/';
PMTDateDir       = ([MainPMTDirectory Date '/']);
PMT_trial_file   = ([PMTDateDir trial_name '/']);
PMT_files        = dir([PMT_trial_file, '*.txt']);

fs = 10000;
t = 0:1/fs:3-(1/fs);

EqRatio = [1 % Eqv ratio values at each data point; to be taken from reference spreadsheet 
0.97
0.94
0.91
0.88
0.85
0.82
0.79
0.76
0.73
0.7
0.68
0.66
0.64
0.62
0.6
0.58
0.58
0.58

];

%%

for file_num = 1:length(EqRatio)
    file_num
    
    file_name  = sprintf('%d.txt', file_num);
    pres_data  = load([comb_trial_file, file_name]);
    pmt_data   = load([PMT_trial_file, file_name]);
    
    p_near(:,file_num)  = pres_data(:,3)*1000/0.2175;
    p_far(:,file_num)   = pres_data(:,2)*1000/0.2175;
    pmt(:,file_num)     = pmt_data(:,2);
    
    pf_near(:,file_num) = p_near(:,file_num) - mean(p_near(:,file_num));
    pf_far(:,file_num)  = p_far(:,file_num)  - mean(p_far(:,file_num));
    pmtf(:,file_num)     = pmt(:,file_num) - mean(pmt(:,file_num));
    
    pnear_frms(file_num,:) = rms(pf_near(:,file_num));
    pfar_frms(file_num,:)  = rms(pf_far(:,file_num));
    pmt_frms(file_num,:)   = rms(pmtf(:,file_num));
    
end

%% Runs chaos 0-1 test

clc
counter = length(EqRatio)-1;
% counter = 23;
pf_K    = chaos_0_1_test(pf_near(:,counter),5)
pmtf_K  = chaos_0_1_test(pmtf(:,counter),10)
result  = zeros(1,2);
result(1,1) = pf_K;
result(1,2) = pmtf_K;
openvar('result');
%% Computes suppresssion values

n = 18;
result      = zeros(1,4);
result(1,1) = pnear_frms(n,1);  
result(1,2) = pnear_frms(n+1,1);
result(1,3) = pmt_frms(n,1);
result(1,4) = pmt_frms(n+1,1);

p_supp = (result(1,1)-result(1,2))/(result(1,1)-pnear_frms(1,1));
q_supp = (pmt_frms(n)-pmt_frms(n+1))/(pmt_frms(n)-pmt_frms(1,1));
result1(1,1) = p_supp*100;
result1(1,2) = q_supp*100;
openvar('result1')


%% Analysis using PLV, phases (Hilbert Transform), and Cross-Correlation Coeffecients

for counter = 1:length(EqRatio)
     pfar_p  = hilbert(pf_far(:,counter));
     pnear_p = hilbert(pf_near(:,counter));
     pmt_p   = hilbert(pmtf(:,counter));
     
     phase_pfar(:,counter)  = unwrap(angle(pfar_p));
     phase_pnear(:,counter) = unwrap(angle(pnear_p));
     phase_pmt(:,counter)   = unwrap(angle(pmt_p));
      
     plv_pnear_pmt(counter) = abs(sum(exp(1i*(phase_pnear(:,counter)-phase_pmt(:,counter))))/length(phase_pnear(:,counter)));
     plv_pfar_pmt(counter)  = abs(sum(exp(1i*(phase_pfar(:,counter) -phase_pmt(:,counter))))/length(phase_pfar(:,counter)));
     
%     cc_pfar_q_mat = corrcoef(pf_far(:,counter), pmtf(:,counter));
%     cc_pfar_q(counter) = cc_pfar_q_mat(1,2);
    
    cc_pnear_q_mat = corrcoef(pf_near(:,counter), pmtf(:,counter));
    cc_pnear_q(counter) = cc_pnear_q_mat(1,2);
end
cc_pnear_q(1,17)
% plv_pnear_pmt(1,20)


%% Find maxima indices

[pks_pffar,locs_pffar] = findpeaks(pf_far(:,14),'MinPeakDistance',40);
[pks_pfnear,locs_pfnear] = findpeaks(pf_near(:,14),'MinPeakDistance',40);
[pks_q,locs_q] = findpeaks(pmtf(:,14),'MinPeakDistance',40);
% findpeaks(pf_far(:,18),'MinPeakDistance',40)
% hold on
% pmtf1 = pmtf*4000;
% findpeaks(pmtf1(:,18),'MinPeakDistance',40)
% findpeaks(pf_far(:,18))

%% Return Maps

ts = pf_near(end/2:end,21);
figure();
findpeaks(ts,'MinPeakDistance',13)
% Create a refernce diagonal line
% plot(0:4,0:4,'r');  grid on;  hold on;

% Plot First maxima with the next next maxima called as 1st Return Map
lim = 2000;
[pks_a,locs_a]=findpeaks(ts,'MinPeakDistance',13);

plot(-lim:lim,-lim:lim,'Color', [ 0 0.616 0.679]);  
grid on;
hold on;
plot(pks_a(1:end-1),pks_a(2:end),'.','Color', [ 0 0.616 0.679])
axis tight
% title('First return map','fontsize',12,'fontweight','b')
xlabel('Max $p^\prime(i+1)$','fontsize',12,'fontweight','b','Interpreter', 'latex','FontAngle','italic')
ylabel('Max $p^\prime(i)$','fontsize',12,'fontweight','b','Interpreter', 'latex','FontAngle','italic')
xlim([-lim,lim]);
ylim([-lim,lim]);
% propedit
hold off;


%% Figures

subplot(221)

yyaxis left
plot(EqRatio,pfar_frms,'--d','MarkerEdgeColor',[0 0 1],'MarkerFaceColor',[0 0 1]);
xlabel('$\phi$','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
ylabel('$p^\prime_{rms}$ (Pa)','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
yyaxis right
plot(EqRatio,pmt_frms,'--o','MarkerEdgeColor',[1 0 0],'MarkerFaceColor',[1 0 0]);
ylabel('$\dot{q^\prime}_{rms}$ (a.u.)','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
% xlim([0.2 1.1])
set(gca,'TickLabelInterpreter','latex')
set(gca,'TickDir','out');
ax = gca;
ax.XAxis.FontSize = 20;
ax.YAxis(1).FontSize = 20;
ax.YAxis(2).FontSize = 20;

subplot(222)

yyaxis left
plot(EqRatio,plv_pnear_pmt,'--d','MarkerEdgeColor',[0 0 1],'MarkerFaceColor',[0 0 1]);
xlabel('$\phi$','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
ylabel('$PLV_{p^\prime, \dot{q^\prime}}$','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
yyaxis right
plot(EqRatio,cc_pnear_q,'--d','MarkerEdgeColor',[1 0 0],'MarkerFaceColor',[1 0 0]);
ylabel('$\rho$','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
set(gca,'TickLabelInterpreter','latex')
set(gca,'TickDir','out');
ax = gca;
ax.XAxis.FontSize = 20;
ax.YAxis(1).FontSize = 20;
ax.YAxis(2).FontSize = 20;

subplot(224)

plot(EqRatio,cc_pfar_q,'--d','MarkerEdgeColor',[0 0 1],'MarkerFaceColor',[0 0 1]);
xlabel('$\phi$','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
ylabel('$PLV_{p^\prime, \dot{q^\prime}}$','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
set(gca,'TickLabelInterpreter','latex')
set(gca,'TickDir','out');
ax = gca;
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;
%%

pf_near1 = pf_near(:,18);
pmtf1 = pmtf(:,18);

yyaxis left
plot(t,pf_near1,'LineWidth',1,'Color',[0 0.616 0.679]);
xlabel('time (s)','Interpreter', 'latex','fontsize',15,'fontweight','n','FontAngle','italic');
ylabel('$p^\prime$ (Pa)','Interpreter', 'latex','fontsize',15,'fontweight','n','FontAngle','italic');
ax = gca;
ax.XAxis.FontSize = 15;
ax.YAxis.FontSize = 15;


yyaxis right
figure(2)
plot(t,pmtf1,'LineWidth',1,'Color',[0.88 0.365 0.365]);
ylabel('$\dot{q^\prime}$ (a.u.)','Interpreter', 'latex','fontsize',15,'fontweight','n','FontAngle','italic');
set(gca,'TickLabelInterpreter','latex')
set(gca,'TickDir','out');
ax = gca;
% ax.YAxis.Color = [0.88 0.365 0.365];
ax.XAxis.FontSize = 15;
ax.YAxis.FontSize = 15;

ax.XAxis.FontSize = 15;
ax.YAxis(1).FontSize = 15;
ax.YAxis(2).FontSize = 15;
ax.YAxis(1).Color = [0 0.616 0.679];
ax.YAxis(2).Color = [0.88 0.365 0.365];
% xlim([1.16 1.22])


%%

pf_bc = pf_near(:,18);
pf_ac = pf_near(:,19);


plot(t,pf_bc,'LineWidth',1);
xlabel('time (s)','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
ylabel('$\dot{q}^\prime$ (a.u.)','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
 hold on

figure(2)
plot(t,pf_ac,'LineWidth',1);
% ylabel('$p^\prime$ (a.u.)','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
% xlim([0.2 1.1])
set(gca,'TickLabelInterpreter','latex')
set(gca,'TickDir','out');
ax = gca;
ax.XAxis.FontSize = 15;
ax.YAxis.FontSize = 15;
propedit

%%

phase_bc = phase_pnear(:,18) - phase_pmt(:,18);
phase_ac = phase_pnear(:,19) - phase_pmt(:,19);

plot(t,phase_bc,'LineWidth',2);
xlabel('time (s)','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
ylabel('$\Delta \phi_{p^\prime, \dot{q}^\prime}$','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
hold on
 
plot(t,phase_ac,'LineWidth',2);
% ylabel('$\dot{q^\prime}$ [a.u.]','Interpreter', 'latex','fontsize',22,'fontweight','n','FontAngle','italic');
% xlim([0.2 1.1])
set(gca,'TickLabelInterpreter','latex')
set(gca,'TickDir','out');
ax = gca;
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;

