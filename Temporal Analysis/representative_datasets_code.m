%% Analysis of transition experiments data

clc
clear

%%

MainPresDirectory = '/home/ankit/ankit/Research/TARA/2021 Experiments/Representative_Data_Sets/Pressure/';
Length            = '190';
presLengthDir     = ([MainPresDirectory Length ' cm/']);

MainPMTDirectory = '/home/ankit/ankit/Research/TARA/2021 Experiments/Representative_Data_Sets/HRR/';
PMTLengthDir     = ([MainPMTDirectory Length ' cm/']);

fs   = 10000;
time = 0:1/fs:3-(1/fs);


%%

file_num = 2;

file_name  = sprintf('%d.txt', file_num);
pres_data  = load([presLengthDir, file_name]);
pmt_data   = load([PMTLengthDir, file_name]);

p_near  = pres_data(:,3)*1000/0.2134;
pmt     = pmt_data(:,2);

pf_near = p_near - mean(p_near);
pmtf    = pmt - mean(pmt);

pnear_frms = rms(pf_near);
pmt_frms   = rms(pmtf);

%% Analysis

fs    = 1/(time(2)-time(1));
T     = 1/fs;
L     = length(pf_near);           % Length of Pressure data in one column
nfft  = 2^nextpow2(L);         % New input length that is the next power of 2 from the original signal length
fVals = fs/2*linspace(0,1,nfft/2+1); % Frequency
kp     = fft(pf_near, nfft)/L;      % FFT
P1p    = 2*abs(kp(1:nfft/2+1)).^2; % Power Spectrum
Pxp    = 2*abs(kp(1:nfft/2+1)); % Amplitude spectrum
dBp    = pow2db(P1p);
dBp_smooth = smoothdata(dBp,'gaussian',5);

kq     = fft(pmtf, nfft)/L;      % FFT
P1q    = 2*abs(kq(1:nfft/2+1)).^2; % Power Spectrum
Pxq    = 2*abs(kq(1:nfft/2+1)); % Amplitude spectrum

%% Figures

subplot(431)
plot(time,pf_near,'LineWidth',1,'Color',[0 0.616 0.679])
xlim([0 3])
ylim([-7000 7000])
% xlabel('$t$ (s)','Interpreter', 'latex','fontsize',16,'fontweight','n','FontAngle','italic');
ylabel('$p^\prime$ (kPa)','Interpreter', 'latex','fontsize',16,'fontweight','n','FontAngle','italic');
set(gca, 'XTick', [0,1,2,3], 'XTickLabel', (0:1:3))
set(gca, 'YTick', [-7000,-3500,0,3500,7000], 'YTickLabel', [-7,-3.5,0,3.5,7])
set(gca,'TickLabelInterpreter','latex')
set(gca,'TickDir','out');
% set(gca,'Yticklabel',[]) 
set(gca,'Xticklabel',[]) %to just get rid of the numbers but leave the ticks.
ax = gca;
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 16;


subplot(432)
plot(fVals, dBp_smooth, 'LineWidth',1.5,'Color',[0 0.616 0.679]);
xlim([5 600])
ylim([-20 80])
% xlabel('$f$ (Hz)','Interpreter', 'latex','fontsize', 16,'fontweight','n','FontAngle','italic' );
ylabel('$\widehat{p^\prime}(f)$ (dB)','Interpreter', 'latex','fontsize',16,'fontweight','n','FontAngle','italic');
% title('FFT','Interpreter', 'latex','fontsize',20,'fontweight','n','FontAngle','italic');
set(gca, 'XTick', [5,200,400,600], 'XTickLabel', (0:200:600))
set(gca, 'YTick', [-20,0,20,40,60,80], 'YTickLabel', [-20,0,20,40,60,80])
% set(gca,'Yticklabel',[]) 
set(gca,'Xticklabel',[]) %to just get rid of the numbers but leave the ticks.
set(gca,'TickLabelInterpreter','latex')
set(gca,'TickDir','out');
ax = gca;
ax.FontSize = 16;

set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 1.5);

H = gcf;
H.WindowState = 'maximized';
pause(1)
savefig('190.fig')
close all


