%% Calculates and plots cross-wavelet spectrum and phase difference for a specific frequency

clc
clear

%% Input time series

length_coupling       = 160;

Camera_dataset_Folder = '/media/ankit/My Book/Ankit Sahay/Lab System/Self_coupling_TARA_data/TARA/Experiments/Camera_Data_Sets/';
Length_name           = sprintf('%d cm',length_coupling);
Length_folder         = ([Camera_dataset_Folder Length_name '/']);
Pressure_folder       = 'Pressure';
pres_data_Folder      = ([Length_folder Pressure_folder '/']);

file_num              = 2;
file_name             = sprintf('%d.txt', file_num);
pres_data             = load([pres_data_Folder, file_name]);
p_near                = pres_data(:,3)*1000/0.2134;
pf_near               = p_near - mean(p_near);

PMT_folder            = 'HRR';
pmt_data_Folder       = ([Length_folder PMT_folder '/']);
pmt_data              = load([pmt_data_Folder, file_name]);
pmt                   = pmt_data(:,2);
pmtf                  = pmt - mean(pmt);


fs = 10000; % sampling frequency
t = 1/fs:1/fs:3;

%%


% figure(12)
% subplot(121)
% plot(t,p), hold on, plot(t,q,'r'), hold off

% figure(13)
% % subplot(121)
% wcoherence(p,q,fs,'PhaseDisplayThreshold',0.95)
% colormap(jet) 

% figure('color',[1 1 1])
% xwt(p,q,fs)
% % title(['XWT: ' seriesname{1} '-' seriesname{2} ] )
% colormap jet 
% 
% figure('color',[1 1 1])
% wt(p)
% colormap(jet) 

%% Plot cross-wavelet spectrum

subplot(211)
% figure('color',[1 1 1])
% subplot(421)
t=0.0001:1/fs:3;
xwt([t' pf_near],[t' pmtf])
% Convert period scale to frequency scale on y-axis
freq=[4096 2048 1024 512 256 128 64 32 16 8 4 2 1];
set(gca,'ytick',log2(1./freq),'yticklabel',freq)
ylabel('Frequency (Hz)')
xlim([0 3])

%% FFT

pf_1  = pf_near;
T     = 1/fs;
L     = length(pf_1);           % Length of Pressure data in one column
nfft  = 2^nextpow2(L);         % New input length that is the next power of 2 from the original signal length
fVals = fs/2*linspace(0,1,nfft/2+1); % Frequency
kp    = fft(pf_1, nfft)/L;      % FFT
P1p   = 2*abs(kp(1:nfft/2+1)).^2; % Power Spectrum
Pxp   = 2*abs(kp(1:nfft/2+1)); % Amplitude spectrum

% HRR
pmtf_1 = pmtf;
kq     = fft(pmtf_1, nfft)/L;      % FFT
P1q    = 2*abs(kq(1:nfft/2+1)).^2; % Power Spectrum
Pxq    = 2*abs(kq(1:nfft/2+1)); % Amplitude spectrum

figure(2)
subplot(121)

plot(fVals, P1p, 'LineWidth',1);
xlim([100 300])
xlabel('$f$ (Hz)','Interpreter', 'latex','fontsize', 20,'fontweight','n','FontAngle','italic' );
ylabel('$|p^\prime (f)|$','Interpreter', 'latex','fontsize',15,'fontweight','n','FontAngle','italic');
set(gca,'TickLabelInterpreter','latex')
set(gca,'TickDir','out');
ax = gca;
ax.FontSize = 15;

subplot(122)

plot(fVals, P1q, 'LineWidth',1);
xlim([100 300])
xlabel('$f$ (Hz)','Interpreter', 'latex','fontsize', 20,'fontweight','n','FontAngle','italic' );
ylabel('$|p^\prime (f)|$','Interpreter', 'latex','fontsize',15,'fontweight','n','FontAngle','italic');
set(gca,'TickLabelInterpreter','latex')
set(gca,'TickDir','out');
ax = gca;
ax.FontSize = 15;

%% Calculate information at a particular frequency

dom_period = 1/126.038; % denominator corresponds to dominant frequency

[Wxy,period,scale,coi,sig95]=xwt([t' pf_near],[t' pmtf]);
[mn,rowix]=min(abs(period-dom_period)); %row with period closest to 11.
ChosenPeriod=period(rowix);
[meantheta,anglestrength,sigma]=anglemean(angle(Wxy(rowix,:)));
phdiff=meantheta*180/pi;

%% Plot phase difference
% Run this section after running "Plot cross-wavelet spectrum" section

% figure(3)
subplot(212)
theta = angle(Wxy(rowix,:))*180/pi;
% theta_wrapped = angle(Wxy(rowix,:));
% theta_unwrapped = unwrap(theta_wrapped);
% theta_unwrapped_deg = theta_unwrapped *180/pi;

plot(t,theta);
xlabel('$t$ (s)','Interpreter', 'latex','fontsize', 20,'fontweight','n','FontAngle','italic' );
ylabel('$\Delta \phi$','Interpreter', 'latex','fontsize',20,'fontweight','n','FontAngle','italic');
ylim([-180 180]);
set(gca,'TickDir','out');
ax = gca;
ax.FontSize = 18;
set(gca,'TickLabelInterpreter', 'tex');
