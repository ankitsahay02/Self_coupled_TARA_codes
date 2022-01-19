%% FFT of signals for checking signals frequency content

dt    = 1e-4;
N     = 30000;
t_arr = 0:dt:(N-1)*dt;
time  = t_arr;

counter = 18; % Used to extract time series from a dataset (columns correspond to different control parameter)

%% Pressure before coupling

pf_1  = pf_near(:,counter);
fs    = 1/(time(2)-time(1));
T     = 1/fs;
L     = length(pf_1);           % Length of Pressure data in one column
nfft  = 2^nextpow2(L);         % New input length that is the next power of 2 from the original signal length
fVals = fs/2*linspace(0,1,nfft/2+1); % Frequency
kp     = fft(pf_1, nfft)/L;      % FFT
P1p    = 2*abs(kp(1:nfft/2+1)).^2; % Power Spectrum
Pxp    = 2*abs(kp(1:nfft/2+1)); % Amplitude spectrum

%% Pressure after coupling

pf_2  = pf_near(:,counter+1);
kp2   = fft(pf_2, nfft)/L;      % FFT
P1p2  = 2*abs(kp2(1:nfft/2+1)).^2; % Power Spectrum
Pxp2  = 2*abs(kp2(1:nfft/2+1)); % Amplitude spectrum

%% HRR before coupling

pmtf_1 = pmtf(:,counter);
kq     = fft(pmtf_1, nfft)/L;      % FFT
P1q    = 2*abs(kq(1:nfft/2+1)).^2; % Power Spectrum
Pxq    = 2*abs(kq(1:nfft/2+1)); % Amplitude spectrum

%% HRR after coupling

pmtf_2 = pmtf(:,counter+1);
kq2     = fft(pmtf_2, nfft)/L;      % FFT
P1q2    = 2*abs(kq2(1:nfft/2+1)).^2; % Power Spectrum
Pxq2    = 2*abs(kq2(1:nfft/2+1)); % Amplitude spectrum

%%
figure()
subplot(121)

semilogy(fVals, P1p, 'LineWidth',1);
xlim([100 200])
xlabel('$f$ (Hz)','Interpreter', 'latex','fontsize', 20,'fontweight','n','FontAngle','italic' );
ylabel('$|p^\prime (f)|$','Interpreter', 'latex','fontsize',15,'fontweight','n','FontAngle','italic');
set(gca,'TickLabelInterpreter','latex')
set(gca,'TickDir','out');
ax = gca;
ax.FontSize = 15;
hold on;
semilogy(fVals, P1p2, 'LineWidth',1);
xlim([100 200])

hold off
subplot(122)

plot(fVals, P1q, 'LineWidth',1);
xlim([100 200])
xlabel('$f$ (Hz)','Interpreter', 'latex','fontsize', 20,'fontweight','n','FontAngle','italic' );
ylabel('$|p^\prime (f)|$','Interpreter', 'latex','fontsize',15,'fontweight','n','FontAngle','italic');
set(gca,'TickLabelInterpreter','latex')
set(gca,'TickDir','out');
ax = gca;
ax.FontSize = 15;
hold on;
plot(fVals, P1q2, 'LineWidth',1);
xlim([100 200])
